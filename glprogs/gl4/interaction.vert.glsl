#version 450 core
#extension GL_ARB_bindless_texture : require

#pragma tdm_include "gl4/projection.glsl"

layout (location = 0) in vec4 position;
layout (location = 8) in vec2 texCoord;
layout (location = 15) in int drawId;

layout (location = 0) uniform vec4 clipPlane;

struct ShaderParams {
    mat4 modelViewMatrix;
    mat4 textureMatrix;
    vec4 color;
    vec4 alphaTest;
    sampler2D texture;
};

layout (std140, binding = 0) buffer CB0 {
    ShaderParams params[];
};

layout (location = 0) out vec2 fs_uv;
layout (location = 1) out float fs_clipPlaneDist;
layout (location = 2) out flat vec4 fs_color;
layout (location = 3) out flat float fs_alphaTest;
layout (location = 4) out flat sampler2D fs_tex0;

void main() {
    vec4 viewPos = params[drawId].modelViewMatrix * position;
    gl_Position = projectionMatrix * viewPos;
    fs_uv = (params[drawId].textureMatrix * vec4(texCoord, 0, 1)).st;
    fs_clipPlaneDist = dot(inverseViewMatrix * viewPos, clipPlane);
    fs_color = params[drawId].color;
	fs_alphaTest = params[drawId].alphaTest.x;
	fs_tex0 = params[drawId].texture;
}
