#pragma once
#include <volk.h>

class VulkanSystem
{
public:
	void Init();
	void Shutdown();

	static void EnsureSuccess(const char* description, VkResult result);

private:
	VkInstance instance = nullptr;
	VkDebugUtilsMessengerEXT debugMessenger = nullptr;

	void CreateInstance();
	void CreateDebugMessenger();
	void PopulateDebugMessengerCreateInfo(VkDebugUtilsMessengerCreateInfoEXT& createInfo);
};