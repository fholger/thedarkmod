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
#include "GL4Backend.h"
#include <renderer/FrameBuffer.h>
#include <renderer/Profiling.h>

GL4Backend backendImpl;
GL4Backend *gl4Backend = &backendImpl;

idCVar r_useGL4Backend("r_useGL4Backend", "1", CVAR_RENDERER | CVAR_BOOL | CVAR_ARCHIVE, "Use the experimental new GL4 render backend" );

GL4Backend::GL4Backend() {

}

void GL4Backend::Init() {
    depthStage.Init();
}

void GL4Backend::Shutdown() {
    depthStage.Shutdown();
}

void GL4Backend::ExecuteRenderCommands(const emptyCommand_t *cmds) {
    if ( cmds->commandId == RC_NOP && !cmds->next ) {
        return;
    }

    // needed for editor rendering
    RB_SetDefaultGLState();

    bool isv3d = false, fboOff = false; // needs to be declared outside of switch case

    while ( cmds ) {
        switch ( cmds->commandId ) {
            case RC_NOP:
                break;
            case RC_DRAW_VIEW: {
                const viewDef_t *viewDef = ( ( const drawSurfsCommand_t * )cmds )->viewDef;
                isv3d = ( viewDef->viewEntitys != nullptr );	// view is 2d or 3d
                if ( !viewDef->IsLightGem() ) {					// duzenko #4425: create/switch to framebuffer object
                    if ( !fboOff ) {									// don't switch to FBO if bloom or some 2d has happened
                        if ( isv3d ) {
                            FB_TogglePrimary( true );
                        } else {
                            FB_TogglePrimary( false );					// duzenko: render 2d in default framebuffer, as well as all 3d until frame end
                            fboOff = true;
                        }
                    }
                }
                DrawView(viewDef);
                GL_CheckErrors();
                break;
            }
            case RC_SET_BUFFER:
                // TODO: probably irrelevant in new render flow with FBOs
                //RB_SetBuffer( cmds );
                break;
            case RC_BLOOM:
                RB_Bloom();
                fboOff = true;
                break;
            case RC_COPY_RENDER:
                void RB_CopyRender( const void *data );
                RB_CopyRender( cmds );
                break;
            case RC_SWAP_BUFFERS:
                // duzenko #4425: display the fbo content
                FB_TogglePrimary( false );
                const void RB_SwapBuffers( const void *data );
                RB_SwapBuffers( cmds );
                break;
            default:
                common->Error( "RB_ExecuteBackEndCommands: bad commandId" );
                break;
        }
        cmds = ( const emptyCommand_t * )cmds->next;
    }

    // go back to the default texture so the editor doesn't mess up a bound image
    qglBindTexture( GL_TEXTURE_2D, 0 );
    GL_CheckErrors();
    backEnd.glState.tmu[0].current2DMap = -1;
}

void GL4Backend::DrawView(const viewDef_t *viewDef) {
    // TODO: needed for compatibility with existing code
    backEnd.viewDef = viewDef;

    // we will need to do a new copyTexSubImage of the screen when a SS_POST_PROCESS material is used
    backEnd.currentRenderCopied = false;
    backEnd.afterFogRendered = false;

    // if there aren't any drawsurfs, do nothing
    if ( !viewDef->numDrawSurfs ) {
        //return;
    }

    // skip render bypasses everything that has models, assuming
    // them to be 3D views, but leaves 2D rendering visible
    else if ( viewDef->viewEntitys && r_skipRender.GetBool() ) {
        return;
    }

    backEnd.pc.c_surfaces += viewDef->numDrawSurfs;

    // TODO: Do we want this?
    //RB_ShowOverdraw();

    // render the scene
    GL_PROFILE( "DrawView" );

    drawSurf_t	 **drawSurfs;
    int			numDrawSurfs, processed;

    backEnd.depthFunc = GLS_DEPTHFUNC_EQUAL;

    drawSurfs = ( drawSurf_t ** )&viewDef->drawSurfs[0];
    numDrawSurfs = viewDef->numDrawSurfs;

    // clear the z buffer, set the projection matrix, etc
    RB_BeginDrawingView();
    GL_CheckErrors();

    backEnd.lightScale = r_lightScale.GetFloat();
    if ( r_fboSRGB && !backEnd.viewDef->IsLightGem() )
        backEnd.lightScale /= 2;
    backEnd.overBright = 1.0f;

    if ( backEnd.viewDef->viewEntitys ) {
        // fill the depth buffer and clear color buffer to black except on subviews
        void RB_STD_FillDepthBuffer( drawSurf_t **drawSurfs, int numDrawSurfs );
        RB_STD_FillDepthBuffer( drawSurfs, numDrawSurfs );
        RB_GLSL_DrawInteractions();
    }

    // now draw any non-light dependent shading passes
    int RB_STD_DrawShaderPasses( drawSurf_t **drawSurfs, int numDrawSurfs );
    processed = RB_STD_DrawShaderPasses( drawSurfs, numDrawSurfs );

    // fog and blend lights
    void RB_STD_FogAllLights( bool translucent );
    RB_STD_FogAllLights( false );

    // refresh fog and blend status
    backEnd.afterFogRendered = true;

    // now draw any post-processing effects using _currentRender
    if ( processed < numDrawSurfs ) {
        RB_STD_DrawShaderPasses( drawSurfs + processed, numDrawSurfs - processed );
    }

    RB_STD_FogAllLights( true ); // 2.08: second fog pass, translucent only

    RB_RenderDebugTools( drawSurfs, numDrawSurfs );
}
