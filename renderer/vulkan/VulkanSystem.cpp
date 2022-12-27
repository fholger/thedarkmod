#include "precompiled.h"
#include "VulkanSystem.h"
#include <vulkan/vk_enum_string_helper.h>

#ifdef WIN32
#define VK_USE_PLATFORM_WIN32_KHR
#endif
#define VOLK_IMPLEMENTATION
#include <volk.h>


void VulkanSystem::Init()
{
	EnsureSuccess("initializing Vulkan loader", volkInitialize());
}

void VulkanSystem::EnsureSuccess(const char* description, VkResult result)
{
	if (result != VK_SUCCESS)
	{
		common->FatalError("Encountered Vulkan error while %s: %s", description, string_VkResult(result));
	}
}

void VulkanSystem::CreateInstance()
{
	VkApplicationInfo appInfo {};
	appInfo.sType = VK_STRUCTURE_TYPE_APPLICATION_INFO;
	appInfo.pApplicationName = "The Dark Mod";
	// TODO: set proper version from existing defines
	appInfo.applicationVersion = VK_MAKE_VERSION(2, 11, 0);
	appInfo.pEngineName = "The Dark Mod";
	appInfo.engineVersion = VK_MAKE_VERSION(2, 11, 0);
	appInfo.apiVersion = VK_API_VERSION_1_3;

	VkInstanceCreateInfo createInfo{};
	createInfo.sType = VK_STRUCTURE_TYPE_INSTANCE_CREATE_INFO;
	createInfo.pApplicationInfo = &appInfo;

	createInfo.enabledExtensionCount = 0;

	createInfo.enabledLayerCount = 0;

	EnsureSuccess("creating instance", vkCreateInstance(&createInfo, nullptr, &instance));
}
