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
#include "DepthStage.h"
#include "GL4Backend.h"
#include "../GLSLProgramManager.h"
#include "../GLSLProgram.h"
#include "../FrameBuffer.h"
#include "../Profiling.h"

struct GenericDepthShaderParams {
    idMat4 modelViewMatrix;
    idMat4 textureMatrix;
    idVec4 color;
    idVec4 alphaTest;
    uint64_t texture;
	uint64_t padding;
};

void DepthStage::Init() {
    genericDepthShader = programManager->Find("GL4Depth");
    if (genericDepthShader == nullptr) {
        genericDepthShader = programManager->LoadFromFiles("GL4Depth", "gl4/depth.vert.glsl", "gl4/depth.frag.glsl");
    }

    fastDepthShader = programManager->Find("GL4DepthFast");
    if (fastDepthShader == nullptr) {
        fastDepthShader = programManager->LoadFromFiles("GL4DepthFast", "gl4/depthFast.vert.glsl", "gl4/black.frag.glsl");
    }
}

void DepthStage::Shutdown() {
}

void DepthStage::Draw(const viewDef_t *viewDef) {
    GL_PROFILE("DepthStage");

    qglBindBuffer(GL_ELEMENT_ARRAY_BUFFER, vertexCache.GetIndexBuffer());

    //GL_State( GLS_SRCBLEND_DST_COLOR | GLS_DSTBLEND_ZERO | GLS_DEPTHFUNC_LESS );
    //GenericDepthPass(viewDef, viewDef->drawSurfs, viewDef->numDrawSurfs);

	// somewhat surprisingly, the fast path does not appear to be any faster than the default path
    std::vector<drawSurf_t*> subViewSurfs;
    std::vector<drawSurf_t*> opaqueSurfs;
    std::vector<drawSurf_t*> remainingSurfs;
    PartitionSurfaces(viewDef->drawSurfs, viewDef->numDrawSurfs, subViewSurfs, opaqueSurfs, remainingSurfs);

	GL_State(GLS_SRCBLEND_DST_COLOR | GLS_DSTBLEND_ZERO | GLS_DEPTHFUNC_LESS);
	GenericDepthPass(viewDef, subViewSurfs.data(), subViewSurfs.size());

	// sort by distance to camera (roughly) to profit from early-Z rejection
    std::sort(opaqueSurfs.begin(), opaqueSurfs.end(), [viewDef](const drawSurf_t* a, const drawSurf_t* b) -> bool {
		idVec3 posA = a->space->entityDef->globalReferenceBounds.GetCenter();
		idVec3 posB = b->space->entityDef->globalReferenceBounds.GetCenter();
		const idRenderMatrix &viewProj = viewDef->worldSpace.mvp;
		float zA = viewProj[2][0] * posA[0] + viewProj[2][1] * posA[1] + viewProj[2][2] * posA[2] + viewProj[2][3];
		float zB = viewProj[2][0] * posB[0] + viewProj[2][1] * posB[1] + viewProj[2][2] * posB[2] + viewProj[2][3];
		return zA < zB;
    });

    GL_State( GLS_DEPTHFUNC_LESS );
    FastDepthPass(opaqueSurfs.data(), opaqueSurfs.size());
    GenericDepthPass(viewDef, remainingSurfs.data(), remainingSurfs.size());

    // Make the early depth pass available to shaders. #3877
    if ( !backEnd.viewDef->IsLightGem() && !r_skipDepthCapture.GetBool() ) {
        FB_CopyDepthBuffer();
    }
    GLSLProgram::Deactivate();
}

void DepthStage::CreateGenericDrawCommands(const drawSurf_t *surf ) {
    idVec4 color = colorBlack;
    const idMaterial *shader = surf->material;
    const float *regs = surf->shaderRegisters;

    // subviews will just down-modulate the color buffer by overbright
    if ( shader->GetSort() == SS_SUBVIEW ) {
        //GL_State( GLS_SRCBLEND_DST_COLOR | GLS_DSTBLEND_ZERO | GLS_DEPTHFUNC_LESS );
        color[0] = color[1] = color[2] = (1.0f / backEnd.overBright);
    }

    bool drawSolid = false;

    if ( shader->Coverage() == MC_OPAQUE ) {
        drawSolid = true;
    }

    // we may have multiple alpha tested stages
    if ( shader->Coverage() == MC_PERFORATED ) {
        // if the only alpha tested stages are condition register omitted,
        // draw a normal opaque surface
        bool didDraw = false;

        // perforated surfaces may have multiple alpha tested stages
        for ( int stage = 0; stage < shader->GetNumStages(); stage++ ) {
            const shaderStage_t *pStage = shader->GetStage( stage );
            if ( !pStage->hasAlphaTest || regs[pStage->conditionRegister] == 0 ) {
                continue;
            }

            // if we at least tried to draw an alpha tested stage,
            // we won't draw the opaque surface
            didDraw = true;

            // set the alpha modulate
            color[3] = regs[pStage->color.registers[3]];

            // skip the entire stage if alpha would be black
            if ( color[3] <= 0 ) {
                continue;
            }

            // TODO: this is not thread-safe and needs to be done beforehand, if we want to thread the backend
            pStage->texture.image->MakeResident();

            int cmdIndex = currentIndex++;
            GenericDepthShaderParams &params = shaderParams[cmdIndex];
            memcpy(params.modelViewMatrix.ToFloatPtr(), surf->space->modelViewMatrix, sizeof(idMat4));
            params.color = color;
            params.alphaTest.x = regs[pStage->alphaTestRegister];
            params.texture = pStage->texture.image->BindlessHandle();
            if (surf->shaderRegisters && pStage->texture.hasMatrix) {
                RB_GetShaderTextureMatrix(surf->shaderRegisters, &pStage->texture, params.textureMatrix.ToFloatPtr());
            } else {
                shaderParams[cmdIndex].textureMatrix = mat4_identity;
            }

            DrawElementsIndirectCommand &drawCommand = drawCommands[cmdIndex];
            drawCommand.count = surf->numIndexes;
            drawCommand.instanceCount = 1;
            drawCommand.firstIndex = surf->indexCache.offset / sizeof(glIndex_t);
            drawCommand.baseVertex = surf->ambientCache.offset / sizeof(idDrawVert);
            drawCommand.baseInstance = cmdIndex;
        }

        if ( !didDraw ) {
            drawSolid = true;
        }
    }

    if ( drawSolid ) {  // draw the entire surface solid
        int cmdIndex = currentIndex++;
        GenericDepthShaderParams &params = shaderParams[cmdIndex];
        memcpy(params.modelViewMatrix.ToFloatPtr(), surf->space->modelViewMatrix, sizeof(idMat4));
        params.color = colorBlack;
        params.alphaTest.x = -1;

        DrawElementsIndirectCommand &drawCommand = drawCommands[cmdIndex];
        drawCommand.count = surf->numIndexes;
        drawCommand.instanceCount = 1;
        drawCommand.firstIndex = surf->indexCache.offset / sizeof(glIndex_t);
        drawCommand.baseVertex = surf->ambientCache.offset / sizeof(idDrawVert);
        drawCommand.baseInstance = cmdIndex;
    }
}

void DepthStage::PartitionSurfaces(drawSurf_t **drawSurfs, int numDrawSurfs, std::vector<drawSurf_t *> &subviewSurfs,
                                   std::vector<drawSurf_t *> &opaqueSurfs,
                                   std::vector<drawSurf_t *> &remainingSurfs) {
    for (int i = 0; i < numDrawSurfs; ++i) {
        drawSurf_t *surf = drawSurfs[i];
        const idMaterial *material = surf->material;

        if (!ShouldDrawSurf(surf)) {
            continue;
        }

        if (material->GetSort() == SS_SUBVIEW) {
            // sub view surfaces need to be rendered first in a generic pass due to mirror plane clipping
            subviewSurfs.push_back(surf);
            continue;
        }

        if (material->Coverage() == MC_OPAQUE) {
			opaqueSurfs.push_back(surf);
			continue;
        }

		// these may need alpha checks in the shader and thus can't be handled by the fast pass
		remainingSurfs.push_back(surf);
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
        common->Printf( "DepthStage: missing vertex or index cache\n" );
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

void DepthStage::GenericDepthPass(const viewDef_t *viewDef, drawSurf_t **drawSurfs, int numDrawSurfs) {
	if (numDrawSurfs <= 0) {
		return;
	}

    GL_PROFILE("DepthPass_Generic");

    drawCommands = gl4Backend->GetDrawCommandBuffer();
    shaderParams = gl4Backend->GetShaderParamBuffer<GenericDepthShaderParams>();
    currentIndex = 0;

    genericDepthShader->Activate();

    idPlane mirrorClipPlane (0, 0, 0, 1);
    if (viewDef->numClipPlanes > 0) {
        mirrorClipPlane = viewDef->clipPlanes[0];
    }
    qglUniform4fv(0, 1, mirrorClipPlane.ToFloatPtr());

    for (int i = 0; i < numDrawSurfs; ++i) {
        const drawSurf_t *surf = drawSurfs[i];
        if (!ShouldDrawSurf(surf)) {
            continue;
        }
        // TODO: implement polygon offset in shader?
        CreateGenericDrawCommands(surf);
    }

    gl4Backend->BindShaderParams<GenericDepthShaderParams>(currentIndex, GL_SHADER_STORAGE_BUFFER, 0);
    gl4Backend->MultiDrawIndirect(currentIndex);
}

void DepthStage::FastDepthPass(drawSurf_t **drawSurfs, int numDrawSurfs) {
	if (numDrawSurfs <= 0) {
		return;
	}

    GL_PROFILE("DepthPass_Fast");

    drawCommands = gl4Backend->GetDrawCommandBuffer();
    idMat4 *modelViewMatrices = gl4Backend->GetShaderParamBuffer<idMat4>();
    currentIndex = 0;

    fastDepthShader->Activate();

    for (int i = 0; i < numDrawSurfs; ++i) {
        const drawSurf_t *surf = drawSurfs[i];
        if (!ShouldDrawSurf(surf)) {
            continue;
        }

        int cmdIndex = currentIndex++;
        memcpy(modelViewMatrices[cmdIndex].ToFloatPtr(), surf->space->modelViewMatrix, sizeof(idMat4));
        drawCommands[cmdIndex].count = surf->numIndexes;
        drawCommands[cmdIndex].instanceCount = 1;
        drawCommands[cmdIndex].firstIndex = surf->indexCache.offset / sizeof(glIndex_t);
        drawCommands[cmdIndex].baseVertex = surf->ambientCache.offset / sizeof(idDrawVert);
        drawCommands[cmdIndex].baseInstance = cmdIndex;
    }

    gl4Backend->BindShaderParams<idMat4>(currentIndex, GL_SHADER_STORAGE_BUFFER, 0);
    gl4Backend->MultiDrawIndirect(currentIndex);
}

