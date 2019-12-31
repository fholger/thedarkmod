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

void DepthStage::Init() {
    depthShader = programManager->Find("GL4Depth");
    if (depthShader == nullptr) {
        depthShader = programManager->LoadFromFiles("GL4Depth", "gl4/depth.vert.glsl", "gl4/depth.frag.glsl");
    }
}

void DepthStage::Shutdown() {
}
