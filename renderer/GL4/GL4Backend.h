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

#include "../tr_local.h"
#include "DepthStage.h"
#include "InteractionStage.h"
#include "PersistentBuffer.h"

const int MAX_DRAW_COMMANDS = 4096;
const int MAX_PARAM_BLOCK_SIZE = 1824;
const int BUFFER_FRAMES = 3;  // number of frames our parameter buffer should be able to hold

extern idCVar r_useGL4Backend;

enum VertexAttribs {
    VA_POSITION		= 0,
    VA_NORMAL		= 2,
    VA_COLOR		= 3,
    VA_TEXCOORD		= 8,
    VA_TANGENT		= 9,
    VA_BITANGENT	= 10,
    VA_DRAWID		= 15
};

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

	/** This function will always return the same buffer until you call MultiDrawIndirect */
	DrawElementsIndirectCommand *GetDrawCommandBuffer() {
	    byte *rawBuffer = drawCommandBuffer.Reserve(MAX_DRAW_COMMANDS * sizeof(DrawElementsIndirectCommand));
	    return reinterpret_cast<DrawElementsIndirectCommand*>(rawBuffer);
	}

	/** This function will always return the same buffer until you actually bind the params with BindShaderParams */
	template<typename T>
	T* GetShaderParamBuffer() {
		static_assert(sizeof(T) % sizeof(idVec4) == 0, "Shader param type must be aligned to vec4");
        static_assert(sizeof(T) <= MAX_PARAM_BLOCK_SIZE, "Shader param type should not exceed the chosen max param block size");
	    byte *rawBuffer = shaderParamBuffer.Reserve(MAX_DRAW_COMMANDS * sizeof(T));
	    return reinterpret_cast<T*>(rawBuffer);
	}

	template<typename T>
	void BindShaderParams(int count, GLenum target, GLuint index) {
	    shaderParamBuffer.BindBufferRange(target, index, count * sizeof(T));
	    shaderParamBuffer.MarkAsUsed(count * sizeof(T));
	}

	void MultiDrawIndirect(int count);

    void PrepareVertexAttribs();

private:
    GLint uboOffsetAlignment;
    GLint ssboOffsetAlignment;
    GLuint drawIdBuffer;
    PersistentBuffer shaderParamBuffer;
    PersistentBuffer drawCommandBuffer;

    DepthStage depthStage;
	InteractionStage interactionStage;

    void InitDrawIdBuffer();
	void DrawView(const viewDef_t *viewDef);
};

extern GL4Backend *gl4Backend;
