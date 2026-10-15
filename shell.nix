# Build and launcher environment for Linux, including NixOS:
#   nix-shell --run 'BB_LTO=OFF BB_PGO=off bash build.sh'
#   nix-shell --run 'python3 launcher/uncharted_launcher.py'
{ pkgs ? import <nixpkgs> {} }:
pkgs.mkShell {
  packages = with pkgs; [
    # Compilers and tools. clang is what CMake uses for the probe and the GPU library; gcc is
    # the fallback the probe build looks for (it also finds a gcc wrapper in /nix/store).
    clang gcc gnumake cmake ninja pkg-config binutils git
    # Build scripts and the Tk launcher (tkinter, Pillow for the cover art).
    (python3.withPackages (ps: [ ps.tkinter ps.pillow ]))
    # Probe: window (SDL3), Vulkan loader, video decoding.
    vulkan-headers vulkan-loader sdl3 ffmpeg-headless
    # GPU library (gpu/): shadPS4 video core dependencies.
    boost fmt magic-enum robin-map xxhash vulkan-memory-allocator glslang spirv-cross xbyak
    zydis spirv-headers miniz nlohmann_json protobuf openssl zlib miniupnpc
    libx11 libxcb xorgproto wayland
  ];
}
