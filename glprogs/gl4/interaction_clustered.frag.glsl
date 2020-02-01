#version 450 core
#extension GL_ARB_bindless_texture : require

in vec3 var_Position;
in vec2 var_TexDiffuse;
in vec2 var_TexNormal;
in vec2 var_TexSpecular;
in vec4 var_Color;

in flat vec4 var_viewOrigin;

in mat3 var_TangentBitangentNormalMatrix; 

in flat sampler2D var_normalTexture;
in flat sampler2D var_diffuseTexture;
in flat sampler2D var_specularTexture;
in flat vec4 var_diffuseColor;
in flat vec4 var_specularColor;

in flat vec4 var_hasTextureDNS;
in flat vec4 var_rimColor;

in flat mat4 var_modelMatrix;

layout (location = 0) uniform int u_RGTC;
layout (location = 1) uniform int u_cubic;
layout (location = 2) uniform int u_shadows;
layout (location = 3) uniform int u_ambient;
layout (location = 4) uniform float u_minLevel;
layout (location = 5) uniform float u_gamma;

layout (location = 0) out vec4 fragColor;

struct LightParams {
    vec4 origin;
    vec4 color;
    mat4 projectionFalloff;
    uvec2 projectionTexture;
    uvec2 falloffTexture;
    int cubic;
    int shadows;
    int ambient;
    int padding;
};
layout (std430, binding = 5) buffer Lights {
    LightParams lights[];
};

layout (std430, binding = 10) buffer CB {
    uint lightIndexList[];
};

layout (std430, binding = 9) buffer CB1 {
    uvec2 clusterLights[];
};

// common variables
vec3 viewDir;
vec3 V;
float NdotV;
vec3 RawN, N;

vec3 diffuse, specular;
vec3 lightSpecular, lightDiffuse;


void calcNormals() {
    // compute normal from normal map, move from [0, 1] to [-1, 1] range, normalize 
	if (var_hasTextureDNS[1] != 0) {
		vec4 bumpTexel = texture ( var_normalTexture, var_TexNormal.st ) * 2. - 1.;
    	RawN = u_RGTC == 1. 
	    	? vec3(bumpTexel.x, bumpTexel.y, sqrt(max(1.-bumpTexel.x*bumpTexel.x-bumpTexel.y*bumpTexel.y, 0)))
		    : normalize( bumpTexel.wyz ); 
    	N = normalize(var_TangentBitangentNormalMatrix * RawN);
	}
	else {
		RawN = vec3(0, 0, 1);
		N = normalize(var_TangentBitangentNormalMatrix[2]);
	}
}

//fetch surface normal at fragment
void fetchDNS() {
	//initialize common variables
	//lightDir = var_lightOrigin.xyz - var_Position;
	viewDir = var_viewOrigin.xyz - var_Position;
	//L = normalize(lightDir);
	V = normalize(viewDir);
	//H = normalize(L + V);
	calcNormals();
	//NdotH = clamp(dot(N, H), 0.0, 1.0);
	//NdotL = clamp(dot(N, L), 0.0, 1.0);
	NdotV = clamp(dot(N, V), 0.0, 1.0);
}

vec3 lightColor(int idx) {
	// compute light projection and falloff 
	vec4 texLight = ( vec4(var_Position, 1) * lights[idx].projectionFalloff ).xywz;
    
	vec3 lightColor;
	if (u_cubic == 1.0) {
		vec3 cubeTC = texLight.xyz * 2.0 - 1.0;
		lightColor = texture(sampler3D(lights[idx].projectionTexture), cubeTC).rgb;
		float att = clamp(1.0 - length(cubeTC), 0.0, 1.0);
		lightColor *= att * att;
	}
	else {
		vec3 lightProjection = textureProj(sampler2D(lights[idx].projectionTexture), texLight.xyw).rgb;
		vec3 lightFalloff = texture(sampler2D(lights[idx].falloffTexture), vec2(texLight.z, 0.5)).rgb;
		lightColor = lightProjection * lightFalloff;
	}
	return lightColor;
    /*vec3 lightVec = var_Position - lights[idx].origin.xyz;
    float lightDistSqr = dot(lightVec, lightVec);
    float invDistSqr = 1.0 / lightDistSqr;
    return lights[idx].color.rgb * sqrt(invDistSqr);*/
}

void lightInteraction(int idx) {
	vec4 fresnelParms = vec4(1.0, .23, .5, 1.0);
	vec4 fresnelParms2 = vec4(.2, .023, 120.0, 4.0);
	vec4 lightParms = vec4(.7, 1.8, 10.0, 30.0);
    
    vec3 L = normalize(lights[idx].origin.xyz - var_Position);
    vec3 H = normalize(L + V);
    float NdotH = clamp(dot(N, H), 0.0, 1.0);
    float NdotL = clamp(dot(N, L), 0.0, 1.0);

	// fresnel part, ported from test_direct.vfp
	float fresnelTerm = pow(1.0 - NdotV, fresnelParms2.w);
	float rimLight = fresnelTerm * clamp(NdotL - 0.3, 0.0, fresnelParms.z) * lightParms.y;
	float specularPower = mix(lightParms.z, lightParms.w, specular.z);
	float specularCoeff = pow(NdotH, specularPower) * fresnelParms2.z;
	float fresnelCoeff = fresnelTerm * fresnelParms.y + fresnelParms2.y;

	float specularColor = specularCoeff * fresnelCoeff;
	float R2f = clamp(L.z * 4.0, 0.0, 1.0);

	float light = rimLight * R2f + NdotL;

    vec3 colorLight = lightColor(idx);
    lightSpecular += specularColor * R2f * light * colorLight * lights[idx].color.rgb;
    lightDiffuse += light * colorLight * lights[idx].color.rgb;
}

void ambientInteraction(int idx) {
	/*// compute the diffuse term     
	vec4 matDiffuse = texture( var_diffuseTexture, var_TexDiffuse );
	vec3 matSpecular = texture( var_specularTexture, var_TexSpecular ).rgb;

	vec3 nViewDir = normalize(viewDir);
	vec3 reflect = - (nViewDir - 2*N*dot(N, nViewDir));

	// compute lighting model     
	vec4 color = var_diffuseColor * var_Color, light;
	if (u_cubic == 1.0) {
		vec3 tl = vec3(var_TexLight.xy/var_TexLight.w, var_TexLight.z) - .5;
		float a = .25 - tl.x*tl.x - tl.y*tl.y - tl.z*tl.z;
		light = vec4(vec3(a*2), 1); // FIXME pass r_lightScale as uniform
	} else {
		vec3 lightProjection = textureProj( sampler2D(var_lightProjectionTexture), var_TexLight.xyw ).rgb; 
		vec3 lightFalloff = texture( sampler2D(var_lightFalloffTexture), vec2( var_TexLight.z, 0.5 ) ).rgb;
		light = vec4(lightProjection * lightFalloff, 1);
	} 

	if (u_cubic == 1.0) {
		vec4 worldN = var_modelMatrix * vec4(N, 0); // rotation only
		vec3 cubeTC = var_TexLight.xyz * 2.0 - 1.0;
		// diffuse
		vec4 light1 = texture(sampler3D(var_lightProjectionTexture), worldN.xyz) * matDiffuse;
		// specualr
		light1.rgb += texture( sampler3D(var_lightFalloffTexture), reflect, 2 ).rgb * matSpecular;
		light.rgb *= color.rgb * light1.rgb;
		light.a = light1.a;
	} else {
		vec3 light1 = vec3(.5); // directionless half
		light1 += max(dot(N, var_lightOrigin.xyz) * (1. - matSpecular) * .5, 0);
		float spec = max(dot(reflect, var_lightOrigin.xyz), 0);
		float specPow = clamp((spec*spec), 0.0, 1.1);
		light1 += vec3(spec*specPow*specPow) * matSpecular * 1.0;
		light.a = matDiffuse.a;

		light1.rgb *= color.rgb;
		if (u_minLevel != 0) // home-brewed "pretty" linear
			light1.rgb = light1.rgb * (1.0 - u_minLevel) + vec3(u_minLevel);
		light.rgb *= matDiffuse.rgb * light1;
	}

	if(u_gamma != 1 ) // old-school exponential
		light.rgb = pow(light.rgb, vec3(1.0 / u_gamma));

	if(var_rimColor.a != 0) {
		float NV = 1-abs(dot(N, nViewDir));
		NV *= NV;
		light.rgb += var_rimColor.rgb * NV * NV;
	}

	return light.rgb;*/
}

uniform float u_zNear;
uniform float u_zFar;
uniform float u_zScale;
uniform float u_zBias;
uniform int u_zSlices;
uniform int u_numLights;

vec3 colors[8] = vec3[](
   vec3(0, 0, 0),    vec3( 0,  0,  1), vec3( 0, 1, 0),  vec3(0, 1,  1),
   vec3(1,  0,  0),  vec3( 1,  0,  1), vec3( 1, 1, 0),  vec3(1, 1, 1)
);


void main() {
    float viewZ = 1.0 / gl_FragCoord.w;  // due to infinite Z projection
    uint zTile = uint(min(u_zSlices - 1, max(log2(viewZ) * u_zScale + u_zBias, 0.0)));
    //fragColor = vec4(colors[uint(mod(zTile, 8))], 1.0);
    
	diffuse = texture(var_diffuseTexture, var_TexDiffuse).rgb;
    specular = texture(var_specularTexture, var_TexSpecular).rgb;
    fetchDNS();
    
    lightSpecular = vec3(0, 0, 0);
    lightDiffuse = vec3(0, 0, 0);
    for (int i = 0; i < u_numLights; i++) {
        if (lights[i].ambient == 1) {
            ambientInteraction(i);
        } else {
            lightInteraction(i);
        }
    }
    
    fragColor.rgb = lightSpecular * specular * var_specularColor.rgb + lightDiffuse * diffuse * var_diffuseColor.rgb;
    fragColor.a = 1;
    
    //fragColor.rgb = N;
}
