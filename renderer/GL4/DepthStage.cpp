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
#include <renderer/GLSLProgramManager.h>
#include <renderer/GLSLProgram.h>
#include <renderer/FrameBuffer.h>

void DepthStage::Init() {
    depthShader = programManager->Find("GL4Depth");
    if (depthShader == nullptr) {
        depthShader = programManager->LoadFromFiles("GL4Depth", "gl4/depth.vert.glsl", "gl4/depth.frag.glsl");
    }
}

void DepthStage::Shutdown() {
}

void DepthStage::Draw(const viewDef_t *viewDef) {
    depthShader->Activate();
    GL_State(GLS_DEPTHFUNC_LESS);

    idPlane mirrorClipPlane (0, 0, 0, 1);
    if (viewDef->numClipPlanes > 0) {
        mirrorClipPlane = viewDef->clipPlanes[0];
    }

    // Make the early depth pass available to shaders. #3877
    if ( !backEnd.viewDef->IsLightGem() && !r_skipDepthCapture.GetBool() ) {
        FB_CopyDepthBuffer();
        RB_SetProgramEnvironment();
    }
    GLSLProgram::Deactivate();
}
