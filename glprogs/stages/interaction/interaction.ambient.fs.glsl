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

#pragma tdm_include "stages/interaction/interaction.params.glsl"
#pragma tdm_include "tdm_lightproject.glsl"
#pragma tdm_include "tdm_interaction.glsl"

flat in int var_DrawId;
in vec2 var_TexDiffuse;
in vec2 var_TexSpecular;
in vec2 var_TexNormal;
in vec4 var_TexLight;
in vec4 var_Color;
in mat3 var_TangentBinormalNormalMatrix;
in vec3 var_worldViewDir;

out vec4 FragColor;

uniform sampler2D u_normalTexture;
uniform sampler2D u_diffuseTexture;
uniform sampler2D u_specularTexture;

uniform sampler2D u_lightProjectionTexture;
uniform sampler2D u_lightFalloffTexture;

uniform float u_gamma, u_minLevel;

uniform vec2 u_renderResolution;
uniform sampler2D u_ssaoTexture;
uniform int u_ssaoEnabled;

void main() {
	vec3 lightColor = projFalloffOfNormalLight(u_lightProjectionTexture, u_lightFalloffTexture, params[var_DrawId].lightTextureMatrix, var_TexLight);

	vec3 localNormal = fetchSurfaceNormal(var_TexNormal, params[var_DrawId].hasTextureDNS[1] != 0.0, u_normalTexture, params[var_DrawId].RGTC != 0.0);
	AmbientGeometry props = computeAmbientGeometry(var_worldViewDir, localNormal, var_TangentBinormalNormalMatrix, mat3(params[var_DrawId].modelMatrix));

	vec4 interactionColor = computeAmbientInteraction(
		props,
		u_diffuseTexture, params[var_DrawId].diffuseColor.rgb, var_TexDiffuse,
		u_specularTexture, params[var_DrawId].specularColor.rgb, var_TexSpecular,
		var_Color.rgb,
		u_minLevel, u_gamma
	);

	float ssao = 1;
	if (u_ssaoEnabled == 1) {
		ssao = texture(u_ssaoTexture, gl_FragCoord.xy / u_renderResolution).r;
	}

	FragColor = vec4(lightColor * ssao * interactionColor.rgb, interactionColor.a);
}
