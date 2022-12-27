#pragma once
#include <volk.h>

class VulkanSystem
{
public:
	void Init();
	void Shutdown();

	static void EnsureSuccess(const char* description, VkResult result);

private:
	VkInstance instance = VK_NULL_HANDLE;
	VkDebugUtilsMessengerEXT debugMessenger = VK_NULL_HANDLE;
	VkPhysicalDevice physicalDevice = VK_NULL_HANDLE;

	void CreateInstance();
	void CreateDebugMessenger();
	void PopulateDebugMessengerCreateInfo(VkDebugUtilsMessengerCreateInfoEXT& createInfo);
	void PickPhysicalDevice();
	int ScorePhysicalDevice(VkPhysicalDevice device);
};

extern VulkanSystem* vulkan;