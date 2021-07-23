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
#version 330 core
#pragma tdm_include "stages/common/common.vert.glsl"

uniform vec4 u_clipPlane;
uniform mat4 u_textureMatrix;

out float var_ClipPlaneDist;

void main() {
	transformVertexPosition();
	var_TexCoord = u_textureMatrix * vec4(attr_TexCoord, 0, 1);
	var_ClipPlaneDist = dot(entityParams.modelMatrix * attr_Position, u_clipPlane);
	// fixme: would be preferable to use GL native clip distances, but this causes flickering
	//gl_ClipDistance[0] = var_ClipPlaneDist;
}
