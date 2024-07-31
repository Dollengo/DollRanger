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

#include "dr_descriptors.hpp"
#include "dr_device.hpp"
#include "dr_game_object.hpp"
#include "dr_renderer.hpp"
#include "dr_window.hpp"

/*
You need import these libraries in your main archive, for you use all the libraries functions

#include "flecs/flecs.h" // ECS
#include "physic_collision/handle.hpp" // Physics and Collision
#include "tinyobjloader/tiny_obj_loader.h" // obj loader
#include "sdl_mixer/music.h" // musics
#include "sdl_mixer/mixer.h" // mixer
#include "sdl_mixer/utils.h" // sdl_mixer utils
#include "sdl_mixer/effects_internal.h" // effects_internal
#include "imgui/imgui.h" // gui/UI
#include "qtbase/corelib/global/qglobal.h" // qt: for ui/gui
*/

#include <memory>
#include <vector>

namespace dr {
class FirstApp {
 public:

  FirstApp();
  ~FirstApp();

  FirstApp(const FirstApp &) = delete;
  FirstApp &operator=(const FirstApp &) = delete;

  void run();

 private:
  void loadGameObjects();

  drWindow drWindow{int WIDTH, int HEIGHT, std::string NAME};
  drDevice drDevice{drWindow};
  drRenderer drRenderer{drWindow, drDevice};

  // note: order of declarations matters
  std::unique_ptr<drDescriptorPool> globalPool{};
  drGameObject::Map gameObjects;
};
}  // namespace dr
