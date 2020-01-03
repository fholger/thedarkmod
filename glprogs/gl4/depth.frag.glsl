#version 450 core
#extension GL_ARB_bindless_texture : require

layout (early_fragment_tests) in;

layout (location = 0) in vec2 fs_uv;
layout (location = 1) in float fs_clipPlaneDist;
layout (location = 2) in flat vec4 fs_color;
layout (location = 3) in flat float fs_alphaTest;
layout (location = 4) in flat sampler2D fs_tex0;

layout (location = 0) out vec4 fragColor;

void main() {
    if (fs_clipPlaneDist < 0.0)
        discard;
    if (fs_alphaTest < 0) {
        fragColor = fs_color;
    } else {
        vec4 tex = texture2D(fs_tex0, fs_uv);
        if (tex.a <= fs_alphaTest)
            discard;
        fragColor = tex*fs_color;
    }
}
