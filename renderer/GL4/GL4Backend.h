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
#include "DepthStage.h"
#include "PersistentBuffer.h"

extern idCVar r_useGL4Backend;

// struct used for MultiDraw calls
struct DrawElementsIndirectCommand {
    uint count;
    uint instanceCount;
    uint firstIndex;
    uint baseVertex;
    uint baseInstance;
};

class GL4Backend {
public:
	GL4Backend();

	void Init();
	void Shutdown();

	void BeginFrame(const viewDef_t *viewDef);
	void EndFrame();

	void ExecuteRenderCommands(const emptyCommand_t *cmds);

private:
    GLint uboOffsetAlignment;
    GLint ssboOffsetAlignment;
    GLuint drawIdBuffer;
    PersistentBuffer shaderParamBuffer;
    DrawElementsIndirectCommand *drawCommands;

    DepthStage depthStage;

    void InitDrawIdBuffer();
	void DrawView(const viewDef_t *viewDef);
};

extern GL4Backend *gl4Backend;
