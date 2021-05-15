struct ShaderParams {
	mat4 textureMatrix;
	vec4 color;
	uvec2 textureHandle;
	float alphaTest;
	float padding;
};

layout (std140) uniform ShaderParamsBlock {
	ShaderParams params;
};
