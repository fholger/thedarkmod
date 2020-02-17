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
#pragma hdrstop

#include "AmbientOcclusion.h"
#include "Image.h"
#include "tr_local.h"
#include "GLSLProgramManager.h"
#include "GLSLProgram.h"
#include "Profiling.h"

idCVar r_ssao( "r_ssao", "0", CVAR_BOOL|CVAR_RENDERER|CVAR_ARCHIVE, "Enable screen space ambient occlusion" );

AmbientOcclusion ambientOcclusionImpl;
AmbientOcclusion *ambientOcclusion = &ambientOcclusionImpl;


static void CreateSSAOColorBuffer(idImage *image) {
	image->type = TT_2D;
	image->GenerateAttachment(r_customHeight.GetInteger(), r_customHeight.GetInteger(), GL_RED);
}

AmbientOcclusion::AmbientOcclusion() : ssaoFBO(0), ssaoColorBuffer(nullptr), ssaoShader(nullptr) {
}

void AmbientOcclusion::Init() {
	ssaoColorBuffer = globalImages->ImageFromFunction("SSAO ColorBuffer", CreateSSAOColorBuffer);
	qglGenFramebuffers(1, &ssaoFBO);
	qglBindFramebuffer(GL_FRAMEBUFFER, ssaoFBO);
	qglFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, ssaoColorBuffer->texnum, 0);
	ssaoShader = programManager->Find( "ssao" );
	if( ssaoShader == nullptr ) {
		ssaoShader = programManager->LoadFromFiles( "ssao", "ssao.vert.glsl", "ssao.frag.glsl" );
	}
}

void AmbientOcclusion::Shutdown() {
	if (ssaoFBO != 0) {
		qglDeleteFramebuffers(1, &ssaoFBO);
	}
	if (ssaoColorBuffer != nullptr) {
		ssaoColorBuffer->PurgeImage();
	}
}

extern GLuint fboPrimary;
void AmbientOcclusion::ComputeSSAOFromDepth() {
	if( ssaoFBO == 0 ) {
		Init();
	}

	GL_PROFILE( "SSAO" );

	qglBindFramebuffer( GL_FRAMEBUFFER, ssaoFBO );
	GL_SelectTexture( 0 );
	globalImages->currentDepthImage->Bind();
	ssaoShader->Activate();

	RB_DrawFullScreenQuad();

	// FIXME: this is a bit hacky
	qglBindFramebuffer( GL_FRAMEBUFFER, fboPrimary );
}
