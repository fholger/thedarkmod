/*****************************************************************************
                    The Dark Mod GPL Source Code

 This file is part of the The Dark Mod Source Code, originally based
 on the Doom 3 GPL Source Code as published in 2011.

 The Dark Mod Source Code is free software: you can redistribute it
 and/or modify it under the terms of the GNU General Public License as
 published by the Free Software Foundation, either version 3 of the License,
 or (at your option) any later version. For details, see LICENSE.TXT.

 Project: The Dark Mod (http://www.thedarkmod.com/)

******************************************************************************/
#include "precompiled.h"

#include "../tr_local.h"
#include "GpuOcclusionQueryStage.h"
#include "RenderBackend.h"
#include "../Profiling.h"
#include "../glsl.h"
#include "../GLSLProgramManager.h"

idCVar r_useGpuOcclusionQueries("r_useGpuOcclusionQueries", "0", CVAR_RENDERER|CVAR_INTEGER|CVAR_ARCHIVE, "Perform GPU occlusion queries for each light to potentially skip shadow/interaction rendering");

const int MAX_ENTITIES = 65536;
const int BUFFER_SIZE = MAX_ENTITIES * sizeof(uint32_t);

struct GpuOcclusionQueryStage::ShaderParams {
	idMat4 modelViewMatrix;
	int entityIndex;
	int padding[3];
};

GpuOcclusionQueryStage::GpuOcclusionQueryStage( DrawBatchExecutor* drawBatchExecutor )
	: drawBatchExecutor(drawBatchExecutor)
{
}

void GpuOcclusionQueryStage::Init() {
	uint maxShaderParamsArraySize = drawBatchExecutor->MaxShaderParamsArraySize<ShaderParams>();
	idDict defines;
	defines.Set( "MAX_SHADER_PARAMS", idStr::FormatNumber( maxShaderParamsArraySize ) );
	occlusionShader = programManager->LoadFromFiles( "occlusion", "stages/occlusion/occlusion.vert.glsl", "stages/occlusion/occlusion.frag.glsl", defines );

	qglGenBuffers(1, &visibilityBuffer);
	qglBindBuffer(GL_SHADER_STORAGE_BUFFER, visibilityBuffer);
	qglBufferStorage(GL_SHADER_STORAGE_BUFFER, BUFFER_SIZE, nullptr, GL_MAP_READ_BIT | GL_MAP_WRITE_BIT | GL_MAP_PERSISTENT_BIT|GL_MAP_COHERENT_BIT);
	visibilityMarkers = (int *)qglMapBufferRange(GL_SHADER_STORAGE_BUFFER, 0, BUFFER_SIZE, GL_MAP_READ_BIT|GL_MAP_WRITE_BIT|GL_MAP_PERSISTENT_BIT|GL_MAP_COHERENT_BIT);
}

void GpuOcclusionQueryStage::Shutdown() {
	qglBindBuffer(GL_SHADER_STORAGE_BUFFER, visibilityBuffer);
	qglUnmapBuffer(GL_SHADER_STORAGE_BUFFER);
	qglBindBuffer(GL_SHADER_STORAGE_BUFFER, 0);
	qglDeleteBuffers(1, &visibilityBuffer);
	visibilityBuffer = 0;
	visibilityMarkers = nullptr;
}

void GpuOcclusionQueryStage::TestOcclusion( const viewDef_t *viewDef ) {
	GL_PROFILE( "GpuOcclusionQueryStage" );
	if ( viewDef->numDrawSurfs < 100 ) {
		return;
	}

	memset(visibilityMarkers, 0, BUFFER_SIZE);
	int index = 0;
	for ( viewEntity_t *vEntity = viewDef->viewEntitys; vEntity; vEntity = vEntity->next ) {
		vEntity->occluderIndex = index++;		
		vEntity->visible = true;
	}
	for ( viewLight_t *vLight = viewDef->viewLights; vLight; vLight = vLight->next ) {
		vLight->visible = true;
	}
	
	qglBindBufferRange(GL_SHADER_STORAGE_BUFFER, 0, visibilityBuffer, 0, BUFFER_SIZE);
	occlusionShader->Activate();

	// decal surfaces may enable polygon offset
	qglPolygonOffset( r_offsetFactor.GetFloat(), r_offsetUnits.GetFloat() );

	GL_State( GLS_DEPTHFUNC_LESS | GLS_COLORMASK | GLS_DEPTHMASK | GLS_ALPHAMASK );

	vertexCache.BindVertex();

	BeginDrawBatch();
	for ( int i = 0; i < viewDef->numDrawSurfs; ++i ) {
		const drawSurf_t *drawSurf = viewDef->drawSurfs[i];
		if ( !ShouldDrawSurf( drawSurf ) ) {
			continue;
		}
		DrawSurf( drawSurf );
	}
	ExecuteDrawCalls();

	occlusionRenderSync = qglFenceSync(GL_SYNC_GPU_COMMANDS_COMPLETE, 0);
	GL_State( GLS_DEPTHFUNC_LESS );
}

void GpuOcclusionQueryStage::FetchResults( const viewDef_t *viewDef ) {
	GL_PROFILE( "FetchOcclusionResults" )
	if ( occlusionRenderSync == nullptr ) {
		return;
	}
	
	GLenum result = qglClientWaitSync( occlusionRenderSync, 0, 0 );
	while( result != GL_ALREADY_SIGNALED && result != GL_CONDITION_SATISFIED ) {
		result = qglClientWaitSync( occlusionRenderSync, GL_SYNC_FLUSH_COMMANDS_BIT, 1000000 );
		if( result == GL_WAIT_FAILED ) {
			assert( !"glClientWaitSync failed" );
			break;
		}
	}
	qglDeleteSync( occlusionRenderSync );
	occlusionRenderSync = nullptr;

	int entitiesTotal = 0;
	int entitiesOccluded = 0;
	for ( viewEntity_t *vEntity = viewDef->viewEntitys; vEntity; vEntity = vEntity->next ) {
		vEntity->visible = visibilityMarkers[vEntity->occluderIndex];
		++entitiesTotal;
		entitiesOccluded += (!vEntity->visible);
	}

	int lightsTotal = 0;
	int lightsOccluded = 0;
	for ( viewLight_t *vLight = viewDef->viewLights; vLight; vLight = vLight->next ) {
		vLight->visible = false;		
		for ( const drawSurf_t *surf = vLight->globalInteractions; surf; surf = surf->nextOnLight ) {
			vLight->visible |= surf->space->visible;
		}
		for ( const drawSurf_t *surf = vLight->localInteractions; surf; surf = surf->nextOnLight ) {
			vLight->visible |= surf->space->visible;
		}
		for ( const drawSurf_t *surf = vLight->translucentInteractions; surf; surf = surf->nextOnLight ) {
			vLight->visible |= surf->space->visible;
		}
		++lightsTotal;
		lightsOccluded += (!vLight->visible);
	}

	if ( r_useGpuOcclusionQueries.GetInteger() > 1 ) {
		common->Printf( "%d / %d entities occluded.\n", entitiesOccluded, entitiesTotal );
		common->Printf( "%d / %d lights occluded.\n", lightsOccluded, lightsTotal );
	}
}

bool GpuOcclusionQueryStage::ShouldDrawSurf(const drawSurf_t *surf) const {
    const idMaterial *shader = surf->material;

    if ( !shader->IsDrawn() ) {
        return false;
    }

    // some deforms may disable themselves by setting numIndexes = 0
    if ( !surf->numIndexes ) {
        return false;
    }

    // translucent surfaces don't put anything in the depth buffer and don't
    // test against it, which makes them fail the mirror clip plane operation
    if ( shader->Coverage() == MC_TRANSLUCENT ) {
        return false;
    }

    if ( !surf->ambientCache.IsValid() || !surf->indexCache.IsValid() ) {
        common->Printf( "LightOcclusionQueryStage: missing vertex or index cache\n" );
        return false;
    }

    if ( surf->material->GetSort() == SS_PORTAL_SKY && g_enablePortalSky.GetInteger() == 2 ) {
        return false;
    }

    // get the expressions for conditionals / color / texcoords
    const float *regs = surf->shaderRegisters;

    // if all stages of a material have been conditioned off, don't do anything
    int stage;
    for ( stage = 0; stage < shader->GetNumStages() ; stage++ ) {
        const shaderStage_t *pStage = shader->GetStage( stage );
        // check the stage enable condition
        if ( regs[ pStage->conditionRegister ] != 0 ) {
            break;
        }
    }
    return stage != shader->GetNumStages();
}

void GpuOcclusionQueryStage::DrawSurf( const drawSurf_t *surf ) {
	if ( surf->space->weaponDepthHack ) {
		// this is a state change, need to finish any previous calls
		ExecuteDrawCalls();
		RB_EnterWeaponDepthHack();
	}

	const idMaterial *shader = surf->material;

	if ( shader->TestMaterialFlag( MF_POLYGONOFFSET ) ) {
		// this is a state change, need to finish any previous calls
		ExecuteDrawCalls();
		qglEnable( GL_POLYGON_OFFSET_FILL );
		qglPolygonOffset( r_offsetFactor.GetFloat(), r_offsetUnits.GetFloat() * shader->GetPolygonOffset() );
	}

	IssueDrawCommand( surf );

	// reset polygon offset
	if ( shader->TestMaterialFlag( MF_POLYGONOFFSET ) ) {
		ExecuteDrawCalls();
		qglDisable( GL_POLYGON_OFFSET_FILL );
	}

	if ( surf->space->weaponDepthHack ) {
		ExecuteDrawCalls();
		RB_LeaveDepthHack();
	}
}

void GpuOcclusionQueryStage::IssueDrawCommand( const drawSurf_t *surf ) {
	ShaderParams &params = drawBatch.shaderParams[currentIndex];

	params.entityIndex = surf->space->occluderIndex;
	memcpy( params.modelViewMatrix.ToFloatPtr(), surf->space->modelViewMatrix, sizeof(idMat4) );

	drawBatch.surfs[currentIndex] = surf;
	++currentIndex;
	if ( currentIndex == drawBatch.maxBatchSize ) {
		ExecuteDrawCalls();
	}
}

void GpuOcclusionQueryStage::BeginDrawBatch() {
	currentIndex = 0;
	drawBatch = drawBatchExecutor->BeginBatch<ShaderParams>();
}

void GpuOcclusionQueryStage::ExecuteDrawCalls() {
	if (currentIndex == 0) {
		return;
	}

	drawBatchExecutor->ExecuteDrawVertBatch(currentIndex);
	BeginDrawBatch();
}
