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


class PersistentBuffer {
public:
	PersistentBuffer();
	~PersistentBuffer();

	void Init( GLenum target, GLuint size, GLuint alignment = 32 );
	void Destroy();

	byte *Reserve( GLuint size );
	void MarkAsUsed( GLuint size );
	void Lock();

	void BindBuffer();

	void BindBufferRange( GLuint index, GLuint size );
	void BindBufferBase( GLuint index );

	void* GetOffset() const { return ( void* )( mCurrentOffset ); }

	template<typename T>
	T *AllocateAndBind( GLuint count, GLuint index ) {
        static_assert(sizeof(T) <= 256, "Used type must not exceed 256 bytes of data");
        GLuint size = count * sizeof(T);
	    byte *rawPointer = Reserve(size);
	    BindBufferRange(index, size);
	    MarkAsUsed(size);
	    return reinterpret_cast<T*>(rawPointer);
	}

private:
	struct LockedRange {
		GLuint offset;
		GLuint count;
		GLsync fenceSync;

		bool Overlaps(const LockedRange& other) const {
			return offset < other.offset + other.count && other.offset < offset + count;
		}
	};

	GLuint mBufferObject;
	GLenum mTarget;
	GLuint mSize;
	GLuint mAlign;
	byte * mMapBase;
	GLuint mCurrentOffset;
	GLuint mLastLocked;
	std::vector<LockedRange> mRangeLocks;

	void LockRange( GLuint offset, GLuint count );
	void WaitForLockedRange( GLuint offset, GLuint count );
	void Wait( LockedRange &range );
};
