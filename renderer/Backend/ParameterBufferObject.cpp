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
#include "ParameterBufferObject.h"

ParameterBufferObject::ParameterBufferObject(): mBufferObject(0 ), mTarget(0 ), mSize(0 ), mAlign(0 ), mMapBase(nullptr ), mCurrentOffset(0 ), mLastLocked(0 ) {}

ParameterBufferObject::~ParameterBufferObject() {
	Destroy();
}

void ParameterBufferObject::Init(GLenum target, GLuint size, GLuint alignment ) {
	if( mMapBase ) {
		Destroy();
	}

	mTarget = target;
	mSize = ALIGN( size, alignment );
	mAlign = alignment;
	qglGenBuffers( 1, &mBufferObject );
	qglBindBuffer( mTarget, mBufferObject );
	qglBufferStorage( mTarget, mSize, nullptr, GL_MAP_WRITE_BIT | GL_MAP_PERSISTENT_BIT | GL_MAP_COHERENT_BIT );
	mMapBase = ( byte* )qglMapBufferRange( mTarget, 0, mSize, GL_MAP_WRITE_BIT | GL_MAP_PERSISTENT_BIT | GL_MAP_COHERENT_BIT );
	mCurrentOffset = 0;
	mLastLocked = 0;
}

void ParameterBufferObject::Destroy() {
	if( !mBufferObject ) {
		return;
	}

	qglBindBuffer( mTarget, mBufferObject );
	qglUnmapBuffer( mTarget );
	qglDeleteBuffers( 1, &mBufferObject );
	mBufferObject = 0;
	mMapBase = nullptr;
}

byte *ParameterBufferObject::Reserve(GLuint size ) {
	GLuint requestedSize = ALIGN( size, mAlign );
	if( requestedSize > mSize ) {
		return nullptr;
	}

	if( mCurrentOffset + requestedSize > mSize ) {
		if( mCurrentOffset != mLastLocked ) {
			LockRange( mLastLocked, mCurrentOffset - mLastLocked );
		}
		mCurrentOffset = 0;
		mLastLocked = 0;
	}

	WaitForLockedRange( mCurrentOffset, requestedSize );
	return mMapBase + mCurrentOffset;
}

void ParameterBufferObject::MarkAsUsed(GLuint size ) {
	GLuint requestedSize = ALIGN( size, mAlign );
	//LockRange( mCurrentOffset, requestedSize );
	mCurrentOffset += requestedSize;
}

void ParameterBufferObject::Lock() {
	LockRange( mLastLocked, mCurrentOffset - mLastLocked );
	mLastLocked = mCurrentOffset;
}

void ParameterBufferObject::BindBuffer() {
	qglBindBuffer( mTarget, mBufferObject );
}

void ParameterBufferObject::BindBufferRange(GLuint index, GLuint size ) {
	GLuint requestedSize = ALIGN( size, mAlign );
	qglBindBufferRange( mTarget, index, mBufferObject, mCurrentOffset, requestedSize );
}

void ParameterBufferObject::BindBufferBase(GLuint index ) {
	qglBindBufferBase( mTarget, index, mBufferObject );
}

void ParameterBufferObject::LockRange(GLuint offset, GLuint count ) {
	GLsync fence = qglFenceSync( GL_SYNC_GPU_COMMANDS_COMPLETE, 0 );
	LockedRange range = { offset, count, fence };
	mRangeLocks.push_back( range );
}

void ParameterBufferObject::WaitForLockedRange(GLuint offset, GLuint count ) {
	LockedRange waitRange = { offset, count, 0 };
	for( auto it = mRangeLocks.begin(); it != mRangeLocks.end(); ) {
		if( waitRange.Overlaps( *it ) ) {
			Wait( *it );
			it = mRangeLocks.erase( it );
		} else {
			++it;
		}
	}
}

void ParameterBufferObject::Wait(LockedRange &range ) {
	GLenum result = qglClientWaitSync( range.fenceSync, 0, 0 );
	while( result != GL_ALREADY_SIGNALED && result != GL_CONDITION_SATISFIED ) {
		result = qglClientWaitSync( range.fenceSync, GL_SYNC_FLUSH_COMMANDS_BIT, 1000000 );
		if( result == GL_WAIT_FAILED ) {
			assert( !"glClientWaitSync failed" );
			break;
		}
	}
	qglDeleteSync( range.fenceSync );
}