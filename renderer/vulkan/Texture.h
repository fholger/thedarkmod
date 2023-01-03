#pragma once
#include "qvulkan.h"

class StagingBuffer;

class Texture
{
public:
	~Texture() { Destroy(); }

	void Init2D(VkFormat format, uint32_t width, uint32_t height, uint32_t mipLevels = 1);
	void Destroy();

	void CopyFromBuffer(VkCommandBuffer cmd, const StagingBuffer &buffer);
	void TransitionLayout(VkCommandBuffer cmd, VkImageLayout newLayout);

	static GLuint VkFormatToGL(VkFormat format);

private:
	void InitRaw();

	VkImageCreateInfo createInfo = {};
	VkImage image = nullptr;
	VmaAllocation allocation = nullptr;
	VkImageLayout currentLayout = VK_IMAGE_LAYOUT_UNDEFINED;
	GLuint glMemoryObject = 0;
	GLuint glTexture = 0;
};
