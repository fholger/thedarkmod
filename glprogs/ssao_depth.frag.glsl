#version 140

// simple blur shader which removes the random noise pattern introduced
// in the SSAO pass by the noise texture

in vec2 var_TexCoord;
out float depth0;
out float depth1;
out float depth2;
out float depth3;

uniform sampler2D u_depthTexture;

uniform block {
	mat4 u_projectionMatrix;
};

float nearZ = -0.5 * u_projectionMatrix[3][2];
float depthAdd = 0.5 * (u_projectionMatrix[2][2] - 1);

void main() {
	ivec2 baseCoord = ivec2(gl_FragCoord.xy) * 2;
	float a = texelFetchOffset(u_depthTexture, baseCoord, 0, ivec2(0, 0)).r;
	float b = texelFetchOffset(u_depthTexture, baseCoord, 0, ivec2(0, 1)).r;
	float c = texelFetchOffset(u_depthTexture, baseCoord, 0, ivec2(1, 0)).r;
	float d = texelFetchOffset(u_depthTexture, baseCoord, 0, ivec2(1, 1)).r;

	depth0 = nearZ / (a + depthAdd);
	depth1 = nearZ / (b + depthAdd);
	depth2 = nearZ / (c + depthAdd);
	depth3 = nearZ / (d + depthAdd);
}
