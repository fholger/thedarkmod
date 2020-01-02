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

layout (location = 0) out vec2 out_uv;
layout (location = 1) out float out_clipPlaneDist;
layout (location = 2) out flat int out_drawId;

void main() {
    vec4 viewPos = params[drawId].modelViewMatrix * position;
    gl_Position = projectionMatrix * viewPos;
    out_uv = (params[drawId].textureMatrix * vec4(texCoord, 0, 1)).st;
    out_clipPlaneDist = dot(inverseViewMatrix * viewPos, clipPlane);
    out_drawId = drawId;
}
