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
#include "LightOcclusionQueryStage.h"
#include "RenderBackend.h"
#include "../Profiling.h"
#include "../glsl.h"
#include "../GLSLProgramManager.h"


struct LightOcclusionQueryStage::ShaderParams {
	idMat4 modelViewMatrix;
};

LightOcclusionQueryStage::LightOcclusionQueryStage( DrawBatchExecutor* drawBatchExecutor )
	: drawBatchExecutor(drawBatchExecutor)
{
}

void LightOcclusionQueryStage::Init() {
	uint maxShaderParamsArraySize = drawBatchExecutor->MaxShaderParamsArraySize<ShaderParams>();
	idDict defines;
	defines.Set( "MAX_SHADER_PARAMS", idStr::FormatNumber( maxShaderParamsArraySize ) );
	occlusionShader = programManager->LoadFromFiles( "occlusion", "stages/occlusion/occlusion.vert.glsl", "stages/occlusion/occlusion.frag.glsl", defines );
}

void LightOcclusionQueryStage::Shutdown() {}

void LightOcclusionQueryStage::TestOcclusion( viewLight_t *vLight ) {
	GL_PROFILE( "LightOcclusionQueryStage" );

	qglGenQueries(1, &vLight->occlusionQuery);
	occlusionShader->Activate();

	// decal surfaces may enable polygon offset
	qglPolygonOffset( r_offsetFactor.GetFloat(), r_offsetUnits.GetFloat() );

	GL_State( GLS_DEPTHFUNC_LESS | GLS_COLORMASK | GLS_DEPTHMASK | GLS_ALPHAMASK );

	vertexCache.BindVertex();

	idList<drawSurf_t *> drawSurfs;
	for (drawSurf_t *surf = vLight->globalInteractions; surf; surf = surf->nextOnLight) {
		drawSurfs.AddGrow( surf );
	}
	for (drawSurf_t *surf = vLight->localInteractions; surf; surf = surf->nextOnLight) {
		drawSurfs.AddGrow( surf );
	}

	qglBeginQuery(GL_ANY_SAMPLES_PASSED, vLight->occlusionQuery);

	BeginDrawBatch();
	for ( const drawSurf_t *drawSurf : drawSurfs ) {
		if ( !ShouldDrawSurf( drawSurf ) ) {
			continue;
		}
		DrawSurf( drawSurf );
	}
	ExecuteDrawCalls();

	qglEndQuery(GL_ANY_SAMPLES_PASSED);
}

bool LightOcclusionQueryStage::ShouldDrawSurf(const drawSurf_t *surf) const {
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

void LightOcclusionQueryStage::DrawSurf( const drawSurf_t *surf ) {
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

void LightOcclusionQueryStage::IssueDrawCommand( const drawSurf_t *surf ) {
	ShaderParams &params = drawBatch.shaderParams[currentIndex];

	memcpy( params.modelViewMatrix.ToFloatPtr(), surf->space->modelViewMatrix, sizeof(idMat4) );

	drawBatch.surfs[currentIndex] = surf;
	++currentIndex;
	if ( currentIndex == drawBatch.maxBatchSize ) {
		ExecuteDrawCalls();
	}
}

void LightOcclusionQueryStage::BeginDrawBatch() {
	currentIndex = 0;
	drawBatch = drawBatchExecutor->BeginBatch<ShaderParams>();
}

void LightOcclusionQueryStage::ExecuteDrawCalls() {
	if (currentIndex == 0) {
		return;
	}

	drawBatchExecutor->ExecuteDrawVertBatch(currentIndex);
	BeginDrawBatch();
}
