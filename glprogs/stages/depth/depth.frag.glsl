#version 330 core
#pragma tdm_include "stages/common/common.frag.glsl"
#pragma tdm_include "stages/depth/depth.params.glsl"

in float var_ClipPlaneDist; 

uniform sampler2D u_texture;

void main() {
	if (var_ClipPlaneDist < 0.0)
		discard;

	if (params.alphaTest < 0) {
		out_Color = params.color;
	} else {
		vec4 tex = texture(SAMPLER2D(params.textureHandle, u_texture), var_TexCoord.st);
		if (tex.a <= params.alphaTest)
			discard;
		out_Color = tex * params.color;
	}
}
