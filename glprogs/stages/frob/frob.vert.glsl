#version 330

#pragma tdm_include "tdm_transform.glsl"

in vec3 attr_Normal;
in vec2 attr_TexCoord;
INATTR_POSITION  //in vec4 attr_Position;

out vec2 var_TexCoord;

uniform float u_depth;

void main() {
	vec4 transformed = tdm_transform(attr_Position);
	transformed.z -= u_depth * transformed.w;
	gl_Position = transformed;
    var_TexCoord = attr_TexCoord;
}
