#version 450 core
#extension GL_ARB_bindless_texture : require

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

layout (location = 0) in vec2 uv;
layout (location = 1) in float clipPlaneDist;
layout (location = 2) in flat int drawId;

layout (location = 0) out vec4 fragColor;

void main() {
    if (clipPlaneDist < 0.0)
        discard;
    if (params[drawId].alphaTest.x < 0) {
        fragColor = params[drawId].color;
    } else {
        vec4 tex = texture2D(params[drawId].texture, uv);
        if (tex.a <= params[drawId].alphaTest.x)
            discard;
        fragColor = tex*params[drawId].color;
    }
}
