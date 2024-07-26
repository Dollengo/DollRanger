/*
The MIT License (MIT)

Copyright (c) 2024, Dollengo

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in
all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
THE SOFTWARE.

Please support independent developers by not copying or illegally distributing
their code. The development community relies on mutual support and respect to
thrive and continue innovating. Software piracy not only financially harms the
creators but also discourages the creation of new projects and collaboration
within the community.

By respecting licenses and contributing fairly, you are helping to ensure that
open-source projects continue to be developed and improved. Your integrity and
support are vital for the growth and success of small and independent developers.
Thank you for doing your part.
*/

#pragma once

#include "dr_device.hpp"

#include <memory>
#include <unordered_map>
#include <vector>

namespace dr {

class drDescriptorSetLayout {
 public:
  class Builder {
   public:
    Builder(drDevice &drDevice) : drDevice{drDevice} {}

    Builder &addBinding(
        uint32_t binding,
        VkDescriptorType descriptorType,
        VkShaderStageFlags stageFlags,
        uint32_t count = 1);
    std::unique_ptr<drDescriptorSetLayout> build() const;

   private:
    drDevice &drDevice;
    std::unordered_map<uint32_t, VkDescriptorSetLayoutBinding> bindings{};
  };

  drDescriptorSetLayout(
      drDevice &drDevice, std::unordered_map<uint32_t, VkDescriptorSetLayoutBinding> bindings);
  ~drDescriptorSetLayout();
  drDescriptorSetLayout(const drDescriptorSetLayout &) = delete;
  drDescriptorSetLayout &operator=(const drDescriptorSetLayout &) = delete;

  VkDescriptorSetLayout getDescriptorSetLayout() const { return descriptorSetLayout; }

 private:
  drDevice &drDevice;
  VkDescriptorSetLayout descriptorSetLayout;
  std::unordered_map<uint32_t, VkDescriptorSetLayoutBinding> bindings;

  friend class drDescriptorWriter;
};

class drDescriptorPool {
 public:
  class Builder {
   public:
    Builder(drDevice &drDevice) : drDevice{drDevice} {}

    Builder &addPoolSize(VkDescriptorType descriptorType, uint32_t count);
    Builder &setPoolFlags(VkDescriptorPoolCreateFlags flags);
    Builder &setMaxSets(uint32_t count);
    std::unique_ptr<drDescriptorPool> build() const;

   private:
    drDevice &drDevice;
    std::vector<VkDescriptorPoolSize> poolSizes{};
    uint32_t maxSets = 1000;
    VkDescriptorPoolCreateFlags poolFlags = 0;
  };

  drDescriptorPool(
      drDevice &drDevice,
      uint32_t maxSets,
      VkDescriptorPoolCreateFlags poolFlags,
      const std::vector<VkDescriptorPoolSize> &poolSizes);
  ~drDescriptorPool();
  drDescriptorPool(const drDescriptorPool &) = delete;
  drDescriptorPool &operator=(const drDescriptorPool &) = delete;

  bool allocateDescriptor(
      const VkDescriptorSetLayout descriptorSetLayout, VkDescriptorSet &descriptor) const;

  void freeDescriptors(std::vector<VkDescriptorSet> &descriptors) const;

  void resetPool();

 private:
  drDevice &drDevice;
  VkDescriptorPool descriptorPool;

  friend class drDescriptorWriter;
};

class drDescriptorWriter {
 public:
  drDescriptorWriter(drDescriptorSetLayout &setLayout, drDescriptorPool &pool);

  drDescriptorWriter &writeBuffer(uint32_t binding, VkDescriptorBufferInfo *bufferInfo);
  drDescriptorWriter &writeImage(uint32_t binding, VkDescriptorImageInfo *imageInfo);

  bool build(VkDescriptorSet &set);
  void overwrite(VkDescriptorSet &set);

 private:
  drDescriptorSetLayout &setLayout;
  drDescriptorPool &pool;
  std::vector<VkWriteDescriptorSet> writes;
};

}  // namespace dr
