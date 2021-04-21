#version 330

out vec4 draw_Color;

uniform sampler2D u_render;
uniform float u_saturation;

void main() {
    vec4 color = texelFetch(u_render, ivec2(gl_FragCoord.xy), 0);
    float luma = clamp(dot(vec3(0.2125, 0.7154, 0.0721), color.rgb), 0.0, 1.0);
    color.rgb = mix(color.rgb, vec3(luma), u_saturation);
    color.rgb = mix(vec3(0.5), color.rgb, 0.85);
    color.a = 1;
    draw_Color = color;
}
