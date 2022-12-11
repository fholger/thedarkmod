/*****************************************************************************
The Dark Mod GPL Source Code

This file is part of the The Dark Mod Source Code, originally based
on the Doom 3 GPL Source Code as published in 2011.

The Dark Mod Source Code is free software: you can redistribute it
and/or modify it under the terms of the GNU General Public License as
published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version. For details, see LICENSE.TXT.

Project: The Dark Mod (http://www.thedarkmod.com/)

******************************************************************************/

#define SOFT_SHADOWS_SAMPLES_COUNT 150

#pragma tdm_define "POISSON_DISK_USE_UBO"

#if POISSON_DISK_USE_UBO
	layout (std140) uniform ShadowSamplesBlock {
		vec2 u_softShadowsSamples[SOFT_SHADOWS_SAMPLES_COUNT];
	};
#else
	// TODO: remove this part after new/old backends get merged
	uniform vec2 u_softShadowsSamples[SOFT_SHADOWS_SAMPLES_COUNT];
#endif

