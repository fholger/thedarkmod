struct ViewParams {
	mat4 projectionMatrix;
};

layout (std140) uniform ViewParamsBlock {
	ViewParams viewParams;
};
