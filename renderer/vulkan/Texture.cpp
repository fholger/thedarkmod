#include "precompiled.h"
#include "Texture.h"

#include "StagingBuffer.h"
#include "VulkanSystem.h"

extern void GL_CheckErrors();


void Texture::InitRaw()
{
	if (image)
	{
		Destroy();
	}

	VkExternalMemoryImageCreateInfoKHR extMemInfo {};
	extMemInfo.sType = VK_STRUCTURE_TYPE_EXTERNAL_MEMORY_IMAGE_CREATE_INFO_KHR;
	extMemInfo.handleTypes = VK_EXTERNAL_MEMORY_HANDLE_TYPE_OPAQUE_WIN32_BIT_KHR;
	createInfo.sType = VK_STRUCTURE_TYPE_IMAGE_CREATE_INFO;
	createInfo.pNext = &extMemInfo;
	createInfo.usage |= VK_IMAGE_USAGE_TRANSFER_DST_BIT;
	createInfo.tiling = VK_IMAGE_TILING_OPTIMAL;
	createInfo.initialLayout = VK_IMAGE_LAYOUT_UNDEFINED;
	createInfo.sharingMode = VK_SHARING_MODE_EXCLUSIVE;

	VmaAllocationCreateInfo allocCreateInfo {};
	allocCreateInfo.requiredFlags = VK_MEMORY_PROPERTY_DEVICE_LOCAL_BIT;
	allocCreateInfo.usage = VMA_MEMORY_USAGE_AUTO_PREFER_DEVICE;

	VmaAllocationInfo allocInfo;
	VulkanSystem::EnsureSuccess("creating image",
		vmaCreateImage(vulkan->allocator, &createInfo, &allocCreateInfo, &image, &allocation, &allocInfo));

	currentLayout = VK_IMAGE_LAYOUT_UNDEFINED;

	// OpenGL interop
	HANDLE handle;
	VkMemoryGetWin32HandleInfoKHR handleInfo {};
	handleInfo.sType = VK_STRUCTURE_TYPE_MEMORY_GET_WIN32_HANDLE_INFO_KHR;
	handleInfo.handleType = VK_EXTERNAL_MEMORY_HANDLE_TYPE_OPAQUE_WIN32_BIT_KHR;
	handleInfo.memory = allocInfo.deviceMemory;
	VulkanSystem::EnsureSuccess("acquring handle for image",
		vkGetMemoryWin32HandleKHR(vulkan->device, &handleInfo, &handle));

	qglCreateMemoryObjectsEXT(1, &glMemoryObject);
	qglImportMemoryWin32HandleEXT(glMemoryObject, allocInfo.size + allocInfo.offset, GL_HANDLE_TYPE_OPAQUE_WIN32_EXT, handle);
	GL_CheckErrors();
	if (createInfo.imageType == VK_IMAGE_TYPE_3D || (createInfo.imageType == VK_IMAGE_TYPE_2D && createInfo.arrayLayers > 1))
	{
		uint32_t depth = Max(createInfo.arrayLayers, createInfo.extent.depth);
		qglCreateTextures(createInfo.imageType == VK_IMAGE_TYPE_3D ? GL_TEXTURE_3D : GL_TEXTURE_2D, 1, &glTexture);
		if (createInfo.samples != VK_SAMPLE_COUNT_1_BIT)
		{
			qglTextureStorageMem3DMultisampleEXT(glTexture, createInfo.samples, createInfo.mipLevels, GL_RGBA8, createInfo.extent.width, createInfo.extent.height, depth, glMemoryObject, allocInfo.offset);
		} else
		{
			qglTextureStorageMem3DEXT(glTexture, createInfo.mipLevels, GL_RGBA8, createInfo.extent.width, createInfo.extent.height, depth, glMemoryObject, allocInfo.offset);
		}
	}
	else if (createInfo.imageType == VK_IMAGE_TYPE_2D || (createInfo.imageType == VK_IMAGE_TYPE_1D && createInfo.arrayLayers > 1))
	{
		uint32_t height = Max(createInfo.arrayLayers, createInfo.extent.height);
		qglCreateTextures(createInfo.imageType == VK_IMAGE_TYPE_2D ? GL_TEXTURE_2D : GL_TEXTURE_1D, 1, &glTexture);
		if (createInfo.samples != VK_SAMPLE_COUNT_1_BIT)
		{
			qglTextureStorageMem2DMultisampleEXT(glTexture, createInfo.samples, createInfo.mipLevels, GL_RGBA8, createInfo.extent.width, height, glMemoryObject, allocInfo.offset);
		} else
		{
			qglTextureStorageMem2DEXT(glTexture, createInfo.mipLevels, GL_RGBA8, createInfo.extent.width, height, glMemoryObject, allocInfo.offset);
		}
	}
	else if (createInfo.imageType == VK_IMAGE_TYPE_1D)
	{
		qglCreateTextures(GL_TEXTURE_1D, 1, &glTexture);
		qglTextureStorageMem1DEXT(glTexture, createInfo.mipLevels, GL_RGBA8, createInfo.extent.width, glMemoryObject, allocInfo.offset);
	}
	GL_CheckErrors();
}

void Texture::Init2D(VkFormat format, uint32_t width, uint32_t height, uint32_t mipLevels)
{
	createInfo = {};
	createInfo.imageType = VK_IMAGE_TYPE_2D;
	createInfo.format = format;
	createInfo.extent.width = width;
	createInfo.extent.height = height;
	createInfo.extent.depth = 1;
	createInfo.arrayLayers = 1;
	createInfo.mipLevels = mipLevels;
	createInfo.samples = VK_SAMPLE_COUNT_1_BIT;
	createInfo.usage = VK_IMAGE_USAGE_SAMPLED_BIT;
	InitRaw();
}

void Texture::Destroy()
{
	if (glTexture)
	{
		qglDeleteTextures(1, &glTexture);
		glTexture = 0;
	}
	if (glMemoryObject)
	{
		qglDeleteMemoryObjectsEXT(1, &glMemoryObject);
		glMemoryObject = 0;
	}
	if (image)
	{
		vmaDestroyImage(vulkan->allocator, image, allocation);
		image = nullptr;
		allocation = nullptr;
	}
}

void Texture::CopyFromBuffer(VkCommandBuffer cmd, const StagingBuffer &buffer)
{
	TransitionLayout(cmd, VK_IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL);
	VkBufferImageCopy region {};
	region.imageSubresource.layerCount = 1;
	// TODO: region
	vkCmdCopyBufferToImage(cmd, buffer.buffer, image, VK_IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL, 1, &region);
}

void Texture::TransitionLayout(VkCommandBuffer cmd, VkImageLayout newLayout)
{
	if (!image || currentLayout == newLayout)
	{
		return;
	}

	VkImageMemoryBarrier2 imageBarrier {};
	imageBarrier.sType = VK_STRUCTURE_TYPE_IMAGE_MEMORY_BARRIER_2;
	imageBarrier.image = image;
	imageBarrier.subresourceRange.aspectMask = VK_IMAGE_ASPECT_COLOR_BIT;
	imageBarrier.subresourceRange.baseMipLevel = 0;
	imageBarrier.subresourceRange.levelCount = createInfo.mipLevels;
	imageBarrier.subresourceRange.baseArrayLayer = 0;
	imageBarrier.subresourceRange.layerCount = createInfo.arrayLayers;
	imageBarrier.oldLayout = currentLayout;
	imageBarrier.newLayout = newLayout;
	imageBarrier.srcQueueFamilyIndex = VK_QUEUE_FAMILY_IGNORED;
	imageBarrier.dstQueueFamilyIndex = VK_QUEUE_FAMILY_IGNORED;

	switch (currentLayout)
	{
	case VK_IMAGE_LAYOUT_UNDEFINED:
		imageBarrier.srcStageMask = VK_PIPELINE_STAGE_2_NONE;
		imageBarrier.srcAccessMask = 0;
		break;
	case VK_IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL:
		imageBarrier.srcStageMask = VK_PIPELINE_STAGE_2_TRANSFER_BIT;
		imageBarrier.srcAccessMask = VK_ACCESS_2_TRANSFER_WRITE_BIT;
		break;
	case VK_IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL:
		imageBarrier.srcStageMask = VK_PIPELINE_STAGE_2_COLOR_ATTACHMENT_OUTPUT_BIT;
		imageBarrier.srcAccessMask = VK_ACCESS_2_COLOR_ATTACHMENT_WRITE_BIT;
		break;
	case VK_IMAGE_LAYOUT_DEPTH_ATTACHMENT_OPTIMAL:
	case VK_IMAGE_LAYOUT_DEPTH_STENCIL_ATTACHMENT_OPTIMAL:
		imageBarrier.srcStageMask = VK_PIPELINE_STAGE_2_LATE_FRAGMENT_TESTS_BIT;
		imageBarrier.srcAccessMask = VK_ACCESS_2_DEPTH_STENCIL_ATTACHMENT_WRITE_BIT;
		break;
	case VK_IMAGE_LAYOUT_SHADER_READ_ONLY_OPTIMAL:
		imageBarrier.srcStageMask = VK_PIPELINE_STAGE_2_FRAGMENT_SHADER_BIT;
		imageBarrier.srcAccessMask = VK_ACCESS_2_SHADER_READ_BIT | VK_ACCESS_2_SHADER_SAMPLED_READ_BIT;
		break;
	case VK_IMAGE_LAYOUT_TRANSFER_SRC_OPTIMAL:
		imageBarrier.srcStageMask = VK_PIPELINE_STAGE_2_TRANSFER_BIT;
		imageBarrier.srcAccessMask = VK_ACCESS_2_TRANSFER_READ_BIT;
		break;
	default:
		common->Warning("Unhandled image layout transition from %u\n", currentLayout);
	}

	switch (newLayout)
	{
	case VK_IMAGE_LAYOUT_TRANSFER_SRC_OPTIMAL:
		imageBarrier.dstStageMask = VK_PIPELINE_STAGE_2_TRANSFER_BIT;
		imageBarrier.dstAccessMask = VK_ACCESS_2_TRANSFER_READ_BIT;
		break;
	case VK_IMAGE_LAYOUT_TRANSFER_DST_OPTIMAL:
		imageBarrier.dstStageMask = VK_PIPELINE_STAGE_2_TRANSFER_BIT;
		imageBarrier.dstAccessMask = VK_ACCESS_2_TRANSFER_WRITE_BIT;
		break;
	case VK_IMAGE_LAYOUT_SHADER_READ_ONLY_OPTIMAL:
		imageBarrier.dstStageMask = VK_PIPELINE_STAGE_2_FRAGMENT_SHADER_BIT;
		imageBarrier.dstAccessMask = VK_ACCESS_2_SHADER_READ_BIT;
		break;
	case VK_IMAGE_LAYOUT_COLOR_ATTACHMENT_OPTIMAL:
		imageBarrier.dstStageMask = VK_PIPELINE_STAGE_2_COLOR_ATTACHMENT_OUTPUT_BIT;
		imageBarrier.dstAccessMask = VK_ACCESS_2_COLOR_ATTACHMENT_WRITE_BIT;
		break;
	case VK_IMAGE_LAYOUT_DEPTH_ATTACHMENT_OPTIMAL:
	case VK_IMAGE_LAYOUT_DEPTH_STENCIL_ATTACHMENT_OPTIMAL:
		imageBarrier.dstStageMask = VK_PIPELINE_STAGE_2_LATE_FRAGMENT_TESTS_BIT;
		imageBarrier.dstAccessMask = VK_ACCESS_2_DEPTH_STENCIL_ATTACHMENT_WRITE_BIT;
		break;
	default:
		common->Warning("Unhandled image layout transition to %u\n", newLayout);
	}

	VkDependencyInfo depInfo {};
	depInfo.sType = VK_STRUCTURE_TYPE_DEPENDENCY_INFO;
	depInfo.imageMemoryBarrierCount = 1;
	depInfo.pImageMemoryBarriers = &imageBarrier;
	vkCmdPipelineBarrier2(cmd, &depInfo);

	currentLayout = newLayout;
}

GLuint Texture::VkFormatToGL(VkFormat format)
{
	switch (format)
	{
	case VK_FORMAT_R8G8B8A8_UNORM:
		return GL_RGBA8;
	case VK_FORMAT_R8G8B8A8_SRGB:
		return GL_SRGB8_ALPHA8;
	case VK_FORMAT_R16G16B16A16_SFLOAT:
		return GL_RGBA16F;
	case VK_FORMAT_R8G8B8_UNORM:
		return GL_RGB8;
	case VK_FORMAT_D24_UNORM_S8_UINT:
		return GL_DEPTH24_STENCIL8;
	case VK_FORMAT_D32_SFLOAT_S8_UINT:
		return GL_DEPTH32F_STENCIL8;
	case VK_FORMAT_D32_SFLOAT:
		return GL_DEPTH_COMPONENT32F;
	case VK_FORMAT_D16_UNORM:
		return GL_DEPTH_COMPONENT16;
	default:
		common->Warning("Unknown Vulkan format: %u", format);
		return GL_RGBA8;
	}
}
