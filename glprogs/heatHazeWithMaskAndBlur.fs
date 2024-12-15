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
#version 330

#pragma tdm_include "heatHazeCommon.glsl"

in vec2 texcoordOriginal;
in vec2 texcoordScrolled;
in vec2 deformationMagnitude;

out vec4 draw_Color;

uniform sampler2D u_texture0;	// _currentRender
uniform sampler2D u_texture1;	// displacement texture
uniform sampler2D u_texture2;	// mask texture

void main() {
	vec3 color = heatHazeFragmentShader(
		texcoordOriginal, texcoordScrolled, deformationMagnitude, gl_FragCoord,
		u_texture0, u_texture1,
		false, u_texture0,
		true, u_texture2,
		3.0
	);
	draw_Color = vec4(color, 1);
}
