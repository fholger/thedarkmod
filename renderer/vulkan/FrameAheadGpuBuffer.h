#pragma once

#include "qvulkan.h"

class FrameAheadGpuBuffer
{
public:
	void Init( VkBufferUsageFlags usage, uint32_t size, uint32_t alignment );
	void Destroy();
	void CommitFrame(uint32_t count);

	uint32_t GetFrameSize() const { return frameSize; }
	GLuint GetGLBuffer() const { return glBuffer; }
	byte *CurrentWriteLocation() const;
	const void * BufferOffset( const void *pointer );

	static const int NUM_FRAMES = 3;

private:
	VkBufferUsageFlags usage = 0;
	uint32_t frameSize = 0;
	uint32_t bufferSize = 0;
	uint32_t alignment = 0;
	VkBuffer stagingBuffer = nullptr;
	VmaAllocation stagingAllocation = nullptr;
	void *mappedData = nullptr;
	VkBuffer gpuBuffer = nullptr;
	VmaAllocation gpuAllocation = nullptr;
	VkCommandBuffer transferCmds[NUM_FRAMES] = {nullptr};
	VkSemaphore bufferReadySignal[NUM_FRAMES] = {nullptr};
	GLuint glBufferReadySignal[NUM_FRAMES] = {0};

	uint32_t currentFrame = 0;

	// OpenGL interop
	HANDLE handle = nullptr;
	GLuint glMemoryObject = 0;
	GLuint glBuffer = 0;

	void CreateStagingBuffer();
	void CreateGpuBuffer();
	void CreateTransferCommandBuffers();
	void CreateSemaphores();
};
