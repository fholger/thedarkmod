/*
===========================================================================

Doom 3 GPL Source Code
Copyright (C) 1999-2011 id Software LLC, a ZeniMax Media company.

This file is part of the Doom 3 GPL Source Code ("Doom 3 Source Code").

Doom 3 Source Code is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

Doom 3 Source Code is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with Doom 3 Source Code.  If not, see <http://www.gnu.org/licenses/>.

In addition, the Doom 3 Source Code is also subject to certain additional terms. You should have received a copy of these additional terms immediately following the terms and conditions of the GNU General Public License which accompanied the Doom 3 Source Code.  If not, please request a copy in writing from id Software at the address below.

If you have questions concerning this license or the applicable additional terms, you may contact in writing id Software LLC, c/o ZeniMax Media Inc., Suite 120, Rockville, Maryland 20850 USA.

===========================================================================
*/

#pragma once

extern idCVar r_useFbo;
extern idCVar r_fboDebug;
extern idCVar r_fboColorBits;
extern idCVar r_fboDepthBits;
extern idCVar r_fboSeparateStencil;
extern idCVar r_fboResolution;
extern idCVar r_shadowMapSize;

extern int ShadowMipMap;

void FB_Clear();
void FB_CopyColorBuffer();
void FB_CopyDepthBuffer();
void FB_CopyRender( const copyRenderCommand_t &cmd );
void FB_TogglePrimary( bool on );
void FB_ToggleShadow( bool on, bool clear = false );
void FB_BindShadowTexture();
void FB_SelectPrimary();
void FB_SelectPostProcess();
void FB_ResolveMultisampling( GLbitfield mask = GL_COLOR_BUFFER_BIT, GLenum filter = GL_NEAREST );
void FB_ApplyScissor();

class FrameBuffer {
public:
	~FrameBuffer();

	static FrameBuffer * Create( GLuint width, GLuint height, int msaa = 0 );
	static FrameBuffer * BackBuffer();
	static FrameBuffer * FrontBuffer();

	void CreateColorBuffer();
	void CreateDepthStencilBuffer();

	void AddColorTexture( idImage *colorTexture );
	void AddDepthStencilTexture( idImage *depthStencilTexture );
	void AddDepthStencilTextures( idImage *depthTexture, idImage *stencilTexture );

	void SetResolveColorFbo( FrameBuffer *resolveColorFbo );
	void SetResolveDepthFbo( FrameBuffer *resolveDepthFbo );
	FrameBuffer * GetResolveColorFbo() const { return resolveColorFbo; }
	FrameBuffer * GetResolveDepthFbo() const { return resolveDepthFbo; }

	void Validate();

	void Bind();
	void BindDraw();
	void BindRead();

	void BlitFullTo( FrameBuffer *target, GLbitfield mask = GL_COLOR_BUFFER_BIT, GLenum filter = GL_NEAREST );

	/* Makes a copy of the current fbo color contents to the given texture.
	 * If target texture is bound to this fbo, the copy is skipped.
	 * If target texture is bound to the resolveColor fbo, will use a blit to the resolveColor fbo.
	 * Otherwise, a copy to the texture is made.
	 */
	void CopyColor( idImage *target );

	/* Make a copy of the current fbo depth contents to the given texture. Same procedure as for color above. */
	void CopyDepth( idImage *target );

	GLuint GetWidth() const { return width; }
	GLuint GetHeight() const { return height; }
	int GetMSAA() const { return msaa; }

private:
	FrameBuffer( GLuint fbo, GLuint width, GLuint height, int msaa );

	GLuint fbo;
	GLenum colorBufferType;
	GLuint colorBuffer;
	idImage *colorTexture;
	GLuint depthStencilBuffer;
	idImage *depthTexture;
	idImage *stencilTexture;

	FrameBuffer *resolveColorFbo;
	FrameBuffer *resolveDepthFbo;

	GLuint width;
	GLuint height;
	int msaa;
};

struct frameBuffers_t {
	// These are the available framebuffers. Do NOT use them directly in rendering code!
	FrameBuffer *primary;
	FrameBuffer *resolve;
	FrameBuffer *lightgem;
	FrameBuffer *backBuffer;
	FrameBuffer *frontBuffer;

	// These are the current routing targets for rendering.
	FrameBuffer *renderTarget;
	FrameBuffer *finalOutput;

	// Currently bound framebuffers cache
	FrameBuffer *currentDraw;
	FrameBuffer *currentRead;

	idList<FrameBuffer*> allFrameBuffers;
};
extern frameBuffers_t frameBuffers;

void FB_InitFrameBuffers();
void FB_ShutdownFrameBuffers();
