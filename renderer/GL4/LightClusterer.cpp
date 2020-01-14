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

#include "precompiled.h"
#include "LightClusterer.h"
#include "../Profiling.h"
#include "GL4Backend.h"

/*
Implementation inspired by: http://www.aortiz.me/2018/12/21/CG.html

All of this could be done on the GPU side with compute shaders.
Need to profile to decide if it's worth it.
*/

LightClusterer::LightClusterer() {}

void LightClusterer::Init() {
}

void LightClusterer::Shutdown() {
	
}

void LightClusterer::BuildViewClusters( const idMat4 &projectionMatrix ) {
	GL_PROFILE("BuildViewClusters");

	idMat4 inverseProjection = projectionMatrix.Inverse();

	const float clipTileSizeX = 2.0f / NUM_TILES_X;
	const float clipTileSizeY = 2.0f / NUM_TILES_Y;
	const float zNear = r_znear.GetFloat();
	const float zFar = 2000.f;  // TODO: figure out a good value, since projection uses infinite-far-z approximation

	clusterBoundsViewSpace.resize(NUM_CLUSTERS);

	for (int clusterId = 0; clusterId < NUM_CLUSTERS; ++clusterId) {
		int x = clusterId % NUM_TILES_X;
		int y = (clusterId / NUM_TILES_X) % NUM_TILES_Y;
		int z = clusterId / NUM_TILES_X / NUM_TILES_Y;
		
		// subdivide the 2D screen in clip space coordinates into X/Y tiles
		idVec4 clipMinPoint ( -1.f + clipTileSizeX * x, -1.f + clipTileSizeY * y, -1.f, 1.f );
		idVec4 clipMaxPoint ( -1.f + clipTileSizeX * (x+1), -1.f + clipTileSizeY * (y+1), -1.f, 1.f );
		
		// transfer the clip tiles into view space
		idVec4 viewMinPoint = inverseProjection * clipMinPoint;
		viewMinPoint /= viewMinPoint.w;
		idVec4 viewMaxPoint = inverseProjection * clipMaxPoint;
		viewMaxPoint /= viewMaxPoint.w;

		// determine near and far Z values of cluster tile in view space
		// this is a non-linear distribution taken from DOOM (2016)
		float tileNear = -zNear * pow(zFar / zNear, z / float(NUM_TILES_Z));
		float tileFar = -zNear * pow(zFar / zNear, (z+1) / float(NUM_TILES_Z));

		// extend the min and max view points to the near and far Z plane of the tile by following the line from the eye (origin)
		idVec3 minPointNearZ = viewMinPoint.ToVec3() * (tileNear / viewMinPoint.z);
		idVec3 minPointFarZ = viewMinPoint.ToVec3() * (tileFar / viewMinPoint.z);
		idVec3 maxPointNearZ = viewMaxPoint.ToVec3() * (tileNear / viewMaxPoint.z);
		idVec3 maxPointFarZ = viewMaxPoint.ToVec3() * (tileFar / viewMaxPoint.z);

		// determine bounding box in view space from the four points
		clusterBoundsViewSpace[clusterId].Clear();
		clusterBoundsViewSpace[clusterId].AddPoint(minPointNearZ);
		clusterBoundsViewSpace[clusterId].AddPoint(minPointFarZ);
		clusterBoundsViewSpace[clusterId].AddPoint(maxPointNearZ);
		clusterBoundsViewSpace[clusterId].AddPoint(maxPointNearZ);
	}
}

void LightClusterer::CullLights(const idMat4 &viewMatrix, const viewLight_t *lights) {
	GL_PROFILE("CullLights");

	clusterLights.resize(NUM_CLUSTERS);
	lightIndexList.clear();
	int offset = 0;

	for (int clusterId = 0; clusterId < NUM_CLUSTERS; ++clusterId) {
		clusterLights[clusterId].listOffset = offset;

		const idBounds &clusterBounds = clusterBoundsViewSpace[clusterId];
		int lightIndex = 0;
		for (const viewLight_t *vLight = lights; vLight; vLight = vLight->next) {
			idVec3 lightOrigin = viewMatrix * vLight->globalLightOrigin;
			float sqDist = 0.f;
			for (int i = 0; i < 3; ++i) {
				if (lightOrigin[i] < clusterBounds[0][i]) {
					sqDist += (clusterBounds[0][i] - lightOrigin[i]) * (clusterBounds[0][i] - lightOrigin[i]);
				}
				if (lightOrigin[i] > clusterBounds[1][i]) {
					sqDist += (lightOrigin[i] - clusterBounds[1][i]) * (lightOrigin[i] - clusterBounds[1][i]);
				}
			}
			if (sqDist <= vLight->radius * vLight->radius) {
				lightIndexList.push_back(lightIndex);
				++offset;
			}

			++lightIndex;
		}

		clusterLights[clusterId].numLights = offset - clusterLights[clusterId].listOffset;
	}

}

void LightClusterer::UploadToGpu() {
	ClusterLights *clusters = gl4Backend->GetShaderArray<ClusterLights>();
	memcpy(clusters, clusterLights.data(), sizeof(ClusterLights) * clusterLights.size());
	gl4Backend->BindShaderArray<ClusterLights>( clusterLights.size(), GL_SHADER_STORAGE_BUFFER, 9 );
	uint32_t *lightList = gl4Backend->GetShaderArray<uint32_t>();
	memcpy(lightList, lightIndexList.data(), lightIndexList.size());
	gl4Backend->BindShaderArray<uint32_t>( lightIndexList.size(), GL_SHADER_STORAGE_BUFFER, 10 );
}

