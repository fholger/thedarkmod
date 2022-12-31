#include "precompiled.h"
#include "FrameAheadGpuBuffer.h"
#include "VulkanSystem.h"

const int FrameAheadGpuBuffer::NUM_FRAMES;


void FrameAheadGpuBuffer::Init(VkBufferUsageFlags usage, uint32_t size, uint32_t alignment)
{
	if (gpuBuffer)
	{
		Destroy();
	}
	this->usage = usage;
	this->alignment = alignment;
	bufferSize = ALIGN( size, alignment );
	stagingSize = NUM_FRAMES * bufferSize;

	CreateStagingBuffer();
	CreateGpuBuffer();
}

void FrameAheadGpuBuffer::Destroy()
{
	if (glBuffer)
	{
		qglDeleteBuffers(1, &glBuffer);
		glBuffer = 0;
	}
	if (glMemoryObject)
	{
		qglDeleteMemoryObjectsEXT(1, &glMemoryObject);
		glMemoryObject = 0;
	}
	if (gpuBuffer)
	{
		vmaDestroyBuffer(vulkan->allocator, gpuBuffer, gpuAllocation);
		gpuBuffer = nullptr;
		gpuAllocation = nullptr;
	}
	if (stagingBuffer)
	{
		vmaDestroyBuffer(vulkan->allocator, stagingBuffer, stagingAllocation);
		stagingBuffer = nullptr;
		stagingAllocation = nullptr;
	}
}

void FrameAheadGpuBuffer::CreateStagingBuffer()
{
	VkBufferCreateInfo createInfo {};
	createInfo.sType = VK_STRUCTURE_TYPE_BUFFER_CREATE_INFO;
	createInfo.size = stagingSize;
	createInfo.usage = VK_BUFFER_USAGE_TRANSFER_SRC_BIT;
	createInfo.sharingMode = VK_SHARING_MODE_EXCLUSIVE;

	VmaAllocationCreateInfo allocCreateInfo {};
	allocCreateInfo.requiredFlags = VK_MEMORY_PROPERTY_HOST_VISIBLE_BIT;
	allocCreateInfo.flags = VMA_ALLOCATION_CREATE_MAPPED_BIT | VMA_ALLOCATION_CREATE_HOST_ACCESS_SEQUENTIAL_WRITE_BIT;
	allocCreateInfo.usage = VMA_MEMORY_USAGE_AUTO;

	VmaAllocationInfo allocInfo;
	VulkanSystem::EnsureSuccess("creating frame-ahead staging buffer",
		vmaCreateBuffer(vulkan->allocator, &createInfo, &allocCreateInfo,
			&stagingBuffer, &stagingAllocation, &allocInfo));
}

extern void GL_CheckErrors();

void FrameAheadGpuBuffer::CreateGpuBuffer()
{
	VkBufferCreateInfo createInfo {};
	createInfo.sType = VK_STRUCTURE_TYPE_BUFFER_CREATE_INFO;
	createInfo.size = bufferSize;
	createInfo.usage = VK_BUFFER_USAGE_TRANSFER_DST_BIT | usage;
	createInfo.sharingMode = VK_SHARING_MODE_EXCLUSIVE;

	VmaAllocationCreateInfo allocCreateInfo {};
	allocCreateInfo.requiredFlags = VK_MEMORY_PROPERTY_DEVICE_LOCAL_BIT;
	allocCreateInfo.usage = VMA_MEMORY_USAGE_AUTO_PREFER_DEVICE;

	VmaAllocationInfo allocInfo;
	VulkanSystem::EnsureSuccess("creating frame-ahead GPU buffer",
		vmaCreateBufferWithAlignment(vulkan->allocator, &createInfo, &allocCreateInfo, 32,
			&gpuBuffer, &gpuAllocation, &allocInfo));

	// OpenGL interop: export and expose buffer to OpenGL
	VkMemoryGetWin32HandleInfoKHR handleInfo {};
	handleInfo.sType = VK_STRUCTURE_TYPE_MEMORY_GET_WIN32_HANDLE_INFO_KHR;
	handleInfo.handleType = VK_EXTERNAL_MEMORY_HANDLE_TYPE_OPAQUE_WIN32_BIT_KHR;
	handleInfo.memory = allocInfo.deviceMemory;
	VulkanSystem::EnsureSuccess("getting Win32 memory handle", vkGetMemoryWin32HandleKHR(vulkan->device, &handleInfo, &handle));

	qglCreateMemoryObjectsEXT(1, &glMemoryObject);
	qglImportMemoryWin32HandleEXT(glMemoryObject, allocInfo.size + allocInfo.offset, GL_HANDLE_TYPE_OPAQUE_WIN32_EXT, handle);
	GL_CheckErrors();
	qglCreateBuffers(1, &glBuffer);
	qglNamedBufferStorageMemEXT(glBuffer, bufferSize, glMemoryObject, allocInfo.offset);
	GL_CheckErrors();
}
