#version 140

in vec4 attr_Position;
in vec2 attr_TexCoord;
out vec2 var_TexCoord;
out vec2 var_ViewRay;

uniform block {
	mat4 u_projectionMatrix;
};

void main() {
	gl_Position = attr_Position;
	var_TexCoord = attr_TexCoord;
	var_ViewRay.x = - attr_Position.x / u_projectionMatrix[0][0];
	var_ViewRay.y = - attr_Position.y / u_projectionMatrix[1][1];
}
