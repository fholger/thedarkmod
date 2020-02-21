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
#include "GLSLUniforms.h"

idCVar r_ssao( "r_ssao", "0", CVAR_BOOL|CVAR_RENDERER|CVAR_ARCHIVE, "Enable screen space ambient occlusion" );
idCVar r_ssao_radius( "r_ssao_radius", "0.001", CVAR_FLOAT|CVAR_RENDERER|CVAR_ARCHIVE, "Screen space sample radius" );
idCVar r_ssao_bias( "r_ssao_bias", "0.000001", CVAR_FLOAT|CVAR_RENDERER|CVAR_ARCHIVE, "Min depth difference to count for occlusion" );
idCVar r_ssao_area( "r_ssao_area", "0.0075", CVAR_FLOAT|CVAR_RENDERER|CVAR_ARCHIVE, "SSAO area" );
idCVar r_ssao_strength( "r_ssao_strength", "1", CVAR_FLOAT|CVAR_RENDERER|CVAR_ARCHIVE, "SSAO strength" );
idCVar r_ssao_base( "r_ssao_base", "0.1", CVAR_FLOAT|CVAR_RENDERER|CVAR_ARCHIVE, "Min value" );

AmbientOcclusion ambientOcclusionImpl;
AmbientOcclusion *ambientOcclusion = &ambientOcclusionImpl;

namespace {
	struct AOUniforms : GLSLUniformGroup {
		UNIFORM_GROUP_DEF( AOUniforms )

		DEFINE_UNIFORM( sampler, depthTexture )
		DEFINE_UNIFORM( sampler, noiseTexture )
		DEFINE_UNIFORM( vec2, screenResolution )
		DEFINE_UNIFORM( float, sampleRadius )
		DEFINE_UNIFORM( float, depthBias )
		DEFINE_UNIFORM( float, area )
		DEFINE_UNIFORM( float, totalStrength )
		DEFINE_UNIFORM( float, baseValue )
	};

	void CreateSSAOColorBuffer(idImage *image) {
		image->type = TT_2D;
		image->GenerateAttachment(r_customWidth.GetInteger(), r_customHeight.GetInteger(), GL_COLOR);
	}

	void CreateSSAONoiseTexture(idImage *image) {
		idRandom rnd( 12345 );
		idList<idVec3> noise;
		for (int i = 0; i < 16; ++i) {
			idVec3 randomVec( rnd.RandomFloat(), rnd.RandomFloat(), rnd.RandomFloat() );
			noise.Append( randomVec );
		}
		image->type = TT_2D;
		image->uploadWidth = 4;
		image->uploadHeight = 4;
		qglGenTextures( 1, &image->texnum );
		qglBindTexture( GL_TEXTURE_2D, image->texnum );
		qglTexImage2D( GL_TEXTURE_2D, 0, GL_RGB16F, 4, 4, 0, GL_RGB, GL_FLOAT, noise.Ptr() );
		qglTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MIN_FILTER, GL_NEAREST );
		qglTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_MAG_FILTER, GL_NEAREST );
		qglTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT );
		qglTexParameteri( GL_TEXTURE_2D, GL_TEXTURE_WRAP_S, GL_REPEAT );
	}
}

AmbientOcclusion::AmbientOcclusion() : ssaoFBO(0), ssaoColorBuffer(nullptr), ssaoNoise(nullptr), ssaoShader(nullptr) {
}

void AmbientOcclusion::Init() {
	ssaoColorBuffer = globalImages->ImageFromFunction("SSAO ColorBuffer", CreateSSAOColorBuffer);
	ssaoNoise = globalImages->ImageFromFunction( "SSAO Noise", CreateSSAONoiseTexture );
	qglGenFramebuffers(1, &ssaoFBO);
	qglBindFramebuffer(GL_FRAMEBUFFER, ssaoFBO);
	qglFramebufferTexture2D(GL_FRAMEBUFFER, GL_COLOR_ATTACHMENT0, GL_TEXTURE_2D, ssaoColorBuffer->texnum, 0);
	ssaoShader = programManager->Find( "ssao" );
	if( ssaoShader == nullptr ) {
		ssaoShader = programManager->LoadFromFiles( "ssao", "ssao.vert.glsl", "ssao.frag.glsl" );
	}
	qglBindFramebuffer(GL_FRAMEBUFFER, 0);
}

void AmbientOcclusion::Shutdown() {
	if (ssaoFBO != 0) {
		qglDeleteFramebuffers(1, &ssaoFBO);
	}
	if (ssaoColorBuffer != nullptr) {
		ssaoColorBuffer->PurgeImage();
	}
	if (ssaoNoise != nullptr) {
		ssaoNoise->PurgeImage();
	}
}

extern GLuint fboPrimary;
extern bool primaryOn;
void AmbientOcclusion::ComputeSSAOFromDepth() {
	if( ssaoFBO == 0 ) {
		Init();
	}

	GL_PROFILE( "SSAO" );

	qglBindFramebuffer( GL_FRAMEBUFFER, ssaoFBO );
	qglClear(GL_COLOR_BUFFER_BIT);
	GL_SelectTexture( 0 );
	globalImages->currentDepthImage->Bind();
	GL_SelectTexture( 1 );
	ssaoNoise->Bind();

	ssaoShader->Activate();
	AOUniforms *uniforms = ssaoShader->GetUniformGroup<AOUniforms>();
	uniforms->depthTexture.Set(0);
	uniforms->noiseTexture.Set(1);
	uniforms->screenResolution.Set(ssaoColorBuffer->uploadWidth, ssaoColorBuffer->uploadHeight);
	uniforms->sampleRadius.Set(r_ssao_radius.GetFloat());
	uniforms->depthBias.Set(r_ssao_bias.GetFloat());
	uniforms->area.Set(r_ssao_area.GetFloat());
	uniforms->baseValue.Set(r_ssao_base.GetFloat());
	uniforms->totalStrength.Set(r_ssao_strength.GetFloat());

	RB_DrawFullScreenQuad();

	// FIXME: this is a bit hacky
	qglBindFramebuffer( GL_FRAMEBUFFER, primaryOn ? fboPrimary : 0 );
}

void AmbientOcclusion::BindSSAOTexture(int index) {
	GL_SelectTexture(index);
	ssaoColorBuffer->Bind();
}
