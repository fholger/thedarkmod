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
#include <renderer/GLSLProgramManager.h>
#include <renderer/GLSLProgram.h>
#include <renderer/FrameBuffer.h>
#include <renderer/Profiling.h>

struct DepthShaderParams {
    idMat4 modelMatrix;
    idMat4 textureMatrix;
    idVec4 color;
    idVec4 alphaTest;
    uint64_t texture;
	uint64_t padding;
};

void DepthStage::Init() {
    depthShader = programManager->Find("GL4Depth");
    if (depthShader == nullptr) {
        depthShader = programManager->LoadFromFiles("GL4Depth", "gl4/depth.vert.glsl", "gl4/depth.frag.glsl");
    }
}

void DepthStage::Shutdown() {
}

void DepthStage::Draw(const viewDef_t *viewDef) {
    GL_PROFILE("DepthStage");

    drawCommands = gl4Backend->GetDrawCommandBuffer();
    shaderParams = gl4Backend->GetShaderParamBuffer<DepthShaderParams>();
    currentIndex = 0;

    depthShader->Activate();
    GL_State(GLS_DEPTHFUNC_LESS);

    idPlane mirrorClipPlane (0, 0, 0, 1);
    if (viewDef->numClipPlanes > 0) {
        mirrorClipPlane = viewDef->clipPlanes[0];
    }
    qglUniform4fv(0, 1, mirrorClipPlane.ToFloatPtr());

    for (int i = 0; i < viewDef->numDrawSurfs; ++i) {
        PrepareDrawCommands(viewDef->drawSurfs[i]);
    }

    gl4Backend->BindShaderParams<DepthShaderParams>(currentIndex, GL_SHADER_STORAGE_BUFFER, 0);
	qglBindBuffer(GL_ELEMENT_ARRAY_BUFFER, vertexCache.GetIndexBuffer());
    qglMultiDrawElementsIndirect(GL_TRIANGLES, GL_INDEX_TYPE, drawCommands, currentIndex, 0);

    // Make the early depth pass available to shaders. #3877
    if ( !backEnd.viewDef->IsLightGem() && !r_skipDepthCapture.GetBool() ) {
        FB_CopyDepthBuffer();
        RB_SetProgramEnvironment();
    }
    GLSLProgram::Deactivate();
}

void DepthStage::PrepareDrawCommands(const drawSurf_t *surf) {
    const idMaterial *shader = surf->material;

    if ( !shader->IsDrawn() ) {
        return;
    }

    // some deforms may disable themselves by setting numIndexes = 0
    if ( !surf->numIndexes ) {
        return;
    }

    // translucent surfaces don't put anything in the depth buffer and don't
    // test against it, which makes them fail the mirror clip plane operation
    if ( shader->Coverage() == MC_TRANSLUCENT ) {
        return;
    }

    if ( !surf->ambientCache.IsValid() ) {
        common->Printf( "RB_T_FillDepthBuffer: !tri->ambientCache\n" );
        return;
    }

    if ( surf->material->GetSort() == SS_PORTAL_SKY && g_enablePortalSky.GetInteger() == 2 ) {
        return;
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

    if ( stage == shader->GetNumStages() ) {
        return;
    }

    // TODO: implement polygon offset in shader?
    // set polygon offset if necessary
    /*if ( shader->TestMaterialFlag( MF_POLYGONOFFSET ) ) {
        qglEnable( GL_POLYGON_OFFSET_FILL );
        qglPolygonOffset( r_offsetFactor.GetFloat(), r_offsetUnits.GetFloat() * shader->GetPolygonOffset() );
    }*/

    FillDrawCommands( surf );

    // reset polygon offset
    /*if ( shader->TestMaterialFlag( MF_POLYGONOFFSET ) ) {
        qglDisable( GL_POLYGON_OFFSET_FILL );
    }*/
}

void DepthStage::FillDrawCommands( const drawSurf_t *surf ) {
    idVec4 color (0, 0, 0, 1);
    const idMaterial *shader = surf->material;
    const float *regs = surf->shaderRegisters;

    // subviews will just down-modulate the color buffer by overbright
    if ( shader->GetSort() == SS_SUBVIEW ) {
        GL_State( GLS_SRCBLEND_DST_COLOR | GLS_DSTBLEND_ZERO | GLS_DEPTHFUNC_LESS );
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
            DepthShaderParams &params = shaderParams[cmdIndex];
            memcpy(params.modelMatrix.ToFloatPtr(), surf->space->modelMatrix, sizeof(idMat4));
            params.color = color;
            params.alphaTest.x = regs[pStage->alphaTestRegister];
            params.texture = pStage->texture.image->textureHandle;
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
        DepthShaderParams &params = shaderParams[cmdIndex];
        memcpy(params.modelMatrix.ToFloatPtr(), surf->space->modelMatrix, sizeof(idMat4));
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
