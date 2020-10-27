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

extern idCVar r_useGpuOcclusionQueries;

class GpuOcclusionQueryStage
{
public:
	GpuOcclusionQueryStage( DrawBatchExecutor *drawBatchExecutor );

	void Init();
	void Shutdown();

	void TestOcclusion( const viewDef_t *viewDef );
	void FetchResults( const viewDef_t *viewDef );

private:
	struct ShaderParams;

	DrawBatchExecutor *drawBatchExecutor;
	GLSLProgram *occlusionShader = nullptr;
	GLuint visibilityBuffer = 0;
	int *visibilityMarkers = nullptr;
	GLsync occlusionRenderSync = nullptr;

	uint currentIndex = 0;
	DrawBatch<ShaderParams> drawBatch;

	bool ShouldDrawSurf( const drawSurf_t *surf ) const;
	void DrawSurf( const drawSurf_t * drawSurf );
	void IssueDrawCommand( const drawSurf_t *surf );

	void BeginDrawBatch();
	void ExecuteDrawCalls();
};
