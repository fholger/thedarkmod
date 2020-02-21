#version 140

// this is an SSAO implementation working purely from the depth buffer
// all calculations are done in screen space
// inspired by: http://theorangeduck.com/page/pure-depth-ssao

in vec2 var_TexCoord;
in vec2 var_ViewRay;
out vec4 FragColor;

uniform sampler2D u_depthTexture;
uniform sampler2D u_noiseTexture;
uniform float u_sampleRadius;
uniform float u_depthBias;
uniform float u_baseValue;
uniform float u_power;

uniform block {
	mat4 u_projectionMatrix;
};

float nearZ = -0.5 * u_projectionMatrix[3][2];
vec2 halfTanFov = vec2(1 / u_projectionMatrix[0][0], 1 / u_projectionMatrix[1][1]);

// map a texel in the depth texture back to view space coordinates by reversing the projection
vec3 texCoordToViewPos(vec2 texCoord) {
	float depth = texture(u_depthTexture, texCoord).r;
	vec3 viewPos;
	viewPos.z = nearZ / (depth - 1.999/2);
	viewPos.xy = -halfTanFov * (2 * texCoord - 1) * viewPos.z;
	return viewPos;
}

vec2 depthTexSize = vec2(textureSize(u_depthTexture, 0));
vec2 texOffsets[] = vec2[](vec2(1/depthTexSize.x, 0), vec2(0, 1/depthTexSize.y));

// approximate the current texel's normal in view space by projecting two adjacent texels to view space and
// to calculate tangent vectors, which can then be crossed for a normal
vec3 approximateViewSpaceNormal(vec3 position, vec2 texCoords) {
	vec3 a = texCoordToViewPos(texCoords + texOffsets[0]) - position;
	vec3 b = texCoordToViewPos(texCoords + texOffsets[1]) - position;
	vec3 normal = cross(a, b);
	return normalize(normal);
}

// determine the actual occluding depth value in view space for a given view space position
float occluderZAtViewPos(vec3 viewPos) {
	vec4 clipPos = u_projectionMatrix * vec4(viewPos, 1);
	vec2 texCoord = 0.5 + 0.5 * (clipPos.xy / clipPos.w);
	float depth = texture(u_depthTexture, texCoord).r;
	return nearZ / (depth - 1.999/2);
}

uniform int u_kernelSize;
uniform vec3 u_sampleKernel[128];

void main() {
	vec3 position = texCoordToViewPos(var_TexCoord);
	vec3 normal = approximateViewSpaceNormal(position, var_TexCoord);

	vec2 noiseScale = vec2(textureSize(u_depthTexture, 0)) / 4;
	vec3 random = normalize(-1 + 2 * texture(u_noiseTexture, var_TexCoord * noiseScale).rgb);

	vec3 tangent = normalize(random - normal * dot(random, normal));
	vec3 bitangent = cross(normal, tangent);
	mat3 TBN = mat3(tangent, bitangent, normal);

	float occlusion = 0.0;
	for (int i = 0; i < u_kernelSize; i++) {
		vec3 samplePos = position + u_sampleRadius * TBN * u_sampleKernel[i];

		float occluderZ = occluderZAtViewPos(samplePos);
		float difference = occluderZ - samplePos.z;

		float rangeCheck = smoothstep(0.0, 1.0, u_sampleRadius / abs(position.z - occluderZ));
		occlusion += step(u_depthBias, difference) * rangeCheck;
	}

	float ao = clamp(u_baseValue + 1.0 - occlusion / u_kernelSize, 0, 1);
	ao = pow(ao, u_power);
	FragColor = vec4(ao, ao, ao, 1);
	//FragColor = vec4(0.5 * normal + 0.5, 1);
}
