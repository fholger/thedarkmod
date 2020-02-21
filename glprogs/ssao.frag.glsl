#version 140

// this is an SSAO implementation working purely from the depth buffer
// all calculations are done in screen space
// inspired by: http://theorangeduck.com/page/pure-depth-ssao

in vec2 var_TexCoord;
in vec2 var_ViewRay;
out vec4 FragColor;

uniform sampler2D u_depthTexture;
uniform sampler2D u_noiseTexture;
uniform vec2 u_screenResolution;
uniform float u_sampleRadius;
uniform float u_depthBias;
uniform float u_area;
uniform float u_totalStrength;
uniform float u_baseValue;

uniform block {
	mat4 u_projectionMatrix;
};

float lookupDepth(vec2 texCoord) {
	return texture(u_depthTexture, texCoord).r;
}

float viewSpaceZ(vec2 clipXY) {
	return -0.5 * u_projectionMatrix[3][2] / (lookupDepth(0.5 + 0.5 * clipXY) - 1);
}

vec3 viewSpacePos(vec3 viewPos) {
	vec4 clipPos = u_projectionMatrix * vec4(viewPos, 1);
	float z = viewSpaceZ(clipPos.xy / clipPos.w);
	return vec3(viewPos.xy, z);
}

vec3 offsets[2] = vec3[](vec3(1, 0, 0), vec3(0, 1, 0));

vec3 approximateViewSpaceNormal(vec3 position) {
	vec3 a = viewSpacePos(position + offsets[0]) - position;
	vec3 b = viewSpacePos(position + offsets[1]) - position;
	vec3 normal = cross(a, b);
	return normalize(normal);
}

const int samples = 16;
const vec3 sample_sphere[16] = vec3[](
vec3( 0.5381, 0.1856,-0.4319), vec3( 0.1379, 0.2486, 0.4430),
vec3( 0.3371, 0.5679,-0.0057), vec3(-0.6999,-0.0451,-0.0019),
vec3( 0.0689,-0.1598,-0.8547), vec3( 0.0560, 0.0069,-0.1843),
vec3(-0.0146, 0.1402, 0.0762), vec3( 0.0100,-0.1924,-0.0344),
vec3(-0.3577,-0.5301,-0.4358), vec3(-0.3169, 0.1063, 0.0158),
vec3( 0.0103,-0.5869, 0.0046), vec3(-0.0897,-0.4940, 0.3287),
vec3( 0.7119,-0.0154,-0.0918), vec3(-0.0533, 0.0596,-0.5411),
vec3( 0.0352,-0.0631, 0.5460), vec3(-0.4776, 0.2847,-0.0271)
);

void main() {
	vec3 position;
	position.z = viewSpaceZ(-1 + 2 * var_TexCoord);
	position.xy = var_ViewRay * position.z;
	vec3 normal = approximateViewSpaceNormal(position);

	vec3 random = normalize(-1 + 2 * texture(u_noiseTexture, var_TexCoord * u_screenResolution / 4).rgb);

	float occlusion = 0.0;
	float radiusOverDepth = u_sampleRadius / (0.5*position.z+0.5);
	for (int i = 0; i < samples; i++) {
		vec3 ray = reflect(sample_sphere[i], random);
		vec3 hemisphereRay = position + sign(dot(ray, normal)) * ray;

		float occluderZ = viewSpacePos(hemisphereRay).z;
		float difference = occluderZ - hemisphereRay.z;

		occlusion += step(u_depthBias, difference); // * (1.0 - smoothstep(u_depthBias, u_area, difference));
	}

	float ao = clamp(u_baseValue + 1.0 - u_totalStrength * occlusion * (1.0 / samples), 0, 1);
	FragColor = vec4(ao, ao, ao, 1);
	//FragColor = vec4(0.5 * normal + 0.5, 1);
}
