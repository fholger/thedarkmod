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
#include "win_local.h"
#include "renderer/tr_local.h"
#include "Common.h"
#include "Str.h"
#include "rc/doom_resource.h"
#include "renderer/vulkan/vulkan.h"

static void qvk_WinCreateWindowClasses() {
    WNDCLASS wc;

    // register the window class if necessary
    if ( win32.windowClassRegistered ) {
        return;
    }
    memset( &wc, 0, sizeof( wc ) );

    wc.style         = 0;
    wc.lpfnWndProc   = ( WNDPROC ) MainWndProc;
    wc.cbClsExtra    = 0;
    wc.cbWndExtra    = 0;
    wc.hInstance     = win32.hInstance;
    wc.hIcon         = LoadIcon( win32.hInstance, MAKEINTRESOURCE( IDI_ICON1 ) );
    wc.hCursor       = LoadCursor( NULL, IDC_ARROW );
    wc.hbrBackground = ( struct HBRUSH__ * )COLOR_GRAYTEXT;
    wc.lpszMenuName  = 0;
    wc.lpszClassName = WIN32_WINDOW_CLASS_NAME;

    if ( !RegisterClass( &wc ) ) {
        common->FatalError( "GLW_CreateWindow: could not register window class" );
    }
    common->Printf( "...registered window class\n" );
    win32.windowClassRegistered = true;
}

bool qvk_WinCreateWindow(bool fullscreen, int width, int height) {
    int				stylebits;
    int				x, y, w, h;
    int				exstyle;

    // compute width and height
    if ( fullscreen ) {
        if ( r_fullscreen.GetInteger() == 1 )
        {
            exstyle = WS_EX_TOPMOST;
            stylebits = WS_POPUP | WS_VISIBLE | WS_SYSMENU;
        }
        else if ( r_fullscreen.GetInteger() == 2 )
        {
            exstyle = 0;
            stylebits = WS_POPUP | WS_VISIBLE | WS_SYSMENU;
        }
        x = 0;
        y = 0;
        w = width;
        h = height;
    } else {
        RECT	r;

        // adjust width and height for window border
        r.bottom = height;
        r.left = 0;
        r.top = 0;
        r.right = width;

        exstyle = 0;
        stylebits = WINDOW_STYLE | WS_SYSMENU | WS_MINIMIZEBOX | WS_MAXIMIZEBOX;
        if ( win32.win_maximized )
            stylebits |= WS_MAXIMIZE;
        AdjustWindowRect( &r, stylebits, FALSE );

        w = r.right - r.left;
        h = r.bottom - r.top;

        x = win32.win_xpos.GetInteger();
        y = win32.win_ypos.GetInteger();

        // adjust window coordinates if necessary
        // so that the window is completely on screen
        if ( x + w > win32.desktopWidth ) {
            x = ( win32.desktopWidth - w );
        }
        if ( y + h > win32.desktopHeight ) {
            y = ( win32.desktopHeight - h );
        }
        if ( x < 0 ) {
            x = 0;
        }
        if ( y < 0 ) {
            y = 0;
        }
    }

    idStr title = va( "%s %d.%02d/%u", GAME_NAME, TDM_VERSION_MAJOR, TDM_VERSION_MINOR, sizeof( void * ) * 8 );

    win32.hWnd = CreateWindowEx(
            exstyle,
            WIN32_WINDOW_CLASS_NAME,
            title.c_str(),
            stylebits,
            x, y, w, h,
            NULL,
            NULL,
            win32.hInstance,
            NULL );

    if ( !win32.hWnd ) {
        common->Warning( "qvk_WinCreateWindow() Couldn't create window" );
        return false;
    }

    ::SetTimer( win32.hWnd, 0, 100, NULL );

    ShowWindow( win32.hWnd, SW_SHOW );
    UpdateWindow( win32.hWnd );
    common->Printf( "...created window @ %d,%d (%dx%d)\n", x, y, w, h );

    SetForegroundWindow( win32.hWnd );
    SetFocus( win32.hWnd );

    glConfig.isFullscreen = fullscreen;

    return true;
}

bool qvk_InitRenderWindow(bool fullscreen, int width, int height) {
    HDC			hDC;

    common->Printf( "Initializing Vulkan subsystem\n" );

    // check our desktop attributes
    hDC = GetDC( GetDesktopWindow() );
    win32.desktopBitsPixel = GetDeviceCaps( hDC, BITSPIXEL );
    win32.desktopWidth = GetDeviceCaps( hDC, HORZRES );
    win32.desktopHeight = GetDeviceCaps( hDC, VERTRES );
    ReleaseDC( GetDesktopWindow(), hDC );

    // we can't run in a window unless it is 32 bpp
    if ( win32.desktopBitsPixel < 32 && !fullscreen ) {
        common->Warning( "qvk_InitRenderWindow: Windowed mode requires 32 bit desktop depth" );
        return false;
    }

    // create our window classes if we haven't already
    qvk_WinCreateWindowClasses();

    // try to change to fullscreen
    if ( fullscreen ) {
        // TODO
    }

    // try to create a window with the correct pixel format
    // and init the renderer context
    if ( !qvk_WinCreateWindow( fullscreen, width, height ) ) {
        GLimp_Shutdown();
        return false;
    }

    return true;
}

idList<const char*> qvk_RequiredInstanceExtensions() {
    idList<const char*> extensions;
    extensions.Append(VK_KHR_SURFACE_EXTENSION_NAME);
    extensions.Append(VK_KHR_WIN32_SURFACE_EXTENSION_NAME);
    return extensions;
}
