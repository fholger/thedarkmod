#pragma once
#include "qvulkan.h"

class VulkanSystem
{
public:
	void Init();
	void Shutdown();

	static void EnsureSuccess(const char* description, VkResult result);

	VkInstance instance = VK_NULL_HANDLE;
	VkDebugUtilsMessengerEXT debugMessenger = VK_NULL_HANDLE;
	VkPhysicalDevice physicalDevice = VK_NULL_HANDLE;
	VkDevice device = VK_NULL_HANDLE;
	VkQueue graphicsQueue = VK_NULL_HANDLE;
	VmaAllocator allocator = VK_NULL_HANDLE;
	VkCommandPool commandPool = VK_NULL_HANDLE;
	uint32_t graphicsQueueFamily = 0;

private:
	void CreateInstance();
	void CreateDebugMessenger();
	void PopulateDebugMessengerCreateInfo(VkDebugUtilsMessengerCreateInfoEXT& createInfo);
	void PickPhysicalDevice();
	int ScorePhysicalDevice(VkPhysicalDevice device);
	bool FindQueueFamily(VkPhysicalDevice device, VkQueueFlags requiredFlags, uint32_t *indexOut = nullptr);
	void CreateDevice();
	void CreateMemoryAllocator();
	void CreateCommandPools();
};

extern VulkanSystem* vulkan;