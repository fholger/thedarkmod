#include "precompiled.h"
#include "DeviceLocalBuffer.h"

#include "VulkanSystem.h"

extern void GL_CheckErrors();


void DeviceLocalBuffer::Init(VkBufferUsageFlags usage, uint32_t size)
{
	if (buffer)
	{
		Destroy();
	}
	this->size = size;

	VkExternalMemoryBufferCreateInfoKHR extMemInfo {};
	extMemInfo.sType = VK_STRUCTURE_TYPE_EXTERNAL_MEMORY_BUFFER_CREATE_INFO_KHR;
	extMemInfo.handleTypes = VK_EXTERNAL_MEMORY_HANDLE_TYPE_OPAQUE_WIN32_BIT_KHR;
	VkBufferCreateInfo createInfo {};
	createInfo.sType = VK_STRUCTURE_TYPE_BUFFER_CREATE_INFO;
	createInfo.size = size;
	createInfo.usage = VK_BUFFER_USAGE_TRANSFER_DST_BIT | usage;
	createInfo.sharingMode = VK_SHARING_MODE_EXCLUSIVE;
	createInfo.pNext = &extMemInfo;

	VmaAllocationCreateInfo allocCreateInfo {};
	allocCreateInfo.requiredFlags = VK_MEMORY_PROPERTY_DEVICE_LOCAL_BIT;
	allocCreateInfo.usage = VMA_MEMORY_USAGE_AUTO_PREFER_DEVICE;

	VmaAllocationInfo allocInfo;
	VulkanSystem::EnsureSuccess("creating device-local buffer",
		vmaCreateBufferWithAlignment(vulkan->allocator, &createInfo, &allocCreateInfo, 32,
			&buffer, &allocation, &allocInfo));

	// OpenGL interop: export and expose buffer to OpenGL
	VkMemoryGetWin32HandleInfoKHR handleInfo {};
	handleInfo.sType = VK_STRUCTURE_TYPE_MEMORY_GET_WIN32_HANDLE_INFO_KHR;
	handleInfo.handleType = VK_EXTERNAL_MEMORY_HANDLE_TYPE_OPAQUE_WIN32_BIT_KHR;
	handleInfo.memory = allocInfo.deviceMemory;
	HANDLE handle;
	VulkanSystem::EnsureSuccess("getting Win32 memory handle",
		vkGetMemoryWin32HandleKHR(vulkan->device, &handleInfo, &handle));

	qglCreateMemoryObjectsEXT(1, &glMemoryObject);
	qglImportMemoryWin32HandleEXT(glMemoryObject, allocInfo.size + allocInfo.offset, GL_HANDLE_TYPE_OPAQUE_WIN32_EXT, handle);
	GL_CheckErrors();
	qglCreateBuffers(1, &glBuffer);
	qglNamedBufferStorageMemEXT(glBuffer, size, glMemoryObject, allocInfo.offset);
	GL_CheckErrors();
}

void DeviceLocalBuffer::Destroy()
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
	if (buffer)
	{
		vmaDestroyBuffer(vulkan->allocator, buffer, allocation);
		buffer = nullptr;
		allocation = nullptr;
	}
}
