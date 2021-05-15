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
#include "DrawBatchExecutor.h"
#include "DepthStage.h"
#include "FrobOutlineStage.h"
#include "InteractionStage.h"
#include "ManyLightInteractionStage.h"
#include "ShadowMapStage.h"
#include "StencilShadowStage.h"
#include "../tr_local.h"

extern idCVar r_useNewBackend;
extern idCVar r_useBindlessTextures;

class FrameBuffer;

class RenderBackend {
public:
	RenderBackend();

	void Init();
	void Shutdown();

	void DrawView( const viewDef_t *viewDef );
	void DrawLightgem( const viewDef_t *viewDef, byte *lightgemData );

	void EndFrame();

	bool ShouldUseBindlessTextures() const;

	template <typename T>
	void SetShaderParams( const T &params ) {
		UploadShaderParams( &params, sizeof(T) );
	}

	void DrawSurface( const drawSurf_t *surf );

	static const int PARAM_INDEX = 5;
	static const int ENTITY_PARAM_INDEX = 6;

private:
	GpuBuffer shaderParamsBuffer;
	DrawBatchExecutor drawBatchExecutor;
	DepthStage depthStage;
	InteractionStage interactionStage;
	ManyLightInteractionStage manyLightStage;
	StencilShadowStage stencilShadowStage;
	ShadowMapStage shadowMapStage;
	FrobOutlineStage frobOutlineStage;

	FrameBuffer *lightgemFbo = nullptr;
	GLuint lightgemPbos[3] = { 0 };
	int currentLightgemPbo = 0;
	bool initialized = false;

	int uboAlignment = 0;
	byte *boundEntityParams = nullptr;

	void DrawInteractionsWithShadowMapping( viewLight_t *vLight );
	void DrawInteractionsWithStencilShadows( const viewDef_t *viewDef, viewLight_t *vLight );
	void DrawShadowsAndInteractions( const viewDef_t *viewDef );

	void SortDrawSurfs( const viewDef_t *viewDef );
	void UploadEntityParams( const viewDef_t *viewDef );
	void UploadShaderParams(const void *data, int size);
};

extern RenderBackend *renderBackend;
