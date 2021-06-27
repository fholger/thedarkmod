#pragma tdm_include "stages/common/view_params.glsl"
#pragma tdm_include "stages/common/entity_params.glsl"

#pragma tdm_define "BINDLESS_TEXTURES"
#ifdef BINDLESS_TEXTURES
#extension GL_ARB_bindless_texture : require
#define SAMPLER2D(handle, sampler) sampler2D(handle)
#else
#define SAMPLER2D(handle, sampler) sampler
#endif

in vec4 var_TexCoord;
flat in int var_DrawId;

out vec4 out_Color;
