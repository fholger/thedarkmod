#include "precompiled.h"
#include "VulkanSystem.h"
#include <vulkan/vk_enum_string_helper.h>

#ifdef WIN32
#define VK_USE_PLATFORM_WIN32_KHR
#endif
#define VOLK_IMPLEMENTATION
#include <volk.h>

idCVar vulkan_enable_validation_layers("vulkan_enable_validation_layers", "0", CVAR_BOOL, "Enable Vulkan validation layers for debugging. Must be set on start.");


static VKAPI_ATTR VkBool32 VKAPI_CALL VulkanDebugCallback(VkDebugUtilsMessageSeverityFlagBitsEXT severity, VkDebugUtilsMessageTypeFlagsEXT type,
	const VkDebugUtilsMessengerCallbackDataEXT *pCallbackData, void *)
{
	if (severity >= VK_DEBUG_UTILS_MESSAGE_SEVERITY_WARNING_BIT_EXT)
	{
		common->Warning("(Vulkan) %s\n", pCallbackData->pMessage);
	}

	return VK_FALSE;
}


void VulkanSystem::Init()
{
	EnsureSuccess("initializing Vulkan loader", volkInitialize());
	CreateInstance();
	CreateDebugMessenger();
}

void VulkanSystem::Shutdown()
{
	if (debugMessenger != nullptr)
	{
		vkDestroyDebugUtilsMessengerEXT(instance, debugMessenger, nullptr);
		debugMessenger = nullptr;
	}
	vkDestroyInstance(instance, nullptr);
	instance = nullptr;
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

	idList<const char*> instanceExtensions;
	if (vulkan_enable_validation_layers.GetBool())
	{
		instanceExtensions.AddGrow(VK_EXT_DEBUG_UTILS_EXTENSION_NAME);
	}
	createInfo.enabledExtensionCount = instanceExtensions.Num();
	createInfo.ppEnabledExtensionNames = instanceExtensions.Ptr();

	idList<const char*> instanceLayers;
	if (vulkan_enable_validation_layers.GetBool())
	{
		instanceLayers.AddGrow("VK_LAYER_KHRONOS_validation");
	}
	createInfo.enabledLayerCount = instanceLayers.Num();
	createInfo.ppEnabledLayerNames = instanceLayers.Ptr();

	VkDebugUtilsMessengerCreateInfoEXT debugMessengerCreateInfo {};
	if (vulkan_enable_validation_layers.GetBool())
	{
		PopulateDebugMessengerCreateInfo(debugMessengerCreateInfo);
		createInfo.pNext = &debugMessengerCreateInfo;
	}

	EnsureSuccess("creating instance", vkCreateInstance(&createInfo, nullptr, &instance));
	volkLoadInstanceOnly(instance);
}

void VulkanSystem::CreateDebugMessenger()
{
	if (!vulkan_enable_validation_layers.GetBool())
	{
		return;
	}

	VkDebugUtilsMessengerCreateInfoEXT createInfo {};
	PopulateDebugMessengerCreateInfo(createInfo);

	EnsureSuccess("creating debug messenger", vkCreateDebugUtilsMessengerEXT(instance, &createInfo, nullptr, &debugMessenger));
}

void VulkanSystem::PopulateDebugMessengerCreateInfo(VkDebugUtilsMessengerCreateInfoEXT& createInfo)
{
	createInfo.sType = VK_STRUCTURE_TYPE_DEBUG_UTILS_MESSENGER_CREATE_INFO_EXT;
	createInfo.messageSeverity = VK_DEBUG_UTILS_MESSAGE_SEVERITY_WARNING_BIT_EXT | VK_DEBUG_UTILS_MESSAGE_SEVERITY_ERROR_BIT_EXT;
	createInfo.messageType = VK_DEBUG_UTILS_MESSAGE_TYPE_GENERAL_BIT_EXT | VK_DEBUG_UTILS_MESSAGE_TYPE_PERFORMANCE_BIT_EXT | VK_DEBUG_UTILS_MESSAGE_TYPE_VALIDATION_BIT_EXT;
	createInfo.pfnUserCallback = VulkanDebugCallback;
	createInfo.pUserData = nullptr;
}
