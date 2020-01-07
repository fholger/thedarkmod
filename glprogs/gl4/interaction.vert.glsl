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
    mat4 modelViewMatrix;
    vec4 bumpMatrix[2];
    vec4 diffuseMatrix[2];
    vec4 specularMatrix[2];
    mat4 lightProjectionFalloff;
    vec4 colorModulate;
    vec4 colorAdd;
    vec4 lightOrigin;
    vec4 viewOrigin;
    vec4 diffuseColor;
    vec4 specularColor;
    vec4 hasTextureDNS;
    sampler2D normalTexture;
    sampler2D diffuseTexture;
    sampler2D specularTexture;
    sampler3D lightProjectionCubemap;
    sampler2D lightProjectionTexture;
    sampler2D lightFalloffTexture;
};

layout (std140, binding = 0) buffer CB0 {
    ShaderParams params[];
};

out vec3 var_Position;
out vec2 var_TexDiffuse;
out vec2 var_TexNormal;
out vec2 var_TexSpecular;
out vec4 var_TexLight;
out vec4 var_Color;
out vec3 var_WorldLightDir;

out flat vec4 var_lightOrigin;
out flat vec4 var_viewOrigin;

out mat3 var_TangentBitangentNormalMatrix; 
out vec3 var_LightDirLocal;  
out vec3 var_ViewDirLocal;

out flat sampler2D var_normalTexture;
out flat sampler2D var_diffuseTexture;
out flat sampler2D var_specularTexture;
out flat vec4 var_diffuseColor;
out flat vec4 var_specularColor;

out flat sampler3D var_lightProjectionCubemap;
out flat sampler2D var_lightProjectionTexture;
out flat sampler2D var_lightFalloffTexture;

out flat vec4 var_hasTextureDNS;

void sendTBN() {
	// construct tangent-bitangent-normal 3x3 matrix   
	var_TangentBitangentNormalMatrix = mat3( clamp(attr_Tangent,-1,1), clamp(attr_Bitangent,-1,1), clamp(attr_Normal,-1,1) );
	var_LightDirLocal = (params[drawId].lightOrigin.xyz - var_Position).xyz * var_TangentBitangentNormalMatrix;
	var_ViewDirLocal = (params[drawId].viewOrigin.xyz - var_Position).xyz * var_TangentBitangentNormalMatrix;
}


void main() {
    vec4 viewPos = params[drawId].modelViewMatrix * attr_Position;
    gl_Position = projectionMatrix * viewPos;
    
	var_Position = attr_Position.xyz;

	// normal map texgen
	var_TexNormal.x = dot(attr_TexCoord, params[drawId].bumpMatrix[0]);
	var_TexNormal.y = dot(attr_TexCoord, params[drawId].bumpMatrix[1]);

	// diffuse map texgen
	var_TexDiffuse.x = dot(attr_TexCoord, params[drawId].diffuseMatrix[0]);
	var_TexDiffuse.y = dot(attr_TexCoord, params[drawId].diffuseMatrix[1]);

	// specular map texgen
	var_TexSpecular.x = dot(attr_TexCoord, params[drawId].specularMatrix[0]);
	var_TexSpecular.y = dot(attr_TexCoord, params[drawId].specularMatrix[1]);

	// light projection texgen
	var_TexLight = ( attr_Position * params[drawId].lightProjectionFalloff ).xywz;

	// construct tangent-bitangent-normal 3x3 matrix
	sendTBN();

	// primary color
	var_Color = (attr_Color * params[drawId].colorModulate) + params[drawId].colorAdd;

	// light->fragment vector in world coordinates
	var_WorldLightDir = (params[drawId].modelMatrix * vec4(attr_Position.xyz - params[drawId].lightOrigin.xyz, 1)).xyz;
    
    var_lightOrigin = params[drawId].lightOrigin;
    var_viewOrigin = params[drawId].viewOrigin;
    
    var_normalTexture = params[drawId].normalTexture;
    var_diffuseTexture = params[drawId].diffuseTexture;
    var_specularTexture = params[drawId].specularTexture;
    var_diffuseColor = params[drawId].diffuseColor;
    var_specularColor = params[drawId].specularColor;
    
    var_lightProjectionCubemap = params[drawId].lightProjectionCubemap;
    var_lightProjectionTexture = params[drawId].lightProjectionTexture;
    var_lightFalloffTexture = params[drawId].lightFalloffTexture;
    
    var_hasTextureDNS = params[drawId].hasTextureDNS;
}
