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
#include "GpuBuffer.h"

template< typename ShaderParams >
struct DrawBatch {
    ShaderParams *shaderParams;
    const drawSurf_t **surfs;
    uint maxBatchSize;
};

class DrawBatchExecutor {
public:
	static const GLuint DEFAULT_UBO_INDEX = 1;
	
	void Init();
	void Destroy();

	template< typename ShaderParams >
	DrawBatch<ShaderParams> BeginBatch();

	void ExecuteDrawVertBatch( int numDrawSurfs, GLuint uboIndex = DEFAULT_UBO_INDEX );
	void ExecuteShadowVertBatch( int numDrawSurfs, GLuint uboIndex = DEFAULT_UBO_INDEX );

	void EndFrame();

	template< typename ShaderParams >
	uint MaxShaderParamsArraySize() {
		return maxUniformBlockSize / sizeof( ShaderParams );
	}

private:
	static const uint MAX_SHADER_PARAMS_SIZE = 512;
	
    GpuBuffer shaderParamsBuffer;
	GpuBuffer drawCommandBuffer;
	GLuint drawIdBuffer = 0;
	bool drawIdVertexEnabled = false;

	int maxUniformBlockSize = 0;

	uint maxBatchSize = 0;
	uint shaderParamsSize = 0;

	idList<const drawSurf_t *> drawSurfs;

	bool ShouldUseMultiDraw() const;
	void InitDrawIdBuffer();

	uint EnsureAvailableStorageInBuffers( uint shaderParamsSize );

	void DrawVertsMultiDraw( int numDrawSurfs );
	void DrawVertsSingleDraws( int numDrawSurfs );
	void ShadowVertsMultiDraw( int numDrawSurfs );
	void ShadowVertsSingleDraws( int numDrawSurfs );
};

template<typename ShaderParams>
DrawBatch<ShaderParams> DrawBatchExecutor::BeginBatch() {
	static_assert( sizeof(ShaderParams) % 16 == 0,
		"UBO structs must be 16-byte aligned, use padding if necessary. Be sure to obey the std140 layout rules." );
	static_assert( sizeof(ShaderParams) <= MAX_SHADER_PARAMS_SIZE,
		"Struct surpasses assumed max shader params size. Make struct smaller or increase MAX_SHADER_PARAMS_SIZE if necessary");

	shaderParamsSize = sizeof(ShaderParams);

    ::DrawBatch<ShaderParams> drawBatch;
    drawBatch.maxBatchSize = maxBatchSize = EnsureAvailableStorageInBuffers( sizeof(ShaderParams) );
    drawBatch.shaderParams = reinterpret_cast<ShaderParams *>( shaderParamsBuffer.CurrentWriteLocation() );
	drawBatch.surfs = drawSurfs.Ptr();
    return drawBatch;
}
