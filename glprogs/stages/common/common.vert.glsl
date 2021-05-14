#pragma tdm_include "stages/common/view_params.glsl"
#pragma tdm_include "stages/common/entity_params.glsl"

in vec4 attr_Position;
in vec3 attr_Normal;
in vec3 attr_Tangent;
in vec3 attr_Bitangent;
in vec4 attr_Color;
in vec2 attr_TexCoord;
in int attr_DrawId;

out vec4 var_TexCoord;
flat out int var_DrawId;


void transformVertexPosition() {
	gl_Position = viewParams.projectionMatrix * (entityParams.modelViewMatrix * attr_Position);
}

void forwardTexCoord() {
	var_TexCoord = vec4(attr_TexCoord, 0, 0);
}

void forwardDrawId() {
	var_DrawId = attr_DrawId;
}
