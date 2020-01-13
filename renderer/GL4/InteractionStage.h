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

#include "RenderStage.h"
#include "../tr_local.h"
#include "LightClusterer.h"

class GLSLProgram;
struct DrawElementsIndirectCommand;
struct InteractionShaderParams;
struct ClusteredInteractionShaderParams;

class InteractionStage : public RenderStage {
public:
	InteractionStage();

	void Init();
	void Shutdown();

	void DrawInteractionsClustered( const viewDef_t * viewDef );
	void Draw(const viewDef_t *viewDef);
	
private:
	GLSLProgram *interactionShader;
    DrawElementsIndirectCommand *drawCommands;
    InteractionShaderParams *shaderParams;
	ClusteredInteractionShaderParams *clusteredShaderParams;
    int currentIndex;

	LightClusterer lightClusterer;

	void DrawInteractionsForLight(const viewDef_t *viewDef, viewLight_t *vLight);
	void CreateDrawCommandsForInteractions(viewLight_t *vLight, const drawSurf_t *interactions);
	void CreateDrawCommandsForSingleSurface(const drawSurf_t *surf);
	void CreateDrawCommand(drawInteraction_t *inter);
	void CreateClusteredDrawCommand( drawInteraction_t * inter );

	void PrepareLightData(const viewDef_t *viewDef);
};
