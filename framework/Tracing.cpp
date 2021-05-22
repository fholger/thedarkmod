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
#include "Tracing.h"

idCVar r_useDebugGroups( "r_useDebugGroups", "0", CVAR_RENDERER | CVAR_BOOL, "Emit GL debug groups during rendering. Useful for frame debugging and analysis with e.g. nSight, which will group render calls accordingly." );

void GL_SetDebugLabel(GLenum identifier, GLuint name, const idStr &label ) {
	if( r_useDebugGroups.GetBool() ) {
		qglObjectLabel( identifier, name, std::min(label.Length(), 256), label.c_str() );
	}
}

void GL_SetDebugLabel(void *ptr, const idStr &label ) {
	if( r_useDebugGroups.GetBool() ) {
		qglObjectPtrLabel( ptr, std::min(label.Length(), 256), label.c_str() );
	}
}

void InitOpenGLTracing() {
	MicroProfileGpuInitGL();
}

void TracingEndFrame() {
	MicroProfileFlip( nullptr );
}
