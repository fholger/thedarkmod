#version 330 core
#pragma tdm_include "stages/common/common.vert.glsl"
#pragma tdm_include "stages/depth/depth.params.glsl"

uniform vec4 u_clipPlane;

out float var_ClipPlaneDist;

void main() {
	transformVertexPosition();
	var_TexCoord = params.textureMatrix * vec4(attr_TexCoord, 0, 1);
	var_ClipPlaneDist = dot(entityParams.modelMatrix * attr_Position, u_clipPlane);
	// fixme: would be preferable to use GL native clip distances, but this causes flickering
	//gl_ClipDistance[0] = var_ClipPlaneDist;
}
