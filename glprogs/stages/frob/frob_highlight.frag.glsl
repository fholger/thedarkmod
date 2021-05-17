#version 330

in vec2 var_TexCoord;
out vec4 draw_Color;

uniform sampler2D u_render;
uniform sampler2D u_diffuse;
uniform float u_saturation;

void main() {
    vec3 color = texelFetch(u_render, ivec2(gl_FragCoord.xy), 0).rgb;
    vec3 diffuse = texture(u_diffuse, var_TexCoord).rgb;
    //draw_Color.rgb = 1.4 * color + 0.15 * diffuse;
    draw_Color.rgb = color + 0.3 * diffuse + 0.015;
    draw_Color.a = 1;
}
