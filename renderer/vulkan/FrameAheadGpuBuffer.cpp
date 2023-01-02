#include "precompiled.h"
#include "FrameAheadGpuBuffer.h"
#include "VulkanSystem.h"

const int FrameAheadGpuBuffer::NUM_FRAMES;


void FrameAheadGpuBuffer::Init(VkBufferUsageFlags usage, uint32_t size, uint32_t alignment)
{
	gpuBuffer.Destroy();
	this->usage = usage;
	this->alignment = alignment;
	frameSize = ALIGN( size, alignment );
	bufferSize = NUM_FRAMES * frameSize;

	gpuBuffer.Init(usage, size);
	CreateStagingBuffer();
	CreateTransferCommandBuffers();
	CreateSemaphores();

	currentFrame = 0;
}

void FrameAheadGpuBuffer::Destroy()
{
	if (glBufferReadySignal[0])
	{
		qglDeleteSemaphoresEXT(NUM_FRAMES, glBufferReadySignal);
		glBufferReadySignal[0] = 0;
	}
	if (bufferReadySignal[0])
	{
		for (int i = 0; i < NUM_FRAMES; ++i)
		{
			vkDestroySemaphore(vulkan->device, bufferReadySignal[i], nullptr);
			bufferReadySignal[i] = nullptr;
		}
	}
	if (transferCmds[0])
	{
		vkFreeCommandBuffers(vulkan->device, vulkan->commandPool, NUM_FRAMES, transferCmds);
		transferCmds[0] = nullptr;
	}
	gpuBuffer.Destroy();
	if (stagingBuffer)
	{
		vmaDestroyBuffer(vulkan->allocator, stagingBuffer, stagingAllocation);
		stagingBuffer = nullptr;
		stagingAllocation = nullptr;
	}
}

void FrameAheadGpuBuffer::CommitFrame(uint32_t count)
{
	VkBufferCopy region;
	region.size = count;
	region.srcOffset = currentFrame * frameSize;
	region.dstOffset = region.srcOffset;

	vmaFlushAllocation(vulkan->allocator, stagingAllocation, region.srcOffset, region.size);

	VkCommandBufferBeginInfo beginInfo {};
	beginInfo.sType = VK_STRUCTURE_TYPE_COMMAND_BUFFER_BEGIN_INFO;
	beginInfo.flags = VK_COMMAND_BUFFER_USAGE_ONE_TIME_SUBMIT_BIT;
	VkCommandBuffer transferCmd = transferCmds[currentFrame];
	VulkanSystem::EnsureSuccess("creating transfer command", vkBeginCommandBuffer(transferCmd, &beginInfo));
	vkCmdCopyBuffer(transferCmd, stagingBuffer, gpuBuffer.buffer, 1, &region);
	vkEndCommandBuffer(transferCmd);

	VkSubmitInfo submitInfo {};
	submitInfo.sType = VK_STRUCTURE_TYPE_SUBMIT_INFO;
	submitInfo.commandBufferCount = 1;
	submitInfo.pCommandBuffers = &transferCmd;
	submitInfo.signalSemaphoreCount = 1;
	submitInfo.pSignalSemaphores = &bufferReadySignal[currentFrame];
	VulkanSystem::EnsureSuccess("submitting buffer transfer",
		vkQueueSubmit(vulkan->graphicsQueue, 1, &submitInfo, nullptr));

	// OpenGL interop - await transfer complete
	qglWaitSemaphoreEXT(glBufferReadySignal[currentFrame], 1, &gpuBuffer.glBuffer, 0, nullptr, nullptr);

	currentFrame = (currentFrame + 1) % NUM_FRAMES;
}

byte * FrameAheadGpuBuffer::CurrentWriteLocation() const
{
	return ((byte*)mappedData) + currentFrame * frameSize;
}

const void * FrameAheadGpuBuffer::BufferOffset(const void *pointer)
{
	ptrdiff_t mapOffset = static_cast< const byte* >( pointer ) - mappedData;
	assert( (size_t)mapOffset < (size_t)bufferSize );
	return reinterpret_cast< const void* >( mapOffset );
}

void FrameAheadGpuBuffer::CreateStagingBuffer()
{
	VkExternalMemoryBufferCreateInfoKHR extMemInfo {};
	extMemInfo.sType = VK_STRUCTURE_TYPE_EXTERNAL_MEMORY_BUFFER_CREATE_INFO_KHR;
	extMemInfo.handleTypes = VK_EXTERNAL_MEMORY_HANDLE_TYPE_OPAQUE_WIN32_BIT_KHR;
	VkBufferCreateInfo createInfo {};
	createInfo.sType = VK_STRUCTURE_TYPE_BUFFER_CREATE_INFO;
	createInfo.size = bufferSize;
	createInfo.usage = VK_BUFFER_USAGE_TRANSFER_SRC_BIT;
	createInfo.sharingMode = VK_SHARING_MODE_EXCLUSIVE;
	createInfo.pNext = &extMemInfo;

	VmaAllocationCreateInfo allocCreateInfo {};
	allocCreateInfo.requiredFlags = VK_MEMORY_PROPERTY_HOST_VISIBLE_BIT;
	allocCreateInfo.flags = VMA_ALLOCATION_CREATE_MAPPED_BIT | VMA_ALLOCATION_CREATE_HOST_ACCESS_SEQUENTIAL_WRITE_BIT;
	allocCreateInfo.usage = VMA_MEMORY_USAGE_AUTO;

	VmaAllocationInfo allocInfo;
	VulkanSystem::EnsureSuccess("creating frame-ahead staging buffer",
		vmaCreateBuffer(vulkan->allocator, &createInfo, &allocCreateInfo,
			&stagingBuffer, &stagingAllocation, &allocInfo));
	mappedData = allocInfo.pMappedData;
}

extern void GL_CheckErrors();

void FrameAheadGpuBuffer::CreateTransferCommandBuffers()
{
	VkCommandBufferAllocateInfo bufAllocInfo {};
	bufAllocInfo.sType = VK_STRUCTURE_TYPE_COMMAND_BUFFER_ALLOCATE_INFO;
	bufAllocInfo.commandPool = vulkan->commandPool;
	bufAllocInfo.commandBufferCount = NUM_FRAMES;
	bufAllocInfo.level = VK_COMMAND_BUFFER_LEVEL_PRIMARY;
	VulkanSystem::EnsureSuccess("creating transfer command buffers", vkAllocateCommandBuffers(vulkan->device, &bufAllocInfo, transferCmds));
}

void FrameAheadGpuBuffer::CreateSemaphores()
{
	VkExportSemaphoreCreateInfoKHR exportInfo {};
	exportInfo.sType = VK_STRUCTURE_TYPE_EXPORT_SEMAPHORE_CREATE_INFO_KHR;
	exportInfo.handleTypes = VK_EXTERNAL_SEMAPHORE_HANDLE_TYPE_OPAQUE_WIN32_BIT_KHR;

	VkSemaphoreCreateInfo createInfo {};
	createInfo.sType = VK_STRUCTURE_TYPE_SEMAPHORE_CREATE_INFO;
	createInfo.pNext = &exportInfo;

	VkSemaphoreGetWin32HandleInfoKHR handleInfo {};
	handleInfo.sType = VK_STRUCTURE_TYPE_SEMAPHORE_GET_WIN32_HANDLE_INFO_KHR;
	handleInfo.handleType = VK_EXTERNAL_SEMAPHORE_HANDLE_TYPE_OPAQUE_WIN32_BIT_KHR;

	for (int i = 0; i < NUM_FRAMES; ++i)
	{
		VulkanSystem::EnsureSuccess("creating semaphore",
			vkCreateSemaphore(vulkan->device, &createInfo, nullptr, &bufferReadySignal[i]));

		// OpenGL interop
		HANDLE handle;
		handleInfo.semaphore = bufferReadySignal[i];
		VulkanSystem::EnsureSuccess("getting semaphore handle", 
			vkGetSemaphoreWin32HandleKHR(vulkan->device, &handleInfo, &handle));

		qglGenSemaphoresEXT(1, &glBufferReadySignal[i]);
		qglImportSemaphoreWin32HandleEXT(glBufferReadySignal[i], GL_HANDLE_TYPE_OPAQUE_WIN32_EXT, handle);
		GL_CheckErrors();
	}
}
