struct EntityParams {
	mat4 modelMatrix;
	mat4 modelViewMatrix;
	vec4 localViewOrigin;
};

layout (std140) uniform EntityParamsBlock {
	EntityParams entityParams;
};
