#pragma once
#include <volk.h>

class VulkanSystem
{
public:
	void Init();

	static void EnsureSuccess(const char* description, VkResult result);

private:
	VkInstance instance;

	void CreateInstance();
};