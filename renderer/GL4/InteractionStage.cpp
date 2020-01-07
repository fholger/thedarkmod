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
#include <nb30.h>

InteractionStage::InteractionStage()
	: interactionShader(nullptr) {
	
}

void InteractionStage::Init() {
    interactionShader = programManager->Find("GL4Depth");
    if (interactionShader == nullptr) {
        interactionShader = programManager->LoadFromFiles("GL4Interaction", "gl4/interaction.vert.glsl", "gl4/interaction.frag.glsl");
    }
}

void InteractionStage::Shutdown() {}

void InteractionStage::Draw( const viewDef_t *viewDef ) {
	GL_PROFILE("InteractionStage");

	if ( r_fboSRGB && !backEnd.viewDef->IsLightGem() )
		qglEnable( GL_FRAMEBUFFER_SRGB );

	// for each light, perform adding and shadowing
	extern void RB_GLSL_DrawInteractions_SingleLight();
	for ( viewLight_t *vLight = viewDef->viewLights; vLight; vLight = vLight->next ) {
		DrawInteractionsForLight( viewDef, vLight );
	}

	qglDisable( GL_FRAMEBUFFER_SRGB );
	qglStencilFunc( GL_ALWAYS, 128, 255 );
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

	// TODO: shadow generation belongs in a separate stage
	extern void RB_GLSL_DrawLight_ShadowMap();
	if ( backEnd.vLight->shadows == LS_MAPS ) {
		RB_GLSL_DrawLight_ShadowMap();
	} else {
		// not supporting stencil
		// RB_GLSL_DrawLight_Stencil();
	}

	qglStencilFunc( GL_ALWAYS, 128, 255 );
	backEnd.depthFunc = GLS_DEPTHFUNC_LESS;
	RB_GLSL_CreateDrawInteractions( backEnd.vLight->translucentInteractions );
	backEnd.depthFunc = GLS_DEPTHFUNC_EQUAL;
}
