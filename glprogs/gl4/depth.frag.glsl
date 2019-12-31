#version 450 core
#extension GL_ARB_bindless_texture : require

struct ShaderParams {
    mat4 modelMatrix;
    mat4 textureMatrix;
    vec4 clipPlane;
    vec4 color;
    vec4 alphaTest;
    sampler2D texture;
};

layout (location = 0) in vec2 uv;
layout (location = 1) in float clipPlaneDist;
layout (location = 2) in flat ShaderParams params;

layout (location = 0) out vec4 fragColor;

void main() {
    if (clipPlaneDist < 0.0)
        discard;
    if (params.alphaTest.x < 0) {
        fragColor = params.color;
    } else {
        vec4 tex = texture2D(params.texture, uv);
        if (tex.a <= params.alphaTest.x)
            discard;
        fragColor = tex*params.color;
    }
}
