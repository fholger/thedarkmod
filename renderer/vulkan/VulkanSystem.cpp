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
#pragma hdrstop

#include "renderer/tr_local.h"
#include "VulkanSystem.h"
#include "VulkanDevice.h"

VULKAN_HPP_DEFAULT_DISPATCH_LOADER_DYNAMIC_STORAGE

idCVar vk_enable("vk_enable", "1", CVAR_BOOL|CVAR_ARCHIVE|CVAR_RENDERER, "Enable the Vulkan rendering system");
idCVar vk_validation("vk_validation", "1", CVAR_BOOL|CVAR_ARCHIVE|CVAR_RENDERER, "Enable Vulkan validation layers");
extern idCVar r_customWidth;
extern idCVar r_customHeight;

VulkanSystem vulkanImpl;
VulkanSystem *vulkan = &vulkanImpl;

namespace {
    std::vector<const char*> validationLayers { "VK_LAYER_KHRONOS_validation" };

    bool checkValidationLayersSupported() {
        auto availableLayers = vk::enumerateInstanceLayerProperties();
        for (std::string neededLayer : validationLayers) {
            bool supported = false;
            for (const auto& layer : availableLayers) {
                if (neededLayer == layer.layerName) {
                    supported = true;
                    break;
                }
            }
            if (!supported) {
                common->Printf("Layer %s is not suported\n", neededLayer.c_str());
                return false;
            }
        }
        return true;
    }

    std::vector<const char*> getRequiredExtensions() {
        auto platformExtensions = qvk_RequiredInstanceExtensions();
        std::vector<const char*> extensions (platformExtensions.begin(), platformExtensions.end());
        if (vk_validation.GetBool()) {
            extensions.push_back(VK_EXT_DEBUG_UTILS_EXTENSION_NAME);
        }
        return extensions;
    }

    VKAPI_ATTR VkBool32 VKAPI_CALL debugCallback(
            VkDebugUtilsMessageSeverityFlagBitsEXT messageSeverity,
            VkDebugUtilsMessageTypeFlagsEXT messageType,
            const VkDebugUtilsMessengerCallbackDataEXT *pCallbackData,
            void *pUserData) {
        common->Printf(S_COLOR_YELLOW "Vulkan: %s\n", pCallbackData->pMessage);
        return VK_FALSE;
    }
}

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
        if (vk_validation.GetBool()) {
            SetupDebugMessenger();
        }
        device.reset(VulkanDevice::GetSuitableDevice(instance));
        common->Printf("Using device %s for rendering\n", device->Name().c_str());
    } catch (vk::Error& e) {
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

void VulkanSystem::Destroy() {
    if (debugMessenger) {
        instance.destroy(debugMessenger);
    }
    instance.destroy();
}

void VulkanSystem::CreateInstance() {
    common->Printf("Creating Vulkan instance\n");

    vk::DynamicLoader dl;
    VULKAN_HPP_DEFAULT_DISPATCHER.init(dl.getProcAddress<PFN_vkGetInstanceProcAddr>("vkGetInstanceProcAddr"));

    auto availableLayers = vk::enumerateInstanceLayerProperties();
    common->Printf("Available vk instance layers: ");
    for (auto layer : availableLayers) {
        common->Printf("%s ", layer.layerName);
    }
    common->Printf("\n");

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

    std::vector<const char*> layers;
    if (vk_validation.GetBool()) {
        if (checkValidationLayersSupported()) {
            common->Printf("Enabling Vulkan validation layers\n");
            layers.insert(layers.end(), validationLayers.begin(), validationLayers.end());
        } else {
            common->Warning("Vulkan validation requested, but validation layers are not supported");
            vk_validation.SetBool(false);
        }
    }

    std::vector<const char*> extensions = getRequiredExtensions();
    vk::InstanceCreateInfo createInfo (
            vk::InstanceCreateFlags(),
            &appInfo,
            (uint32_t)layers.size(),
			layers.data(),
            (uint32_t)extensions.size(),
            extensions.data()
    );
    instance = vk::createInstance(createInfo);
    VULKAN_HPP_DEFAULT_DISPATCHER.init(instance);
}

void VulkanSystem::SetupDebugMessenger() {
    common->Printf("Setting up Vulkan debug messenger\n");
    vk::DebugUtilsMessengerCreateInfoEXT createInfo (
            vk::DebugUtilsMessengerCreateFlagsEXT(),
            vk::DebugUtilsMessageSeverityFlagBitsEXT::eWarning | vk::DebugUtilsMessageSeverityFlagBitsEXT::eError,
            vk::DebugUtilsMessageTypeFlagBitsEXT::eGeneral | vk::DebugUtilsMessageTypeFlagBitsEXT::ePerformance | vk::DebugUtilsMessageTypeFlagBitsEXT::eValidation,
            debugCallback,
            nullptr
    );
    instance.createDebugUtilsMessengerEXT(createInfo);
}
