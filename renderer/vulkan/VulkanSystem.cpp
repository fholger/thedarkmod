#include "precompiled.h"
#include "VulkanSystem.h"
#include <vulkan/vk_enum_string_helper.h>

#ifdef WIN32
#define VK_USE_PLATFORM_WIN32_KHR
#endif
#define VOLK_IMPLEMENTATION
#include <volk.h>

idCVar vulkan_enable_validation_layers("vulkan_enable_validation_layers", "0", CVAR_BOOL, "Enable Vulkan validation layers for debugging. Must be set on start.");
idCVar vulkan_physical_device_name_filter("vulkan_physical_device_name_filter", "", 0, "If set, only consider GPUs whose device name (partially) matches the filter. Must be set on start.");


static VulkanSystem vulkanImpl;
VulkanSystem* vulkan = &vulkanImpl;


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
	common->Printf("Initializing Vulkan system...\n");
	EnsureSuccess("initializing Vulkan loader", volkInitialize());
	CreateInstance();
	CreateDebugMessenger();
	PickPhysicalDevice();
	CreateDevice();
}

void VulkanSystem::Shutdown()
{
	if (device != nullptr)
	{
		vkDestroyDevice(device, nullptr);
		device = nullptr;
	}
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

	idList<const char*> instanceExtensions
	{
		// needed for OpenGL interop
		VK_KHR_EXTERNAL_MEMORY_CAPABILITIES_EXTENSION_NAME,
		VK_KHR_EXTERNAL_SEMAPHORE_CAPABILITIES_EXTENSION_NAME,
	};
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

void VulkanSystem::PickPhysicalDevice()
{
	uint32_t deviceCount = 0;
	vkEnumeratePhysicalDevices(instance, &deviceCount, nullptr);
	if (deviceCount == 0)
	{
		common->FatalError("Could not find any graphics cards with Vulkan support");
	}

	idList<VkPhysicalDevice> devices;
	devices.SetNum(deviceCount);
	vkEnumeratePhysicalDevices(instance, &deviceCount, devices.Ptr());

	int bestScore = -1;
	for (const auto &device : devices)
	{
		int score = ScorePhysicalDevice( device );
		if (score > bestScore)
		{
			bestScore = score;
			physicalDevice = device;
		}
	}

	if (bestScore < 0 || physicalDevice == VK_NULL_HANDLE)
	{
		common->FatalError( "Could not find a suitable graphics card for rendering" );
	}

	VkPhysicalDeviceProperties properties;
	vkGetPhysicalDeviceProperties(physicalDevice, &properties);
	common->Printf("(Vulkan) GPU picked for rendering: %s\n", properties.deviceName);
}

int VulkanSystem::ScorePhysicalDevice( VkPhysicalDevice device )
{
	VkPhysicalDeviceProperties properties;
	VkPhysicalDeviceFeatures features;
	vkGetPhysicalDeviceProperties(device, &properties);
	vkGetPhysicalDeviceFeatures(device, &features);
	common->Printf("(Vulkan) Found GPU: %s\n", properties.deviceName);

	if (properties.apiVersion < VK_VERSION_1_3)
	{
		common->Printf("  X does not support Vulkan 1.3\n");
		return -1;
	}
	if (!FindQueueFamily(device, VK_QUEUE_GRAPHICS_BIT))
	{
		common->Printf("  X no suitable graphics queue family found\n");
		return -1;
	}

	int score = 0;
	if (properties.deviceType == VK_PHYSICAL_DEVICE_TYPE_DISCRETE_GPU)
	{
		common->Printf("  is a discrete GPU\n");
		score += 1000;
	}
	if (strcmp(vulkan_physical_device_name_filter.GetString(), "") != 0)
	{
		if (strstr(properties.deviceName, vulkan_physical_device_name_filter.GetString()))
		{
			common->Printf("  matches provided device name filter\n");
			score += 1000000;
		}
	}

	return score;
}

bool VulkanSystem::FindQueueFamily(VkPhysicalDevice device, VkQueueFlags requiredFlags, uint32_t *indexOut)
{
	uint32_t queueFamilyCount = 0;
	vkGetPhysicalDeviceQueueFamilyProperties(device, &queueFamilyCount, nullptr);
	idList<VkQueueFamilyProperties> queueFamilies;
	queueFamilies.SetNum(queueFamilyCount);
	vkGetPhysicalDeviceQueueFamilyProperties(device, &queueFamilyCount, queueFamilies.Ptr());

	for (uint32_t i = 0; i < queueFamilies.Num(); ++i)
	{
		if (queueFamilies[i].queueFlags & requiredFlags)
		{
			if (indexOut != nullptr)
			{
				*indexOut = i;
			}
			return true;
		}
	}

	return false;
}

void VulkanSystem::CreateDevice()
{
	VkPhysicalDeviceFeatures features {};

	VkDeviceQueueCreateInfo queueCreateInfo {};
	queueCreateInfo.sType = VK_STRUCTURE_TYPE_DEVICE_QUEUE_CREATE_INFO;
	FindQueueFamily(physicalDevice, VK_QUEUE_GRAPHICS_BIT, &queueCreateInfo.queueFamilyIndex);
	queueCreateInfo.queueCount = 1;

	VkDeviceCreateInfo createInfo {};
	createInfo.sType = VK_STRUCTURE_TYPE_DEVICE_CREATE_INFO;
	createInfo.pEnabledFeatures = &features;
	createInfo.queueCreateInfoCount = 1;
	createInfo.pQueueCreateInfos = &queueCreateInfo;

	idList<const char*> extensions
	{
		// required for OpenGL interop
		VK_KHR_EXTERNAL_MEMORY_EXTENSION_NAME,
		VK_KHR_EXTERNAL_MEMORY_WIN32_EXTENSION_NAME,
		VK_KHR_EXTERNAL_SEMAPHORE_EXTENSION_NAME,
		VK_KHR_EXTERNAL_SEMAPHORE_WIN32_EXTENSION_NAME,
	};
	createInfo.enabledExtensionCount = extensions.Num();
	createInfo.ppEnabledExtensionNames = extensions.Ptr();

	EnsureSuccess("creating device", vkCreateDevice(physicalDevice, &createInfo, nullptr, &device));
	volkLoadDevice(device);

	uint32_t graphicsQueueIndex;
	FindQueueFamily(physicalDevice, VK_QUEUE_GRAPHICS_BIT, &graphicsQueueIndex);
	vkGetDeviceQueue(device, graphicsQueueIndex, 0, &graphicsQueue);
}
