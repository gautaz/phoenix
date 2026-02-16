_: {
  programs.mpv = {
    enable = true;
    config = {
      # avoid Vulkan warning
      vo = "gpu-next";
      gpu-api = "opengl";
    };
  };
}
