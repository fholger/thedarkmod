#version 450 core

#pragma tdm_include "gl4/projection.glsl"

layout (location = 0) in vec4 position;
layout (location = 15) in int drawId;

layout (std430, binding = 0) buffer CB0 {
    mat4 modelViewMatrix[];
};

void main() {
    vec4 viewPos = modelViewMatrix[drawId] * position;
    gl_Position = projectionMatrix * viewPos;
}
