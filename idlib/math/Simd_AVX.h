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

/*
===============================================================================

	AVX implementation of idSIMDProcessor

===============================================================================
*/

class idSIMD_AVX : public idSIMD_SSE3 {
public:
	virtual const char * VPCALL GetName( void ) const;
	virtual void VPCALL CullByFrustum( idDrawVert *verts, const int numVerts, const idPlane frustum[6], unsigned short int *pointCull, float epsilon );
};