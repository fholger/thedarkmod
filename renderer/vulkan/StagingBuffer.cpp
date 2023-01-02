#include "precompiled.h"
#include "StagingBuffer.h"

#include "DeviceLocalBuffer.h"
#include "VulkanSystem.h"

void StagingBuffer::Init(uint32_t size)
{
	if (buffer)
	{
		Destroy();
	}

	VkExternalMemoryBufferCreateInfoKHR extMemInfo {};
	extMemInfo.sType = VK_STRUCTURE_TYPE_EXTERNAL_MEMORY_BUFFER_CREATE_INFO_KHR;
	extMemInfo.handleTypes = VK_EXTERNAL_MEMORY_HANDLE_TYPE_OPAQUE_WIN32_BIT_KHR;
	VkBufferCreateInfo createInfo {};
	createInfo.sType = VK_STRUCTURE_TYPE_BUFFER_CREATE_INFO;
	createInfo.size = size;
	createInfo.usage = VK_BUFFER_USAGE_TRANSFER_SRC_BIT;
	createInfo.sharingMode = VK_SHARING_MODE_EXCLUSIVE;
	createInfo.pNext = &extMemInfo;

	VmaAllocationCreateInfo allocCreateInfo {};
	allocCreateInfo.requiredFlags = VK_MEMORY_PROPERTY_HOST_VISIBLE_BIT;
	allocCreateInfo.flags = VMA_ALLOCATION_CREATE_MAPPED_BIT | VMA_ALLOCATION_CREATE_HOST_ACCESS_SEQUENTIAL_WRITE_BIT;
	allocCreateInfo.usage = VMA_MEMORY_USAGE_AUTO;

	VmaAllocationInfo allocInfo;
	VulkanSystem::EnsureSuccess("creating staging buffer",
		vmaCreateBuffer(vulkan->allocator, &createInfo, &allocCreateInfo, &buffer, &allocation, &allocInfo));
	mappedData = allocInfo.pMappedData;
}

void StagingBuffer::Destroy()
{
	if (buffer)
	{
		vmaDestroyBuffer(vulkan->allocator, buffer, allocation);
		buffer = nullptr;
		allocation = nullptr;
	}
	mappedData = nullptr;
}

void StagingBuffer::CopyBuffer(VkCommandBuffer cmd, DeviceLocalBuffer &target, uint32_t size, uint32_t srcOffset, uint32_t dstOffset)
{
	VkBufferCopy region;
	region.size = size;
	region.srcOffset = srcOffset;
	region.dstOffset = dstOffset;

	vmaFlushAllocation(vulkan->allocator, allocation, region.srcOffset, region.size);

	vkCmdCopyBuffer(cmd, buffer, target.buffer, 1, &region);
	VkBufferMemoryBarrier2 barrier {};
	barrier.sType = VK_STRUCTURE_TYPE_BUFFER_MEMORY_BARRIER_2;
	barrier.buffer = target.buffer;
	barrier.offset = dstOffset;
	barrier.size = size;
	barrier.srcQueueFamilyIndex = VK_QUEUE_FAMILY_IGNORED;
	barrier.srcStageMask = VK_PIPELINE_STAGE_2_TRANSFER_BIT;
	barrier.srcAccessMask = VK_ACCESS_2_MEMORY_WRITE_BIT;
	barrier.dstQueueFamilyIndex = VK_QUEUE_FAMILY_IGNORED;
	barrier.dstStageMask = VK_PIPELINE_STAGE_2_VERTEX_INPUT_BIT;
	barrier.dstAccessMask = VK_ACCESS_2_MEMORY_READ_BIT;
	VkDependencyInfo depInfo {};
	depInfo.sType = VK_STRUCTURE_TYPE_DEPENDENCY_INFO;
	depInfo.bufferMemoryBarrierCount = 1;
	depInfo.pBufferMemoryBarriers = &barrier;
	vkCmdPipelineBarrier2(cmd, &depInfo);
}
