#version 140

in vec2 var_TexCoord;
out vec3 Normal;

uniform sampler2D u_depthTexture;

uniform block {
	mat4 u_projectionMatrix;
};

float nearZ = -0.5 * u_projectionMatrix[3][2];
vec2 halfTanFov = vec2(1 / u_projectionMatrix[0][0], 1 / u_projectionMatrix[1][1]);

float depthToZ(vec2 texCoord) {
	float depth = texture(u_depthTexture, texCoord).r;
	return nearZ / (depth + 0.5 * (u_projectionMatrix[2][2] - 1));
}

// map a texel in the depth texture back to view space coordinates by reversing the projection
vec3 texCoordToViewPos(vec2 texCoord) {
	vec3 viewPos;
	viewPos.z = depthToZ(texCoord);
	viewPos.xy = -halfTanFov * (2 * texCoord - 1) * viewPos.z;
	return viewPos;
}

void main() {
	vec3 position = texCoordToViewPos(var_TexCoord);
	vec3 dx = dFdx(position);
	vec3 dy = dFdy(position);
	vec3 normal = normalize(cross(dx, dy));

	Normal = 0.5 + 0.5 * normal;
}
