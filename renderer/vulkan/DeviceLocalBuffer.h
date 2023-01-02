#pragma once

#include "qvulkan.h"

class DeviceLocalBuffer
{
public:
	~DeviceLocalBuffer() { Destroy(); }

	void Init(VkBufferUsageFlags usage, uint32_t size);
	void Destroy();

	uint32_t Size() const { return size; }

	VkBuffer buffer = nullptr;
	GLuint glBuffer = 0;

private:
	uint32_t size = 0;
	VmaAllocation allocation = nullptr;
	GLuint glMemoryObject = 0;
};
