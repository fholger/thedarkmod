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

#include <renderer/tr_local.h>
#include "precompiled.h"
#pragma hdrstop

#include "VulkanSystem.h"

VULKAN_HPP_DEFAULT_DISPATCH_LOADER_DYNAMIC_STORAGE

idCVar vk_enable("vk_enable", "1", CVAR_BOOL|CVAR_ARCHIVE|CVAR_RENDERER, "Enable the Vulkan rendering system");
extern idCVar r_customWidth;
extern idCVar r_customHeight;

VulkanSystem vulkanImpl;
VulkanSystem *vulkan = &vulkanImpl;

void VulkanSystem::Initialize() {
    common->Printf( "----- Initializing Vulkan -----\n" );

    int windowWidth = 0, windowHeight = 0;
    if ( r_customWidth.GetInteger() <= 0 || r_customHeight.GetInteger() <= 0 ) {
        bool ok = Sys_GetCurrentMonitorResolution( windowWidth, windowHeight );
        if (!ok) {
            windowWidth = 800;
            windowHeight = 600;
        }
        r_customWidth.SetInteger( windowWidth );
        r_customHeight.SetInteger( windowHeight );
    } else {
        windowWidth = r_customWidth.GetInteger();
        windowHeight = r_customHeight.GetInteger();
    }

    common->Printf("Using resolution %dx%d\n", windowWidth, windowHeight);

    if (!qvk_InitRenderWindow(false, windowWidth, windowHeight)) {
        common->FatalError("Failed to create render window");
    }

    try {
        CreateInstance();
    } catch (vk::Error& e) {
        common->Printf("Initializing Vulkan failed: %s\n", e.what());
        common->Warning("Initializing Vulkan failed: %s", e.what());
        Sys_Sleep(500);
        common->FatalError("Initializing Vulkan failed: %s", e.what());
    }

    common->Printf("Vulkan initialized.\n");
    common->FatalError("Vulkan not implemented yet");

    //parms.width = glConfig.vidWidth;
    //parms.height = glConfig.vidHeight;
    //parms.fullScreen = r_fullscreen.GetBool();
    //parms.displayHz = r_displayRefresh.GetInteger();
    //parms.stereo = false;

    //if ( GLimp_Init( parms ) ) {
    //    // it worked
    //    break;
    //}
}

void VulkanSystem::CreateInstance() {
    common->Printf("Creating Vulkan instance\n");

    vk::DynamicLoader dl;
    VULKAN_HPP_DEFAULT_DISPATCHER.init(dl.getProcAddress<PFN_vkGetInstanceProcAddr>("vkGetInstanceProcAddr"));

    auto availableExtensions = vk::enumerateInstanceExtensionProperties();
    common->Printf("Avaiable vk instance extensions: ");
    for (auto extension : availableExtensions) {
        common->Printf("%s ", extension.extensionName);
    }
    common->Printf("\n");

    vk::ApplicationInfo appInfo (
            "TheDarkMod",
            VK_MAKE_VERSION(TDM_VERSION_MAJOR,TDM_VERSION_MINOR,0),
            "TheDarkMod",
            VK_MAKE_VERSION(TDM_VERSION_MAJOR,TDM_VERSION_MINOR,0),
            VK_API_VERSION_1_1
    );

    idList<const char*> extensions = qvk_RequiredInstanceExtensions();
    vk::InstanceCreateInfo createInfo (
            vk::InstanceCreateFlags(),
            &appInfo,
            0,
			nullptr,
			extensions.Num(),
            extensions.Ptr()
    );
    vkInstance = vk::createInstance(createInfo);
    VULKAN_HPP_DEFAULT_DISPATCHER.init(vkInstance);
}
