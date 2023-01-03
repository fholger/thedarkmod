#pragma once
#include "qvulkan.h"

class DeviceLocalBuffer;

class StagingBuffer
{
public:
	~StagingBuffer() { Destroy(); }

	void Init(uint32_t size);
	void Destroy();

	void CopyBuffer(VkCommandBuffer cmd, DeviceLocalBuffer &target, uint32_t size, uint32_t srcOffset = 0, uint32_t dstOffset = 0);

	byte *MappedData() const { return (byte*)mappedData; }

private:
	VkBuffer buffer = nullptr;
	VmaAllocation allocation = nullptr;
	void *mappedData = nullptr;
};