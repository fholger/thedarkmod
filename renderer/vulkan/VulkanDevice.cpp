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
#include "VulkanDevice.h"

namespace {
    QueueFamilyIndices FindQueueFamilies(vk::PhysicalDevice device) {
        QueueFamilyIndices indices;
        auto queueFamilyProperties = device.getQueueFamilyProperties();
        for (int i = 0; i < queueFamilyProperties.size(); ++i) {
            const auto &queueFamily = queueFamilyProperties[i];
            if (queueFamily.queueCount > 0 && queueFamily.queueFlags & vk::QueueFlagBits::eGraphics) {
                indices.graphics = i;
                indices.present |= vk::QueueFlagBits::eGraphics;
            }
            if (indices.AllPresent()) {
                break;
            }
        }
        return indices;
    }

    int ScoreDeviceSuitability(vk::PhysicalDevice device) {
        auto properties = device.getProperties();
        auto features = device.getFeatures();
        auto queues = FindQueueFamilies(device);

        if (!queues.AllPresent()) {
            return 0;
        }

        int score = 0;

        if (properties.deviceType == vk::PhysicalDeviceType::eDiscreteGpu) {
            score += 1000;
        }
        else if (properties.deviceType == vk::PhysicalDeviceType::eIntegratedGpu) {
            score += 100;
        }

        return score;
    }
}

VulkanDevice::VulkanDevice(vk::PhysicalDevice device) : physicalDevice(device) {
    queueFamilies = FindQueueFamilies(device);
}

VulkanDevice::~VulkanDevice() {
}

VulkanDevice *VulkanDevice::GetSuitableDevice(vk::Instance instance) {
    auto physicalDevices = instance.enumeratePhysicalDevices();
    std::map<int, vk::PhysicalDevice> suitableDevices;
    for (auto device : physicalDevices) {
        int score = ScoreDeviceSuitability(device);
        if (score > 0) {
            suitableDevices.insert(std::make_pair(score, device));
        }
    }
    if (suitableDevices.empty()) {
        throw vk::SystemError(std::error_code(), "Vulkan: no suitable graphics devices found");
    }
    
    for (auto suitableEntry : suitableDevices) {
        vk::PhysicalDevice device = suitableEntry.second;
        auto properties = device.getProperties();
        common->Printf("Found suitable device: [%d] %s\n", properties.deviceID, properties.deviceName);
    }

    // TODO: make device explicitly selectable via cvar
    return new VulkanDevice(suitableDevices.rbegin()->second);
}

idStr VulkanDevice::Name() const {
    return physicalDevice.getProperties().deviceName;
}

void VulkanDevice::CreateLogicalDevice() {
    float queuePriority = 1.0f;
    vk::DeviceQueueCreateInfo queueCreateInfo (
            vk::DeviceQueueCreateFlags(),
            queueFamilies.graphics,
            1,
            &queuePriority
    );
    vk::DeviceCreateInfo createInfo (
            vk::DeviceCreateFlags(),
            1,
            &queueCreateInfo,
            0,
            nullptr,
            0,
            nullptr,
            nullptr
    );

    logicalDevice = physicalDevice.createDeviceUnique(createInfo);
    graphicsQueue = logicalDevice->getQueue(queueFamilies.graphics, 0);
}
