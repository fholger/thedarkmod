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
#include "DepthStage.h"
#include "RenderBackend.h"
#include "../glsl.h"
#include "../FrameBufferManager.h"
#include "../GLSLProgramManager.h"


namespace {
	struct DepthUniforms : GLSLUniformGroup {
		UNIFORM_GROUP_DEF( DepthUniforms )

		DEFINE_UNIFORM( vec4, clipPlane )
		DEFINE_UNIFORM( sampler, texture )
		DEFINE_UNIFORM( mat4, textureMatrix )
		DEFINE_UNIFORM( vec4, color )
		DEFINE_UNIFORM( float, alphaTest )
	};
}

void DepthStage::Init() {
	depthShader = programManager->LoadFromFiles( "depth", "stages/depth/depth.vert.glsl", "stages/depth/depth.frag.glsl" );
}

void DepthStage::Shutdown() {}

void DepthStage::DrawDepth( const viewDef_t *viewDef, drawSurf_t **drawSurfs, int numDrawSurfs ) {
	if ( numDrawSurfs == 0 ) {
		return;
	}

	TRACE_GL_SCOPE( "DepthStage" );

	idList<drawSurf_t*> opaqueSurfs;
	idList<drawSurf_t*> perforatedSurfs;

	{
		TRACE_CPU_SCOPE( "PrepareSurfs" )
		for ( int i = 0; i < numDrawSurfs; ++i ) {
			drawSurf_t *surf = drawSurfs[i];
			if ( !ShouldDrawSurf( surf ) ) {
				continue;
			}

			if ( IsOpaqueSurf( surf ) && surf->material->GetSort() != SS_SUBVIEW ) {
				opaqueSurfs.AddGrow( surf );
			} else {
				perforatedSurfs.AddGrow( surf );
			}
		}

		std::sort( opaqueSurfs.begin(), opaqueSurfs.end(), []( const drawSurf_t *a, const drawSurf_t *b ) {
			// sort by cache affiliation
			if ( a->ambientCache.isStatic != b->ambientCache.isStatic )
				return a->ambientCache.isStatic;
			if ( a->indexCache.isStatic != b->indexCache.isStatic )
				return a->indexCache.isStatic;

			// sort by entity
			if ( a->space != b->space )
				return a->space < b->space;

			// sort by surf size
			return a->numIndexes > b->numIndexes;
		});

		// perforated surfaces should already be pre-sorted by material and then space, should be enough?
	}

	depthShader->Activate();
	DepthUniforms *depthUniforms = depthShader->GetUniformGroup<DepthUniforms>();

	// pass mirror clip plane details to vertex shader if needed
	if ( viewDef->clipPlane) {
		depthUniforms->clipPlane.Set( *viewDef->clipPlane );
	} else {
		depthUniforms->clipPlane.Set( colorBlack );
	}

	GL_State( GLS_DEPTHFUNC_LESS );

	// Enable stencil test if we are going to be using it for shadows.
	// If we didn't do this, it would be legal behavior to get z fighting
	// from the ambient pass and the light passes.
	qglEnable( GL_STENCIL_TEST );
	qglStencilFunc( GL_ALWAYS, 1, 255 );

	//qglEnable( GL_CLIP_DISTANCE0 );

	depthUniforms->alphaTest.Set( -1 );
	depthUniforms->color.Set( colorBlack );

	for ( const drawSurf_t *drawSurf : opaqueSurfs ) {
		renderBackend->DrawSurface( drawSurf );
	}

	DrawSurfsGeneric( perforatedSurfs );

	//qglDisable( GL_CLIP_DISTANCE0 );

	// Make the early depth pass available to shaders. #3877
	if ( !viewDef->IsLightGem() && !r_skipDepthCapture.GetBool() ) {
		frameBuffers->UpdateCurrentDepthCopy();
	}
}

bool DepthStage::ShouldDrawSurf(const drawSurf_t *surf) const {
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
#ifdef _DEBUG
        common->Printf( "DepthStage: missing vertex or index cache\n" );
#endif
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

bool DepthStage::IsOpaqueSurf( const drawSurf_t *surf ) const {
	const idMaterial		*shader = surf->material;
	const float				*regs = surf->shaderRegisters;

	if ( shader->Coverage() == MC_OPAQUE ) {
		return true;
	}

	// perforated surfaces may have multiple alpha tested stages
	for ( int stage = 0; stage < shader->GetNumStages(); stage++ ) {
		const shaderStage_t *pStage = shader->GetStage( stage );

		if ( !pStage->hasAlphaTest ) {
			continue;
		}

		// check the stage enable condition
		if ( regs[pStage->conditionRegister] == 0 ) {
			continue;
		}

		return false;
	}

	return true;
}

void DepthStage::DrawSurfsGeneric( const idList<drawSurf_t *> &drawSurfs ) {
	if ( drawSurfs.Num() == 0 ) {
		return;
	}

	idList<int> byMaterial;
	byMaterial.AddGrow( 0 );
	for ( int i = 1; i < drawSurfs.Num(); ++i ) {
		if ( drawSurfs[i]->material != drawSurfs[i-1]->material ) {
			byMaterial.AddGrow( i );
		}
	}
	byMaterial.AddGrow( drawSurfs.Num() );

	for ( int i = 1; i < byMaterial.Num(); ++i ) {
		int surfsFrom = byMaterial[i-1];
		int surfsTo = byMaterial[i];
		const idMaterial *material = drawSurfs[surfsFrom]->material;

		if( material->GetSort() == SS_SUBVIEW ) {
			GL_State( GLS_SRCBLEND_DST_COLOR | GLS_DSTBLEND_ZERO | GLS_DEPTHFUNC_LESS );
		} else {
			GL_State( GLS_DEPTHFUNC_LESS );
		}

		if ( material->Coverage() == MC_PERFORATED ) {
			// perforated surfaces may have multiple alpha tested stages
			for ( int stage = 0; stage < material->GetNumStages(); stage++ ) {
				const shaderStage_t *pStage = material->GetStage( stage );

				if ( !pStage->hasAlphaTest ) {
					continue;
				}

				GL_BindTexture( 0, pStage->texture.image );
				for ( int j = surfsFrom; j < surfsTo; ++j ) {
					const drawSurf_t *surf = drawSurfs[j];
					IssueDrawCommand( surf, pStage );
				}
			}
		}

		for ( int j = surfsFrom; j < surfsTo; ++j ) {
			const drawSurf_t *surf = drawSurfs[j];
			if ( IsOpaqueSurf( surf ) ) {
				IssueDrawCommand( surf, nullptr );
			}
		}
	}
}

void DepthStage::IssueDrawCommand( const drawSurf_t *surf, const shaderStage_t *stage ) {
	DepthUniforms *uniforms = depthShader->GetUniformGroup<DepthUniforms>();
	const idMaterial *material = surf->material;
	const float *regs = surf->shaderRegisters;
	
	if( stage ) {
		// check the stage enable condition
		if ( regs[stage->conditionRegister] == 0 ) {
			return;
		}
		// skip the entire stage if alpha would be black
		if ( regs[stage->color.registers[3]] <= 0 ) {
			return;
		}
	}

	float alphaTest = -1.f;
	idVec4 color ( 0, 0, 0, 1 );

	if ( material->GetSort() == SS_SUBVIEW ) {
		// subviews will just down-modulate the color buffer by overbright
		color[0] = color[1] = color[2] = 1.0f / backEnd.overBright;
		color[3] = 1;
	}

	if( stage ) {
		// set the alpha modulate
		color[3] = regs[stage->color.registers[3]];
		alphaTest = regs[stage->alphaTestRegister];

		idMat4 textureMatrix;
		if ( stage->texture.hasMatrix ) {
			RB_GetShaderTextureMatrix( regs, &stage->texture, textureMatrix.ToFloatPtr() );
		} else {
			textureMatrix.Identity();
		}

		uniforms->textureMatrix.Set( textureMatrix );
	}

	uniforms->alphaTest.Set( alphaTest );
	uniforms->color.Set( color );
	renderBackend->DrawSurface( surf );
}
