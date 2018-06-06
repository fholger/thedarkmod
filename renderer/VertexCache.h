/*****************************************************************************
The Dark Mod GPL Source Code

This file is part of the The Dark Mod Source Code, originally based
on the Doom 3 GPL Source Code as published in 2011.

The Dark Mod Source Code is free software: you can redistribute it
and/or modify it under the terms of the GNU General Public License as
published by the Free Software Foundation, either version 3 of the License,
or (at your option) any later version. For details, see LICENSE.TXT.

Project: The Dark Mod (http://www.thedarkmod.com/)

$Revision$ (Revision of last commit)
$Date$ (Date of last commit)
$Author$ (Author of last commit)

******************************************************************************/

#ifndef __VERTEXCACHE_H__
#define __VERTEXCACHE_H__

#include "BufferObject.h"

// vertex cache calls should only be made by the front end

const int VERTCACHE_NUM_FRAMES = 3;

const int VERTCACHE_STATIC = 1;					// in the static set, not the per-frame set
const int VERTCACHE_SIZE_SHIFT = 1;
const int VERTCACHE_SIZE_MASK = 0x7fffff;		// 8 megs 
const int VERTCACHE_OFFSET_SHIFT = 24;
const int VERTCACHE_OFFSET_MASK = 0x7ffffff;	// 128 megs 
const int VERTCACHE_FRAME_SHIFT = 51;
const int VERTCACHE_FRAME_MASK = 0x1fff;		// 13 bits = 8k frames to wrap around

const int VERTEX_CACHE_ALIGN = 32;
const int INDEX_CACHE_ALIGN = 16;
#define ALIGN( x, a ) ( ( ( x ) + ((a)-1) ) & ~((a)-1) )

enum cacheType_t {
	CACHE_VERTEX,
	CACHE_INDEX,
	CACHE_JOINT
};

struct geoBufferSet_t {
	BufferObject		indexBuffer;
	BufferObject		vertexBuffer;
	byte *				mappedVertexBase;
	byte *				mappedIndexBase;
	std::atomic<int>	indexMemUsed;
	std::atomic<int>	vertexMemUsed;
	int					allocations;	// number of index and vertex allocations combined
	int					vertexMapOffset;
	int					indexMapOffset;
	GLsync				bufferLock;

	geoBufferSet_t( GLenum usage = GL_DYNAMIC_DRAW_ARB );
};

class idVertexCache {
public:
	idVertexCache();

	void			Init();
	void			Shutdown();

	// called when vertex programs are enabled or disabled, because
	// the cached data is no longer valid
	void			PurgeAll();

	// will be an int offset cast to a pointer of ARB_vertex_buffer_object
	void *			VertexPosition( vertCacheHandle_t handle );
	void *			IndexPosition( vertCacheHandle_t handle );

	// if you need to draw something without an indexCache, this must be called to reset GL_ELEMENT_ARRAY_BUFFER_ARB
	void			UnbindIndex();

	// updates the counter for determining which temp space to use
	// and which blocks can be purged
	// Also prints debugging info when enabled
	void			EndFrame();

	// this data is only valid for one frame of rendering
	vertCacheHandle_t AllocVertex( const void * data, int bytes ) {
		return ActuallyAlloc( frameData[listNum], data, bytes, CACHE_VERTEX );
	}
	vertCacheHandle_t AllocIndex( const void * data, int bytes ) {
		return ActuallyAlloc( frameData[listNum], data, bytes, CACHE_INDEX );
	}

	// this data is valid until the next map load
	vertCacheHandle_t AllocStaticVertex( const void *data, int bytes ) {
		vertCacheHandle_t handle = ActuallyAlloc( staticData, data, bytes, CACHE_VERTEX );
		if( handle == 0 ) {
			common->FatalError( "AllocStaticVertex failed, increase r_staticVertexMemory" );
		}
		return handle;
	}
	vertCacheHandle_t AllocStaticIndex( const void *data, int bytes ) {
		vertCacheHandle_t handle = ActuallyAlloc( staticData, data, bytes, CACHE_INDEX );
		if( handle == 0 ) {
			common->FatalError( "AllocStaticIndex failed, increase r_staticIndexMemory" );
		}
		return handle;
	}

	// Returns false if it's been purged
	// This can only be called by the front end, the back end should only be looking at
	// vertCacheHandle_t that are already validated.
	bool			CacheIsCurrent( const vertCacheHandle_t handle ) const {
		if( CacheIsStatic( handle ) ) {
			return true;
		}
		const uint64 frameNum = ( int )( handle >> VERTCACHE_FRAME_SHIFT ) & VERTCACHE_FRAME_MASK;
		if( frameNum != ( currentFrame & VERTCACHE_FRAME_MASK ) ) {
			return false;
		}
		return true;
	}

	static bool		CacheIsStatic( const vertCacheHandle_t handle ) {
		return ( handle & VERTCACHE_STATIC ) != 0;
	}


private:
	static idCVar	r_showVertexCache;
	static idCVar	r_staticVertexMemory;
	static idCVar	r_staticIndexMemory;
	static idCVar	r_frameVertexMemory;
	static idCVar	r_frameIndexMemory;

	int				currentFrame;			// for purgable block tracking
	int				listNum;				// currentFrame % NUM_VERTEX_FRAMES, determines which tempBuffers to use
	int				backendListNum;

	geoBufferSet_t	frameData[VERTCACHE_NUM_FRAMES];
	geoBufferSet_t  staticData;

	GLuint			currentVertexBuffer;
	GLuint			currentIndexBuffer;

	int				staticBufferUsed;
	int				tempBufferUsed;

	// Try to make room for <bytes> bytes
	vertCacheHandle_t ActuallyAlloc( geoBufferSet_t & vcs, const void * data, int bytes, cacheType_t type );
};

extern idVertexCache vertexCache;

#endif