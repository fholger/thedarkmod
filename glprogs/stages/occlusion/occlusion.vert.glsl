#version 430 core

in vec4 attr_Position;
in int attr_DrawId;
flat out int entityIndex;

uniform ViewParamsBlock {
	uniform mat4 u_projectionMatrix;
};

#pragma tdm_define "MAX_SHADER_PARAMS"

struct ShaderParams {
    mat4 modelViewMatrix;
    int entityIndex;
    int padding1;
    int padding2;
    int padding3;
};
layout (std140) uniform PerDrawCallParamsBlock {
	ShaderParams params[MAX_SHADER_PARAMS];
};

void main() {
	vec4 viewPos = params[attr_DrawId].modelViewMatrix * attr_Position;
	gl_Position = u_projectionMatrix * viewPos;
    entityIndex = params[attr_DrawId].entityIndex;
}
