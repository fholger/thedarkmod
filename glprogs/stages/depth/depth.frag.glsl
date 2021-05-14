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
#pragma tdm_include "stages/common/common.frag.glsl"

in float var_ClipPlaneDist; 

uniform sampler2D u_texture;
uniform vec4 u_color;
uniform float u_alphaTest;

void main() {
	if (var_ClipPlaneDist < 0.0)
		discard;

	if (u_alphaTest < 0) {
		out_Color = u_color;
	} else {
		vec4 tex = texture(u_texture, var_TexCoord.st);
		if (tex.a <= u_alphaTest)
			discard;
		out_Color = tex * u_color;
	}
}
