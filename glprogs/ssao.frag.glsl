#version 140

in vec2 var_TexCoord;
out vec4 FragColor;

uniform sampler2D depthTexture;

void main() {
	float depth = texture(depthTexture, var_TexCoord).r;
	FragColor = vec4(depth, depth, depth, 1);
}
