# gamedev-resources

[![Links](https://github.com/barisdoguy/gamedev-resources/actions/workflows/links.yml/badge.svg)](https://github.com/barisdoguy/gamedev-resources/actions/workflows/links.yml)

A curated list of open-source repositories that working game and graphics programmers actually use: engines, rendering, core C++ libraries, physics, tooling and code worth studying. Every entry has a short note on why it is here.

Star counts were read from the GitHub API on **2026-11-14** and are rounded. To star everything on this list from your own account, see [Star the whole list](#star-the-whole-list).

## Contents

- [Engines and frameworks](#engines-and-frameworks)
- [Rendering and graphics APIs](#rendering-and-graphics-apis)
- [NVIDIA open source](#nvidia-open-source)
- [Core C++ libraries](#core-c-libraries)
- [Physics and navigation](#physics-and-navigation)
- [Audio and networking](#audio-and-networking)
- [Profiling and debugging](#profiling-and-debugging)
- [Content tools](#content-tools)
- [Learn by reading code](#learn-by-reading-code)
- [Other curated lists](#other-curated-lists)
- [Outside GitHub](#outside-github)
- [Windows workstation setup](#windows-workstation-setup)

## Engines and frameworks

| Repository | ★ | Why it is here |
|---|---:|---|
| [godotengine/godot](https://github.com/godotengine/godot) | 120k | Full 2D/3D engine under MIT. Its renderer and scene tree are very readable for an engine this size. |
| [bevyengine/bevy](https://github.com/bevyengine/bevy) | 49.7k | Data-driven engine in Rust, built entirely around ECS. |
| [phaserjs/phaser](https://github.com/phaserjs/phaser) | 40.7k | The standard HTML5 2D game framework. |
| [raysan5/raylib](https://github.com/raysan5/raylib) | 35.7k | Small C library for learning game programming. No dependencies, hundreds of examples. |
| [google/filament](https://github.com/google/filament) | 20.7k | Production physically based renderer for Android, iOS, desktop and web. Excellent documentation of the PBR math. |
| [MonoGame/MonoGame](https://github.com/MonoGame/MonoGame) | 14.6k | C# framework, the open successor to XNA. Stardew Valley runs on it. |
| [TheCherno/Hazel](https://github.com/TheCherno/Hazel) | 13.1k | Engine built step by step in a video series. Useful for seeing how engine architecture grows. |
| [floooh/sokol](https://github.com/floooh/sokol) | 10.4k | Minimal single-header cross-platform libraries: graphics, app, audio, time. |
| [cocos/cocos-engine](https://github.com/cocos/cocos-engine) | 9.9k | Engine widely used for mobile games. |
| [o3de/o3de](https://github.com/o3de/o3de) | 9.9k | Open 3D Engine, a large AAA-scale codebase descended from Amazon Lumberyard. |
| [love2d/love](https://github.com/love2d/love) | 9.0k | 2D framework scripted in Lua. Fast for prototyping. |
| [stride3d/stride](https://github.com/stride3d/stride) | 8.0k | C# 3D engine with an editor. |
| [defold/defold](https://github.com/defold/defold) | 6.5k | Lightweight engine with very small builds, strong on mobile and web. |
| [DiligentGraphics/DiligentEngine](https://github.com/DiligentGraphics/DiligentEngine) | 4.5k | Modern graphics abstraction over D3D11, D3D12, Vulkan, Metal and WebGPU. |

## Rendering and graphics APIs

| Repository | ★ | Why it is here |
|---|---:|---|
| [mrdoob/three.js](https://github.com/mrdoob/three.js) | 118k | The JavaScript 3D library for WebGL and WebGPU. |
| [bkaradzic/bgfx](https://github.com/bkaradzic/bgfx) | 17.6k | Cross-platform rendering library: "bring your own engine". |
| [SaschaWillems/Vulkan](https://github.com/SaschaWillems/Vulkan) | 12.2k | The reference collection of Vulkan examples, one technique per sample. |
| [zeux/meshoptimizer](https://github.com/zeux/meshoptimizer) | 8.9k | Mesh optimization for GPU vertex cache, overdraw and size. Used across the industry. |
| [microsoft/DirectX-Graphics-Samples](https://github.com/microsoft/DirectX-Graphics-Samples) | 6.9k | Official Direct3D 12 samples, including DXR ray tracing. |
| [ConfettiFX/The-Forge](https://github.com/ConfettiFX/The-Forge) | 5.8k | Cross-platform rendering framework used in shipped console and PC titles. |
| [shader-slang/slang](https://github.com/shader-slang/slang) | 5.8k | Shading language that started at NVIDIA Research and is now hosted by Khronos. Compiles to HLSL, GLSL, SPIR-V, Metal and CUDA. |
| [KhronosGroup/Vulkan-Samples](https://github.com/KhronosGroup/Vulkan-Samples) | 5.4k | Official Khronos Vulkan samples with performance guidance. |
| [EmbarkStudios/kajiya](https://github.com/EmbarkStudios/kajiya) | 5.3k | Experimental real-time global illumination renderer in Rust. |
| [microsoft/DirectXShaderCompiler](https://github.com/microsoft/DirectXShaderCompiler) | 3.7k | The HLSL compiler (DXC). Also outputs SPIR-V for Vulkan. |
| [GPUOpen-LibrariesAndSDKs/VulkanMemoryAllocator](https://github.com/GPUOpen-LibrariesAndSDKs/VulkanMemoryAllocator) | 3.5k | GPU memory allocation for Vulkan. Nearly every Vulkan engine uses it. |
| [BinomialLLC/basis_universal](https://github.com/BinomialLLC/basis_universal) | 3.1k | Supercompressed GPU textures that transcode to BCn, ASTC or ETC at load time. |
| [KhronosGroup/SPIRV-Cross](https://github.com/KhronosGroup/SPIRV-Cross) | 2.6k | Shader reflection and SPIR-V conversion to GLSL, HLSL and MSL. |

## NVIDIA open source

| Repository | ★ | Why it is here |
|---|---:|---|
| [NVIDIA-Omniverse/PhysX](https://github.com/NVIDIA-Omniverse/PhysX) | 4.9k | The PhysX 5 SDK, BSD-3 licensed. The physics engine inside many commercial engines. |
| [NVIDIAGameWorks/Falcor](https://github.com/NVIDIAGameWorks/Falcor) | 3.3k | Real-time rendering framework used for NVIDIA graphics research. |
| [NVIDIA-RTX/NVRHI](https://github.com/NVIDIA-RTX/NVRHI) | 2.1k | Rendering hardware interface over D3D11, D3D12 and Vulkan. |
| [NVIDIAGameWorks/rtx-remix](https://github.com/NVIDIAGameWorks/rtx-remix) | 1.7k | RTX Remix runtime and toolkit for path-traced remasters of classic games. |
| [NVIDIA/DLSS](https://github.com/NVIDIA/DLSS) | 1.7k | DLSS SDK: AI upscaling and frame generation. |
| [NVIDIA-RTX/Streamline](https://github.com/NVIDIA-RTX/Streamline) | 1.4k | One integration layer for DLSS, Reflex and other upscalers. |
| [NVIDIA-RTX/RTXPT](https://github.com/NVIDIA-RTX/RTXPT) | 1.1k | Real-time path tracing library and sample. |
| [NVIDIA-RTX/NRD](https://github.com/NVIDIA-RTX/NRD) | 0.9k | Real-time denoisers for ray-traced shadows, reflections and GI. |
| [NVIDIAGameWorks/RTXGI-DDGI](https://github.com/NVIDIAGameWorks/RTXGI-DDGI) | 0.9k | Dynamic diffuse global illumination with ray-traced probes. |

## Core C++ libraries

| Repository | ★ | Why it is here |
|---|---:|---|
| [ocornut/imgui](https://github.com/ocornut/imgui) | 77.1k | Immediate-mode UI. The default choice for in-game debug tools and editors. |
| [nlohmann/json](https://github.com/nlohmann/json) | 50.9k | JSON for modern C++. Convenient for tools and configuration. |
| [nothings/stb](https://github.com/nothings/stb) | 35.0k | Single-file libraries: image loading and writing, fonts, and more. |
| [gabime/spdlog](https://github.com/gabime/spdlog) | 29.8k | Fast logging. |
| [microsoft/vcpkg](https://github.com/microsoft/vcpkg) | 27.6k | C++ package manager that works with CMake. |
| [google/flatbuffers](https://github.com/google/flatbuffers) | 26.6k | Zero-copy serialization, originally built at Google for games. |
| [fmtlib/fmt](https://github.com/fmtlib/fmt) | 25.9k | String formatting. The basis of `std::format`. |
| [libsdl-org/SDL](https://github.com/libsdl-org/SDL) | 17.0k | Window, input, audio and GPU abstraction. Used by Valve and many shipped games. |
| [glfw/glfw](https://github.com/glfw/glfw) | 15.5k | Window, context and input for OpenGL and Vulkan. |
| [assimp/assimp](https://github.com/assimp/assimp) | 13.3k | Imports dozens of 3D model formats. |
| [skypjack/entt](https://github.com/skypjack/entt) | 13.3k | Fast header-only entity-component system. Used in Minecraft (Bedrock). |
| [g-truc/glm](https://github.com/g-truc/glm) | 11.3k | Math library that mirrors GLSL types and functions. |
| [SanderMertens/flecs](https://github.com/SanderMertens/flecs) | 8.8k | ECS with relationships, queries and a web-based inspector. |
| [KhronosGroup/glTF](https://github.com/KhronosGroup/glTF) | 7.9k | Specification of glTF, the standard runtime 3D asset format. |
| [doctest/doctest](https://github.com/doctest/doctest) | 6.9k | Very fast-compiling unit test framework. |
| [ThePhD/sol2](https://github.com/ThePhD/sol2) | 5.2k | C++ to Lua bindings for gameplay scripting. |
| [Dav1dde/glad](https://github.com/Dav1dde/glad) | 4.6k | OpenGL and Vulkan function loader generator. |
| [jkuhlmann/cgltf](https://github.com/jkuhlmann/cgltf) | 2.0k | Single-file glTF 2.0 loader. |

## Physics and navigation

| Repository | ★ | Why it is here |
|---|---:|---|
| [bulletphysics/bullet3](https://github.com/bulletphysics/bullet3) | 14.9k | Classic rigid-body physics, also used in robotics simulation. |
| [jrouwe/JoltPhysics](https://github.com/jrouwe/JoltPhysics) | 12.3k | Multi-core rigid-body physics used in Horizon Forbidden West. Godot ships it as a built-in option. |
| [erincatto/box2d](https://github.com/erincatto/box2d) | 10.5k | The reference 2D physics engine. |
| [recastnavigation/recastnavigation](https://github.com/recastnavigation/recastnavigation) | 8.2k | Navigation mesh generation and pathfinding (Recast and Detour). |

## Audio and networking

| Repository | ★ | Why it is here |
|---|---:|---|
| [ValveSoftware/GameNetworkingSockets](https://github.com/ValveSoftware/GameNetworkingSockets) | 10.1k | Valve's reliable UDP transport, the open version of what Steam uses. |
| [mackron/miniaudio](https://github.com/mackron/miniaudio) | 7.6k | Single-file audio playback, capture and mixing. |
| [lsalzman/enet](https://github.com/lsalzman/enet) | 3.3k | Small, proven reliable UDP library. |

## Profiling and debugging

| Repository | ★ | Why it is here |
|---|---:|---|
| [wolfpld/tracy](https://github.com/wolfpld/tracy) | 17.1k | Real-time frame profiler for CPU, GPU, memory and locks. Standard in game studios. |
| [baldurk/renderdoc](https://github.com/baldurk/renderdoc) | 11.3k | Frame debugger for Vulkan, D3D11, D3D12 and OpenGL. Capture a frame and inspect every draw call. |

## Content tools

| Repository | ★ | Why it is here |
|---|---:|---|
| [aseprite/aseprite](https://github.com/aseprite/aseprite) | 40.9k | Pixel-art and animation editor. Source-available under its own EULA, not an open-source license. |
| [blender/blender](https://github.com/blender/blender) | 22.0k | Read-only mirror of Blender: modeling, animation and rendering. |
| [mapeditor/tiled](https://github.com/mapeditor/tiled) | 13.1k | General-purpose tile map editor. |
| [deepnight/ldtk](https://github.com/deepnight/ldtk) | 4.9k | Modern 2D level editor from the director of Dead Cells. |
| [Auburn/FastNoiseLite](https://github.com/Auburn/FastNoiseLite) | 3.6k | Procedural noise for terrain and textures in many languages. |

## Learn by reading code

| Repository | ★ | Why it is here |
|---|---:|---|
| [ssloy/tinyrenderer](https://github.com/ssloy/tinyrenderer) | 24.5k | Write a software rasterizer in about 500 lines and see what the GPU does for you. |
| [id-Software/DOOM](https://github.com/id-Software/DOOM) | 19.9k | Original 1993 DOOM source. |
| [miloyip/game-programmer](https://github.com/miloyip/game-programmer) | 18.7k | A study path for game programmers, as a chart of books. |
| [JoeyDeVries/LearnOpenGL](https://github.com/JoeyDeVries/LearnOpenGL) | 12.7k | Code for learnopengl.com, the most widely used OpenGL tutorial. |
| [RayTracing/raytracing.github.io](https://github.com/RayTracing/raytracing.github.io) | 10.7k | The "Ray Tracing in One Weekend" book series. |
| [id-Software/Quake](https://github.com/id-Software/Quake) | 6.1k | Quake source: BSP, PVS and the networking model that shaped multiplayer games. |
| [ssloy/tinyraytracer](https://github.com/ssloy/tinyraytracer) | 5.4k | A ray tracer in about 250 lines of C++. |

## Other curated lists

| Repository | ★ | Why it is here |
|---|---:|---|
| [ellisonleao/magictools](https://github.com/ellisonleao/magictools) | 17.8k | Large list of game development resources and tools. |
| [Kavex/GameDev-Resources](https://github.com/Kavex/GameDev-Resources) | 7.2k | Another broad list, strong on art and audio assets. |

## Outside GitHub

Not on GitHub, or not public there, but part of the everyday toolset:

- **Unreal Engine source.** It sits in a private GitHub organization. Link your GitHub account to your Epic Games account to get access: <https://www.unrealengine.com/en-US/ue-on-github>
- **NVIDIA Nsight Graphics and Nsight Systems.** GPU frame debugging and system-wide profiling: <https://developer.nvidia.com/nsight-graphics>
- **Shadertoy.** Thousands of shaders to read and experiment with in the browser: <https://www.shadertoy.com>
- **GPU Gems** (free online from NVIDIA): <https://developer.nvidia.com/gpugems/gpugems/foreword>

## Windows workstation setup

[`setup/windows/setup.ps1`](setup/windows/setup.ps1) turns a Windows PC into a game development workstation in one run:

- **Toolchain:** Visual Studio 2022 with the C++ game and desktop workloads, Git with LFS, GitHub CLI, CMake, Ninja, LLVM/Clang, Python, PowerShell 7
- **Editors and engines:** VS Code, Rider, Epic Games Launcher (Unreal Engine), Godot, Unity Hub
- **GPU and profiling:** RenderDoc, PIX, Tracy
- **Content:** Blender, Krita, Audacity, OBS Studio
- **Windows settings:** Developer Mode, long paths, visible file extensions, a `C:\dev` workspace excluded from Defender scanning, High performance power plan
- **Git and GitHub:** sensible defaults, an SSH key in the Windows ssh-agent, SSH-signed commits (tested before they are switched on), key uploaded to GitHub for sign-in and signing

It skips anything already installed, so it is safe to run again. CI parses it, runs PSScriptAnalyzer, dry-runs it on Windows and checks every package Id against the winget catalog each week.

Open PowerShell with **Run as administrator**, then download the script:

```powershell
Invoke-WebRequest https://raw.githubusercontent.com/barisdoguy/gamedev-resources/main/setup/windows/setup.ps1 -OutFile $env:TEMP\setup.ps1 -UseBasicParsing
```

See the plan without changing anything:

```powershell
powershell -ExecutionPolicy Bypass -File $env:TEMP\setup.ps1 -DryRun
```

Run it (use your own name and your GitHub noreply email from <https://github.com/settings/emails>):

```powershell
powershell -ExecutionPolicy Bypass -File $env:TEMP\setup.ps1 -GitName "Your Name" -GitEmail "12345+you@users.noreply.github.com"
```

Leave groups out with `-Skip`, for example `-Skip Engines,Art`. Available groups: `VisualStudio`, `Editors`, `Engines`, `GraphicsTools`, `Art`, `Utilities`, `WindowsSettings`, `DefenderExclusion`, `PowerPlan`, `GitHub`. A log is written to `%USERPROFILE%\gamedev-setup.log`.

## Star the whole list

Stars are GitHub's bookmarks. Starring these repositories keeps them in your account's Stars tab, and you get their release notifications if you choose to.

Forking every popular repository is not recommended. Forks fill your profile with copies of other people's work and are not updated automatically. Fork only when you plan to change something.

With the [GitHub CLI](https://cli.github.com/) installed and signed in (`gh auth login`), preview first:

```bash
./scripts/star-all.sh --dry-run
```

Then star them all:

```bash
./scripts/star-all.sh
```

The script reads repositories straight from the tables in this README, so the list and the script never drift apart.

## Contributing

Suggestions are welcome as pull requests. An entry should be actively maintained or historically important, and its note should say what you would use it for.
