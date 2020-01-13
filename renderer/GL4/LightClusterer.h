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
#pragma once

#include "../tr_local.h"

class LightClusterer {
public:
	LightClusterer();

	void Init();
	void Shutdown();

	void BuildViewClusters(const idMat4 &projectionMatrix);
	void CullLights(const idMat4 &viewMatrix, const viewLight_t *lights);

	void UploadToGpu();

private:
	// these values are taken from DOOM (2016), could try with other variations
	const int NUM_TILES_X = 16;
	const int NUM_TILES_Y = 8;
	const int NUM_TILES_Z = 24;
	const int NUM_CLUSTERS = NUM_TILES_X * NUM_TILES_Y * NUM_TILES_Z;

	struct ClusterLights {
		uint32_t numLights;
		uint32_t listOffset;
	};
	std::vector<idBounds> clusterBoundsViewSpace;	
	std::vector<int> lightIndexList;
	std::vector<ClusterLights> clusterLights;	
};
