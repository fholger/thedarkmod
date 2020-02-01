#version 450 core
#extension GL_ARB_bindless_texture : require

#pragma tdm_include "gl4/projection.glsl"

layout (location = 0) in vec4 attr_Position;
layout (location = 2) in vec3 attr_Normal;
layout (location = 3) in vec4 attr_Color;
layout (location = 8) in vec4 attr_TexCoord;
layout (location = 9) in vec3 attr_Tangent;
layout (location = 10) in vec3 attr_Bitangent;
layout (location = 15) in int drawId;

struct ShaderParams {
    mat4 modelMatrix;
    mat4 inverseModelMatrix;
    mat4 modelViewMatrix;
    vec4 bumpMatrix[2];
    vec4 diffuseMatrix[2];
    vec4 specularMatrix[2];
    vec4 colorModulate;
    vec4 colorAdd;
    vec4 viewOrigin;
    vec4 diffuseColor;
    vec4 specularColor;
    vec4 hasTextureDNS;
    vec4 ambientRimColor;
    uvec2 normalTexture;
    uvec2 diffuseTexture;
    uvec2 specularTexture;
    uvec2 padding;
};

layout (std430, binding = 0) buffer CB0 {
    ShaderParams params[];
};

out vec3 var_Position;
out vec2 var_TexDiffuse;
out vec2 var_TexNormal;
out vec2 var_TexSpecular;
out vec4 var_Color;

out flat vec4 var_viewOrigin;

out mat3 var_TangentBitangentNormalMatrix; 

out flat sampler2D var_normalTexture;
out flat sampler2D var_diffuseTexture;
out flat sampler2D var_specularTexture;
out flat vec4 var_diffuseColor;
out flat vec4 var_specularColor;

out flat vec4 var_hasTextureDNS;
out flat vec4 var_rimColor;

out flat mat4 var_modelMatrix;

void sendTBN() {
	// construct tangent-bitangent-normal 3x3 matrix in world space
    vec3 worldTangent = normalize((params[drawId].modelMatrix * vec4(attr_Tangent, 0)).xyz);
    vec3 worldBitangent = normalize((params[drawId].modelMatrix * vec4(attr_Bitangent, 0)).xyz);
    vec3 worldNormal = normalize((params[drawId].modelMatrix * vec4(attr_Normal, 0)).xyz);
	var_TangentBitangentNormalMatrix = mat3( clamp(worldTangent,-1,1), clamp(worldBitangent,-1,1), clamp(worldNormal,-1,1) );
}


void main() {
    vec4 viewPos = params[drawId].modelViewMatrix * attr_Position;
    gl_Position = projectionMatrix * viewPos;
    
	var_Position = (params[drawId].modelMatrix * attr_Position).xyz;

	// normal map texgen
	var_TexNormal.x = dot(attr_TexCoord, params[drawId].bumpMatrix[0]);
	var_TexNormal.y = dot(attr_TexCoord, params[drawId].bumpMatrix[1]);

	// diffuse map texgen
	var_TexDiffuse.x = dot(attr_TexCoord, params[drawId].diffuseMatrix[0]);
	var_TexDiffuse.y = dot(attr_TexCoord, params[drawId].diffuseMatrix[1]);

	// specular map texgen
	var_TexSpecular.x = dot(attr_TexCoord, params[drawId].specularMatrix[0]);
	var_TexSpecular.y = dot(attr_TexCoord, params[drawId].specularMatrix[1]);

	// construct tangent-bitangent-normal 3x3 matrix
	sendTBN();

	// primary color
	var_Color = (attr_Color * params[drawId].colorModulate) + params[drawId].colorAdd;

    var_viewOrigin = params[drawId].viewOrigin;
    
    var_normalTexture = sampler2D(params[drawId].normalTexture);
    var_diffuseTexture = sampler2D(params[drawId].diffuseTexture);
    var_specularTexture = sampler2D(params[drawId].specularTexture);
    var_diffuseColor = params[drawId].diffuseColor;
    var_specularColor = params[drawId].specularColor;
    
    var_hasTextureDNS = params[drawId].hasTextureDNS;
    var_rimColor = params[drawId].ambientRimColor;
    
    var_modelMatrix = params[drawId].modelMatrix;
}
