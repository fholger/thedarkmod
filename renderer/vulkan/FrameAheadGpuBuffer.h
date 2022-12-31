#pragma once

#include "qvulkan.h"

class FrameAheadGpuBuffer
{
public:
	void Init( VkBufferUsageFlags usage, uint32_t size, uint32_t alignment );
	void Destroy();

	static const int NUM_FRAMES = 3;

private:
	VkBufferUsageFlags usage = 0;
	uint32_t bufferSize = 0;
	uint32_t stagingSize = 0;
	uint32_t alignment = 0;
	VkBuffer stagingBuffer = nullptr;
	VmaAllocation stagingAllocation = nullptr;
	VkBuffer gpuBuffer = nullptr;
	VmaAllocation gpuAllocation = nullptr;
	// OpenGL interop
	HANDLE handle = nullptr;
	GLuint glMemoryObject = 0;
	GLuint glBuffer = 0;

	void CreateStagingBuffer();
	void CreateGpuBuffer();
};
