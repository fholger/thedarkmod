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
#pragma once

#include <renderer/tr_local.h>
#include "RenderStage.h"

class GLSLProgram;
struct DrawElementsIndirectCommand;
struct GenericDepthShaderParams;

class DepthStage : public RenderStage {
public:
    void Init();
    void Shutdown();

    void Draw(const viewDef_t *viewDef);

private:
    GLSLProgram *genericDepthShader;
    GLSLProgram *fastDepthShader;

    DrawElementsIndirectCommand *drawCommands;
    GenericDepthShaderParams *shaderParams;
    int currentIndex;

    void PartitionSurfaces(drawSurf_t **drawSurfs, int numDrawSurfs,
            std::vector<drawSurf_t*> &subviewSurfs,
            std::vector<drawSurf_t*> &opaqueSurfs,
            std::vector<drawSurf_t*> &perforatedSurfs);

    bool ShouldDrawSurf(const drawSurf_t *surf) const;

    void CreateGenericDrawCommands(const drawSurf_t *surf);

    void GenericDepthPass(const viewDef_t *viewDef, drawSurf_t **drawSurfs, int numDrawSurfs);
    void FastDepthPass(drawSurf_t **drawSurfs, int numDrawSurfs);
};
