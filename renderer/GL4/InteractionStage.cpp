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
#include "InteractionStage.h"
#include "../GLSLProgramManager.h"
#include "../Profiling.h"
#include "../FrameBuffer.h"
#include "../GLSLProgram.h"
#include "GL4Backend.h"
#include "../GLSLUniforms.h"

struct InteractionShaderParams {
	idMat4 modelMatrix;
	idMat4 modelViewMatrix;
	idVec4 bumpMatrix[2];
	idVec4 diffuseMatrix[2];
	idVec4 specularMatrix[2];
	idMat4 lightProjectionFalloff;
	idVec4 colorModulate;
	idVec4 colorAdd;
	idVec4 lightOrigin;
	idVec4 viewOrigin;
	idVec4 diffuseColor;
	idVec4 specularColor;
	idVec4 hasTextureDNS;
	idVec4 ambientRimColor;
	uint64_t normalTexture;
	uint64_t diffuseTexture;
	uint64_t specularTexture;
	uint64_t lightProjectionTexture;
	uint64_t lightFalloffTexture;
	uint64_t padding;
};

struct InteractionUniforms : GLSLUniformGroup {
	UNIFORM_GROUP_DEF( InteractionUniforms )

	DEFINE_UNIFORM( int, RGTC )
	DEFINE_UNIFORM( int, cubic )
	DEFINE_UNIFORM( int, shadows )
	DEFINE_UNIFORM( int, ambient )
	DEFINE_UNIFORM( float, minLevel )
	DEFINE_UNIFORM( float, gamma )
};

InteractionStage::InteractionStage()
	: interactionShader(nullptr) {
	
}

void InteractionStage::Init() {
    interactionShader = programManager->Find("GL4Interaction");
    if (interactionShader == nullptr) {
        interactionShader = programManager->LoadFromFiles("GL4Interaction", "gl4/interaction.vert.glsl", "gl4/interaction.frag.glsl");
    }
}

void InteractionStage::Shutdown() {}

void InteractionStage::Draw( const viewDef_t *viewDef ) {
	GL_PROFILE("InteractionStage");

	if ( r_fboSRGB && !backEnd.viewDef->IsLightGem() ) {
		qglEnable( GL_FRAMEBUFFER_SRGB );
	}

	// for each light, perform adding and shadowing
	extern void RB_GLSL_DrawInteractions_SingleLight();
	for ( viewLight_t *vLight = viewDef->viewLights; vLight; vLight = vLight->next ) {
		DrawInteractionsForLight( viewDef, vLight );
	}

	backEnd.depthFunc = GLS_DEPTHFUNC_EQUAL;
	qglDisable( GL_FRAMEBUFFER_SRGB );
	qglStencilFunc( GL_ALWAYS, 128, 255 );
	GLSLProgram::Deactivate();
}

void InteractionStage::DrawInteractionsForLight( const viewDef_t *viewDef, viewLight_t *vLight ) {
	// TODO: compatibility with existing code
	backEnd.vLight = vLight;

	// do fogging later
	if ( vLight->lightShader->IsFogLight() ) {
		return;
	}

	if ( vLight->lightShader->IsBlendLight() ) {
		return;
	}

	// if there are no interactions, get out!
	if ( !vLight->localInteractions && !vLight->globalInteractions && !vLight->translucentInteractions ) {
		return;
	}

	GL_PROFILE("Interactions_SingleLight");

	// TODO: shadow generation belongs in a separate stage
	// TODO: shadow maps currently don't support parallel lights, they are handed off to stencil, which we don't support
	extern void RB_GLSL_DrawInteractions_ShadowMap( const drawSurf_t *surf, bool clear = false );
	if ( vLight->shadows == LS_MAPS && vLight->lightShader->LightCastsShadows() ) {
		//RB_GLSL_DrawInteractions_ShadowMap( vLight->globalInteractions, true );
	}
	GL_State( GLS_SRCBLEND_ONE | GLS_DSTBLEND_ONE | GLS_DEPTHMASK | GLS_DEPTHFUNC_EQUAL );
	CreateDrawCommandsForInteractions( vLight, vLight->localInteractions );
	if ( vLight->shadows == LS_MAPS && vLight->lightShader->LightCastsShadows() ) {
		//RB_GLSL_DrawInteractions_ShadowMap( vLight->localInteractions );
	}
	GL_State( GLS_SRCBLEND_ONE | GLS_DSTBLEND_ONE | GLS_DEPTHMASK | GLS_DEPTHFUNC_EQUAL );
	CreateDrawCommandsForInteractions( vLight, vLight->globalInteractions );

	qglStencilFunc( GL_ALWAYS, 128, 255 );
	GL_State( GLS_SRCBLEND_ONE | GLS_DSTBLEND_ONE | GLS_DEPTHMASK | GLS_DEPTHFUNC_LESS );
	CreateDrawCommandsForInteractions(vLight, vLight->translucentInteractions);
}

void InteractionStage::CreateDrawCommandsForInteractions( viewLight_t *vLight, const drawSurf_t *interactions ) {
	if ( interactions == nullptr ) {
		return;
	}

	GL_PROFILE("DrawInteractions");
	interactionShader->Activate();
	InteractionUniforms *uniforms = interactionShader->GetUniformGroup<InteractionUniforms>();
	uniforms->RGTC.Set( globalImages->image_useNormalCompression.GetInteger() == 2 ? 1 : 0 );
	uniforms->cubic.Set( vLight->lightShader->IsCubicLight() ? 1 : 0 );
	uniforms->ambient.Set( vLight->lightShader->IsAmbientLight() ? 1 : 0 );
	uniforms->minLevel.Set( backEnd.viewDef->IsLightGem() ? 0 : r_ambientMinLevel.GetFloat() );
	uniforms->gamma.Set( backEnd.viewDef->IsLightGem() ? 1 : r_ambientGamma.GetFloat() );


	if ( r_useScissor.GetBool() && !backEnd.currentScissor.Equals( vLight->scissorRect ) ) {
		backEnd.currentScissor = vLight->scissorRect;
		GL_Scissor( backEnd.viewDef->viewport.x1 + backEnd.currentScissor.x1,
		            backEnd.viewDef->viewport.y1 + backEnd.currentScissor.y1,
		            backEnd.currentScissor.x2 + 1 - backEnd.currentScissor.x1,
		            backEnd.currentScissor.y2 + 1 - backEnd.currentScissor.y1 );
		GL_CheckErrors();
	}

	// perform setup here that will be constant for all interactions
    qglBindBuffer(GL_ELEMENT_ARRAY_BUFFER, vertexCache.GetIndexBuffer());
	FB_BindShadowTexture();

	drawCommands = gl4Backend->GetDrawCommandBuffer();
	shaderParams = gl4Backend->GetShaderParamBuffer<InteractionShaderParams>();
	currentIndex = 0;

	for ( const drawSurf_t *surf = interactions; surf != nullptr; surf = surf->nextOnLight ) {
		if ( surf->dsFlags & DSF_SHADOW_MAP_ONLY ) {
			continue;
		}

		// this may cause RB_GLSL_DrawInteraction to be executed multiple
		// times with different colors and images if the surface or light have multiple layers
		CreateDrawCommandsForSingleSurface( surf );
	}

	if (currentIndex > 0) {
		gl4Backend->BindShaderParams<InteractionShaderParams>( currentIndex, GL_SHADER_STORAGE_BUFFER, 0 );
		gl4Backend->MultiDrawIndirect( currentIndex );
	}	
}

extern void R_SetDrawInteraction( const shaderStage_t *surfaceStage, const float *surfaceRegs, idImage **image, idVec4 matrix[2], float color[4] );

void InteractionStage::CreateDrawCommandsForSingleSurface( const drawSurf_t *surf ) {
	const idMaterial	*material = surf->material;
	const float			*surfaceRegs = surf->shaderRegisters;
	const viewLight_t	*vLight = backEnd.vLight;
	const idMaterial	*lightShader = vLight->lightShader;
	const float			*lightRegs = vLight->shaderRegisters;
	drawInteraction_t	inter;

	if ( !surf->ambientCache.IsValid() || !surf->indexCache.IsValid() ) {
		return;
	}

	if ( vLight->lightShader->IsAmbientLight() ) {
		if ( r_skipAmbient.GetInteger() & 2 )
			return;
		auto ambientRegs = material->GetAmbientRimColor().registers;
		if ( ambientRegs[0] ) {
			for ( int i = 0; i < 3; i++ )
				inter.ambientRimColor[i] = surfaceRegs[ambientRegs[i]];
			inter.ambientRimColor[3] = 1;
		} else
			inter.ambientRimColor.Zero();
	} else if ( r_skipInteractions.GetBool() ) 
		return;

	// TODO: implement in shader? hack depth range if needed
	/*if ( surf->space->weaponDepthHack ) {
		RB_EnterWeaponDepthHack();
		GL_CheckErrors();
	}

	if ( surf->space->modelDepthHack != 0.0f ) {
		RB_EnterModelDepthHack( surf->space->modelDepthHack );
		GL_CheckErrors();
	}*/
	inter.surf = surf;
	inter.lightFalloffImage = vLight->falloffImage;

	R_GlobalPointToLocal( surf->space->modelMatrix, vLight->globalLightOrigin, inter.localLightOrigin.ToVec3() );
	R_GlobalPointToLocal( surf->space->modelMatrix, backEnd.viewDef->renderView.vieworg, inter.localViewOrigin.ToVec3() );
	inter.localLightOrigin[3] = 0;
	inter.localViewOrigin[3] = 1;
	inter.cubicLight = lightShader->IsCubicLight(); // nbohr1more #3881: cubemap lights
	inter.ambientLight = lightShader->IsAmbientLight();

	// rebb: world-up vector in local coordinates, required for certain effects, currently only for ambient lights. alternatively pass whole modelMatrix and calculate in shader
	// nbohr1more #3881: cubemap lights further changes
	if ( lightShader->IsAmbientLight() ) {
		inter.worldUpLocal.x = surf->space->modelMatrix[2];
		inter.worldUpLocal.y = surf->space->modelMatrix[6];
		inter.worldUpLocal.z = surf->space->modelMatrix[10];
	}

	// the base projections may be modified by texture matrix on light stages
	idPlane lightProject[4];
	R_GlobalPlaneToLocal( surf->space->modelMatrix, backEnd.vLight->lightProject[0], lightProject[0] );
	R_GlobalPlaneToLocal( surf->space->modelMatrix, backEnd.vLight->lightProject[1], lightProject[1] );
	R_GlobalPlaneToLocal( surf->space->modelMatrix, backEnd.vLight->lightProject[2], lightProject[2] );
	R_GlobalPlaneToLocal( surf->space->modelMatrix, backEnd.vLight->lightProject[3], lightProject[3] );

	for ( int lightStageNum = 0; lightStageNum < lightShader->GetNumStages(); lightStageNum++ ) {
		const shaderStage_t	*lightStage = lightShader->GetStage( lightStageNum );

		// ignore stages that fail the condition
		if ( !lightRegs[lightStage->conditionRegister] ) {
			continue;
		}
		inter.lightImage = lightStage->texture.image;

		memcpy( inter.lightProjection, lightProject, sizeof( inter.lightProjection ) );

		// now multiply the texgen by the light texture matrix
		if ( lightStage->texture.hasMatrix ) {
			RB_GetShaderTextureMatrix( lightRegs, &lightStage->texture, backEnd.lightTextureMatrix );
			extern void RB_BakeTextureMatrixIntoTexgen( idPlane lightProject[3], const float *textureMatrix );
			RB_BakeTextureMatrixIntoTexgen( reinterpret_cast<class idPlane *>(inter.lightProjection), backEnd.lightTextureMatrix );
		}
		inter.bumpImage = NULL;
		inter.specularImage = NULL;
		inter.diffuseImage = NULL;
		inter.diffuseColor[0] = inter.diffuseColor[1] = inter.diffuseColor[2] = inter.diffuseColor[3] = 0;
		inter.specularColor[0] = inter.specularColor[1] = inter.specularColor[2] = inter.specularColor[3] = 0;

		// backEnd.lightScale is calculated so that lightColor[] will never exceed
		// tr.backEndRendererMaxLight
		float lightColor[4] = {
			lightColor[0] = backEnd.lightScale * lightRegs[lightStage->color.registers[0]],
			lightColor[1] = backEnd.lightScale * lightRegs[lightStage->color.registers[1]],
			lightColor[2] = backEnd.lightScale * lightRegs[lightStage->color.registers[2]],
			lightColor[3] = lightRegs[lightStage->color.registers[3]]
		};

		// go through the individual stages
		for ( int surfaceStageNum = 0; surfaceStageNum < material->GetNumStages(); surfaceStageNum++ ) {
			const shaderStage_t	*surfaceStage = material->GetStage( surfaceStageNum );
			// ignore stage that fails the condition
			if ( !surfaceRegs[ surfaceStage->conditionRegister ] ) {
				continue;
			}

			switch ( surfaceStage->lighting ) {
			case SL_AMBIENT: {
				// ignore ambient stages while drawing interactions
				break;
			}
			case SL_BUMP: {				
				if ( !r_skipBump.GetBool() ) {
					CreateDrawCommand( &inter ); // draw any previous interaction
					inter.diffuseImage = NULL;
					inter.specularImage = NULL;
					R_SetDrawInteraction( surfaceStage, surfaceRegs, &inter.bumpImage, inter.bumpMatrix, NULL );
				}
				break;
			}
			case SL_DIFFUSE: {
				if ( inter.diffuseImage ) {
					CreateDrawCommand( &inter );
				}
				R_SetDrawInteraction( surfaceStage, surfaceRegs, &inter.diffuseImage,
				                      inter.diffuseMatrix, inter.diffuseColor.ToFloatPtr() );
				inter.diffuseColor[0] *= lightColor[0];
				inter.diffuseColor[1] *= lightColor[1];
				inter.diffuseColor[2] *= lightColor[2];
				inter.diffuseColor[3] *= lightColor[3];
				inter.vertexColor = surfaceStage->vertexColor;
				break;
			}
			case SL_SPECULAR: {
				// nbohr1more: #4292 nospecular and nodiffuse fix
				if ( backEnd.vLight->noSpecular ) {
					break;
				} 
				if ( inter.specularImage ) {
					CreateDrawCommand( &inter );
				}
				R_SetDrawInteraction( surfaceStage, surfaceRegs, &inter.specularImage,
				                      inter.specularMatrix, inter.specularColor.ToFloatPtr() );
				inter.specularColor[0] *= lightColor[0];
				inter.specularColor[1] *= lightColor[1];
				inter.specularColor[2] *= lightColor[2];
				inter.specularColor[3] *= lightColor[3];
				inter.vertexColor = surfaceStage->vertexColor;
				break;
			}
			}
		}

		// draw the final interaction
		CreateDrawCommand( &inter );
		GL_CheckErrors();
	}

	// unhack depth range if needed
	/*if ( surf->space->weaponDepthHack || surf->space->modelDepthHack != 0.0f ) {
		RB_LeaveDepthHack();
		GL_CheckErrors();
	}*/
}

void InteractionStage::CreateDrawCommand( drawInteraction_t *din ) {
	if ( !din->bumpImage && !r_skipBump.GetBool() )
		return;

	if ( !din->diffuseImage || r_skipDiffuse.GetBool() ) {
		din->diffuseImage = globalImages->blackImage;
	}

	if ( !din->specularImage || r_skipSpecular.GetBool() ) {
		din->specularImage = globalImages->blackImage;
	}

	int cmdIndex = currentIndex++;
	InteractionShaderParams &params = shaderParams[cmdIndex];
	DrawElementsIndirectCommand &command = drawCommands[cmdIndex];

	memcpy(params.modelMatrix.ToFloatPtr(), din->surf->space->modelMatrix, sizeof(idMat4));
	memcpy(params.modelViewMatrix.ToFloatPtr(), din->surf->space->modelViewMatrix, sizeof(idMat4));

	din->lightFalloffImage->MakeResident();
	din->lightImage->MakeResident();
	params.lightFalloffTexture = din->lightFalloffImage->BindlessHandle();
	params.lightProjectionTexture = din->lightImage->BindlessHandle();

	memcpy(params.diffuseMatrix[0].ToFloatPtr(), din->diffuseMatrix[0].ToFloatPtr(), 2 * sizeof(idVec4));
	din->diffuseImage->MakeResident();
	params.diffuseTexture = din->diffuseImage->BindlessHandle();

	if ( din->bumpImage ) {
		memcpy(params.bumpMatrix[0].ToFloatPtr(), din->bumpMatrix[0].ToFloatPtr(), 2 * sizeof(idVec4));
		din->bumpImage->MakeResident();
		params.normalTexture = din->bumpImage->BindlessHandle();
	}
	memcpy(params.specularMatrix[0].ToFloatPtr(), din->specularMatrix[0].ToFloatPtr(), 2 * sizeof(idVec4));
	din->specularImage->MakeResident();
	params.specularTexture = din->specularImage->BindlessHandle();

	static const idVec4	zero   { 0, 0, 0, 0 },
	                    one	   { 1, 1, 1, 1 },
	                    negOne { -1, -1, -1, -1 };
	switch ( din->vertexColor ) {
	case SVC_IGNORE:
		params.colorModulate = zero;
		params.colorAdd = one;
		break;
	case SVC_MODULATE:
		params.colorModulate = one;
		params.colorAdd = zero;
		break;
	case SVC_INVERSE_MODULATE:
		params.colorModulate = negOne;
		params.colorAdd = one;
		break;
	}

	memcpy(params.lightProjectionFalloff.ToFloatPtr(), din->lightProjection[0].ToFloatPtr(), sizeof(idMat4));
	// set the constant color
	params.diffuseColor = din->diffuseColor;
	params.specularColor = din->specularColor;
	params.viewOrigin = din->localViewOrigin;
	params.ambientRimColor = din->ambientRimColor;

	if (backEnd.vLight->lightShader->IsAmbientLight()) {
		params.lightOrigin = din->worldUpLocal;		
		//rimColor.Set( din->ambientRimColor );
	} else {
		params.lightOrigin = din->localLightOrigin;
	}

	if ( !din->bumpImage ) {
		params.hasTextureDNS = idVec4(1, 0, 1, 0);
	} else {
		params.hasTextureDNS = idVec4(1, 1, 1, 0);
	}

    command.count = din->surf->numIndexes;
    command.instanceCount = 1;
    command.firstIndex = din->surf->indexCache.offset / sizeof(glIndex_t);
    command.baseVertex = din->surf->ambientCache.offset / sizeof(idDrawVert);
    command.baseInstance = cmdIndex;
}

