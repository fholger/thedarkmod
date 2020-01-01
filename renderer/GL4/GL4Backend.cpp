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
#include <renderer/glad.h>

const int MAX_DRAW_COMMANDS = 8192;
const int MAX_PARAM_BLOCK_SIZE = 256;
const int BUFFER_FRAMES = 3;  // number of frames our parameter buffer should be able to hold

GL4Backend backendImpl;
GL4Backend *gl4Backend = &backendImpl;

idCVar r_useGL4Backend("r_useGL4Backend", "1", CVAR_RENDERER | CVAR_BOOL | CVAR_ARCHIVE, "Use the experimental new GL4 render backend" );

struct SharedShaderParams {
    idMat4 viewMatrix;
    idMat4 projectionMatrix;
    idMat4 viewProjectionMatrix;
};

GL4Backend::GL4Backend()
: uboOffsetAlignment(0)
, ssboOffsetAlignment(0)
, drawIdBuffer(0)
, drawCommands(nullptr)
{
}

void GL4Backend::Init() {
    drawCommands = (DrawElementsIndirectCommand*) Mem_Alloc16(sizeof(DrawElementsIndirectCommand) * MAX_DRAW_COMMANDS);
    InitDrawIdBuffer();
    qglGetIntegerv(GL_UNIFORM_BUFFER_OFFSET_ALIGNMENT, &uboOffsetAlignment);
    qglGetIntegerv(GL_SHADER_STORAGE_BUFFER_OFFSET_ALIGNMENT, &ssboOffsetAlignment);
    sharedParamBuffer.Init(GL_UNIFORM_BUFFER, MAX_PARAM_BLOCK_SIZE * BUFFER_FRAMES, uboOffsetAlignment);
    // we use SSBOs for shader parameter blocks.
    // theoretically, UBOs would be faster, but their limited size and awkward alignment complicate
    // our multidraw setups, and due to caching the practical difference is probably not worth it...
    drawParamBuffer.Init(GL_SHADER_STORAGE_BUFFER, MAX_DRAW_COMMANDS * MAX_PARAM_BLOCK_SIZE * BUFFER_FRAMES, ssboOffsetAlignment);
    depthStage.Init();
}

void GL4Backend::Shutdown() {
    depthStage.Shutdown();
    drawParamBuffer.Destroy();
    qglDeleteBuffers(1, &drawIdBuffer);
    Mem_Free16(drawCommands);
}

void GL4Backend::InitDrawIdBuffer() {
    qglGenBuffers(1, &drawIdBuffer);
    std::vector<uint32_t> drawIds (MAX_DRAW_COMMANDS);
    for (uint32_t i = 0; i < MAX_DRAW_COMMANDS; ++i) {
        drawIds[i] = i;
    }
    qglNamedBufferStorage(drawIdBuffer, drawIds.size() * sizeof(uint32_t), drawIds.data(), 0);
}

void GL4Backend::BeginFrame(const viewDef_t *viewDef) {
    SharedShaderParams *sharedParams = sharedParamBuffer.AllocateAndBind<SharedShaderParams>(1, 7);
    memcpy(sharedParams->projectionMatrix.ToFloatPtr(), viewDef->projectionMatrix, sizeof(idMat4));
    memcpy(sharedParams->viewMatrix.ToFloatPtr(), viewDef->worldSpace.modelViewMatrix, sizeof(idMat4));
    sharedParams->viewProjectionMatrix = sharedParams->projectionMatrix * sharedParams->viewMatrix;
}

void GL4Backend::EndFrame() {
    sharedParamBuffer.Lock();
    drawParamBuffer.Lock();
    globalImages->MakeUnusedImagesNonResident();
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
    BeginFrame(viewDef);

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

    EndFrame();
}
