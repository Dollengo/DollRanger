![DollRanger-Engine](https://github.com/user-attachments/assets/322ed0ff-bcff-41fd-9827-fb73b5458c1c)

<h1 align="center">DollRanger</h1>
<h3 align="center">Game Engine open source</h3>

<p align='center'>
 <a href="https://ko-fi.com/dollengo">
    <img src="https://img.shields.io/badge/sponsor-30363D?style=for-the-badge&logo=GitHub-Sponsors&logoColor=#white" />
  <a href="https://cmake.org">
   <img src="https://img.shields.io/badge/CMake-%23008FBA.svg?style=for-the-badge&logo=cmake&logoColor=white" ?>
  <a href="https://cplusplus.com">
   <img src="https://img.shields.io/badge/c++-%2300599C.svg?style=for-the-badge&logo=c%2B%2B&logoColor=white" ?>
  <a href="#">
  <img alt="STARS" src="https://img.shields.io/github/stars/dollengo/dollranger?style=for-the-badge">
<a href="#">
  <img alt="RELEASE" src="https://img.shields.io/badge/RELEASE-v1.0.0-blue?style=flat-square&logoColor=white" style="width: 140px; height: 28px;">

DollRanger is a powerful and versatile game engine developed to provide developers with the tools necessary to create high-quality games. With support for advanced rendering, camera control, physics systems, and more, DollRanger is an ideal choice for independent developers and small game studios.

## Features

- Advanced rendering using Vulkan.
- Easy-to-use camera control.
- Support for point lights and other lighting systems.
- Efficient handling of game objects.
- Extensible with various external libraries.

## Table of Contents

1. [Getting Started](#getting-started)
2. [Installation](#installation)
3. [Usage](#usage)
4. [Contributing](#contributing)
5. [Credits](#credits)
6. [License](#license)

## Getting Started

These instructions will help you get a copy of the project up and running on your local machine for development and testing purposes.

### Prerequisites

- CMake 3.11 or higher
- Vulkan SDK
- GLFW
- GCC or MinGW (for Windows)
- Git
- GLFW
- glm

### Installation

1. **Clone the repository:**

```bash
git clone https://github.com/Dollengo/DollRanger
cd DollRanger
```

2. **Setup the engine:**

```bash
./unixSetup.sh
```
or just execute the `mingwSetup.bat`

3. **Build the project:**

```bash
./unixBuild.sh
```
or
```bat
./mingwBuild.bat
```

### Usage

To run the application, simply execute the built binary:

```bash
./DollRanger
```

You can modify and extend the engine by editing the source files in the `src` directory. The main application logic is found in `dr_first_app.cpp`.

### Create projects:

For create your projects/games, create a directory in `Projects`, and create the main.cpp, import `dr_first_app.cpp`, and create a template. For use ECS, physics and others, import src/(lib).

## Contributing

We welcome contributions to the DollRanger project. To contribute, please follow these steps:

1. **Fork the repository:**

Click the "Fork" button at the top of the repository page to create a copy of the repository on your GitHub account.

2. **Clone your fork:**

```bash
git clone https://github.com/your-username/DollRanger.git
cd DollRanger
```

3. **Create a new branch:**

```bash
git checkout -b my-feature-branch
```

4. **Make your changes:**

Edit the files in the repository to add your new feature or fix a bug.

5. **Commit your changes:**

```bash
git add .
git commit -m "Description of my changes"
```

6. **Push your changes:**

```bash
git push origin my-feature-branch
```

7. **Create a Pull Request:**

Go to the original repository on GitHub and click "New Pull Request" to submit your changes for review.

## Credits

- **Physics System:** [Slingshot Physics](https://github.com/Slingshot-Physics/slingshot-community)
- **Vulkan Tutorial Follow:** [YouTube](https://youtu.be/Y9U9IE0gVHA?si=tkCGbDV9H_3cLwis)
- **Flecs [fast and lightweight Entity Component System]:** [Flecs GitHub](https://github.com/SanderMertens/flecs) | [Flecs.dev](https://www.flecs.dev/)
- **ImGui [visual library]:** [ImGui GitHub](https://github.com/ocornut/imgui)
- **SDL [audio management]:** [SDL_GitHub](https://github.com/libsdl-org/SDL)
- **Dollengo:** [GitHub](https://github.com/dollengo) | [Website](https://dollengo.vercel.app)

- And **glm**, **GLFW**, and others renderers...

## License

DollRanger is licensed under the GPL-3.0 license. See the `LICENSE` file for more details.
