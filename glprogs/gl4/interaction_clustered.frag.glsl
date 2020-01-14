#version 450 core
#extension GL_ARB_bindless_texture : require

in vec3 var_Position;
in vec2 var_TexDiffuse;
in vec2 var_TexNormal;
in vec2 var_TexSpecular;
in vec4 var_TexLight;
in vec4 var_Color;
in vec3 var_WorldLightDir;

in flat vec4 var_lightOrigin;
in flat vec4 var_viewOrigin;

in mat3 var_TangentBitangentNormalMatrix; 
in vec3 var_LightDirLocal;  
in vec3 var_ViewDirLocal;

in flat sampler2D var_normalTexture;
in flat sampler2D var_diffuseTexture;
in flat sampler2D var_specularTexture;
in flat vec4 var_diffuseColor;
in flat vec4 var_specularColor;

in flat uvec2 var_lightProjectionTexture;
in flat uvec2 var_lightFalloffTexture;

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

/*// common variables
vec3 lightDir, viewDir;     //direction to light/eye in model coords
vec3 L, V, H;               //normalized light, view and half angle vectors 
float NdotH, NdotL, NdotV;
vec3 RawN, N;


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
	//initialize common variables (TODO: move somewhere else?)
	lightDir = var_lightOrigin.xyz - var_Position;
	viewDir = var_viewOrigin.xyz - var_Position;
	L = normalize(lightDir);
	V = normalize(viewDir);
	H = normalize(L + V);
	calcNormals();
	NdotH = clamp(dot(N, H), 0.0, 1.0);
	NdotL = clamp(dot(N, L), 0.0, 1.0);
	NdotV = clamp(dot(N, V), 0.0, 1.0);
}

vec3 lightColor() {
	// compute light projection and falloff 
	vec3 lightColor;
	if (u_cubic == 1.0) {
		vec3 cubeTC = var_TexLight.xyz * 2.0 - 1.0;
		lightColor = texture(sampler3D(var_lightProjectionTexture), cubeTC).rgb;
		float att = clamp(1.0 - length(cubeTC), 0.0, 1.0);
		lightColor *= att * att;
	}
	else {
		vec3 lightProjection = textureProj(sampler2D(var_lightProjectionTexture), var_TexLight.xyw).rgb;
		vec3 lightFalloff = texture(sampler2D(var_lightFalloffTexture), vec2(var_TexLight.z, 0.5)).rgb;
		lightColor = lightProjection * lightFalloff;
	}
	return lightColor;
}

vec3 computeInteraction() {
	vec4 fresnelParms = vec4(1.0, .23, .5, 1.0);
	vec4 fresnelParms2 = vec4(.2, .023, 120.0, 4.0);
	vec4 lightParms = vec4(.7, 1.8, 10.0, 30.0);

	vec3 diffuse = texture(var_diffuseTexture, var_TexDiffuse).rgb;

	vec3 specular = vec3(0.026);	//default value if texture not set?...
	if (dot(var_specularColor, var_specularColor) > 0.0)
		specular = texture(var_specularTexture, var_TexSpecular).rgb;

	vec3 localL = normalize(var_LightDirLocal);
	vec3 localV = normalize(var_ViewDirLocal);
	//must be done in tangent space, otherwise smoothing will suffer (see #4958)
	float NdotL = clamp(dot(RawN, localL), 0.0, 1.0);
	float NdotV = clamp(dot(RawN, localV), 0.0, 1.0);
	float NdotH = clamp(dot(RawN, normalize(localV + localL)), 0.0, 1.0);

	// fresnel part, ported from test_direct.vfp
	float fresnelTerm = pow(1.0 - NdotV, fresnelParms2.w);
	float rimLight = fresnelTerm * clamp(NdotL - 0.3, 0.0, fresnelParms.z) * lightParms.y;
	float specularPower = mix(lightParms.z, lightParms.w, specular.z);
	float specularCoeff = pow(NdotH, specularPower) * fresnelParms2.z;
	float fresnelCoeff = fresnelTerm * fresnelParms.y + fresnelParms2.y;

	vec3 specularColor = specularCoeff * fresnelCoeff * specular * (diffuse * 0.25 + vec3(0.75));
	float R2f = clamp(localL.z * 4.0, 0.0, 1.0);

	float NdotL_adjusted = NdotL;
	float light = rimLight * R2f + NdotL_adjusted;

	return (specularColor * var_specularColor.rgb * R2f + diffuse * var_diffuseColor.rgb) 
        * light * lightColor() * var_Color.rgb;
}

vec3 ambientInteraction() {
	// compute the diffuse term     
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

	return light.rgb;
}

void main() {
	fetchDNS();
    if (u_ambient == 1) {
        fragColor.rgb = ambientInteraction();
    } else {
        fragColor.rgb = computeInteraction();
    }
	//if (u_shadows)
	//	UseShadowMap();
	fragColor.a = 1.0;
}*/

uniform float u_zNear;
uniform float u_zFar;
uniform float u_zScale;
uniform float u_zBias;
uniform int u_zSlices;

vec3 colors[8] = vec3[](
   vec3(0, 0, 0),    vec3( 0,  0,  1), vec3( 0, 1, 0),  vec3(0, 1,  1),
   vec3(1,  0,  0),  vec3( 1,  0,  1), vec3( 1, 1, 0),  vec3(1, 1, 1)
);


void main() {
    float viewZ = 1.0 / gl_FragCoord.w;  // due to infinite Z projection
    uint zTile = uint(min(u_zSlices - 1, max(log2(viewZ) * u_zScale + u_zBias, 0.0)));
    fragColor = vec4(colors[uint(mod(zTile, 8))], 1.0);
}
