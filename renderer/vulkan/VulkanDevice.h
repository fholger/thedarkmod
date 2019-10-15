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
#include "vulkan.h"

struct QueueFamilyIndices {
    uint32_t graphics;
    vk::QueueFlags available;

    bool AllPresent() const {
        return (bool)(available & vk::QueueFlagBits::eGraphics);
    }
};

class VulkanDevice {
public:
    ~VulkanDevice();

    idStr Name() const;

    static VulkanDevice *GetSuitableDevice(vk::Instance instance, vk::SurfaceKHR presentationSurface);

    void CreateLogicalDevice();

private:
    vk::PhysicalDevice physicalDevice;
    QueueFamilyIndices queueFamilies;
    vk::UniqueDevice logicalDevice;
    vk::Queue graphicsQueue;

    explicit VulkanDevice(vk::PhysicalDevice device, QueueFamilyIndices queueFamilies);
};
