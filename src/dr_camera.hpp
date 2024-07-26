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

// libs
#define GLM_FORCE_RADIANS
#define GLM_FORCE_DEPTH_ZERO_TO_ONE
#include <glm/glm.hpp>

namespace dr {

class drCamera {
 public:
  void setOrthographicProjection(
      float left, float right, float top, float bottom, float near, float far);
  void setPerspectiveProjection(float fovy, float aspect, float near, float far);

  void setViewDirection(
      glm::vec3 position, glm::vec3 direction, glm::vec3 up = glm::vec3{0.f, -1.f, 0.f});
  void setViewTarget(
      glm::vec3 position, glm::vec3 target, glm::vec3 up = glm::vec3{0.f, -1.f, 0.f});
  void setViewYXZ(glm::vec3 position, glm::vec3 rotation);

  const glm::mat4& getProjection() const { return projectionMatrix; }
  const glm::mat4& getView() const { return viewMatrix; }
  const glm::mat4& getInverseView() const { return inverseViewMatrix; }
  const glm::vec3 getPosition() const { return glm::vec3(inverseViewMatrix[3]); }

 private:
  glm::mat4 projectionMatrix{1.f};
  glm::mat4 viewMatrix{1.f};
  glm::mat4 inverseViewMatrix{1.f};
};
}  // namespace dr
