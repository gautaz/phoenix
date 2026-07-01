{pkgs, ...}: let
  opencode-bwrap = pkgs.buildGoModule {
    name = "opencode";
    src = ./opencode-bwrap;
    vendorHash = null;
    ldflags = [
      "-X main.bwrapPath=${pkgs.bubblewrap}/bin/bwrap"
      "-X main.betterleaksPath=${pkgs.betterleaks}/bin/betterleaks"
      "-X main.passPath=${pkgs.passage}/bin/passage"
      "-X main.opencodePath=${pkgs.opencode}/bin/opencode"
    ];
    postInstall = ''
      mv $out/bin/opencode-bwrap $out/bin/opencode
    '';
  };
in {
  programs.opencode = {
    enable = true;
    package = opencode-bwrap;
    settings = {
      autoupdate = false;
      enabled_providers = [
        "nvidia_build"
        "ollama_cloud"
        "opencode"
      ];
      permission = {
        "*" = "allow";
        external_directory = {
          "*" = "allow";
        };
      };
      provider = {
        nvidia_build = {
          models = {
            "minimaxai/minimax-m3".name = "minimax-m3";
            "minimaxai/minimax-m2.7".name = "minimax-m2.7";
          };
          name = "NVIDIA Build";
          options = {
            apiKey = "{env:NVIDIA_API_KEY}";
            baseURL = "https://integrate.api.nvidia.com/v1";
          };
        };
        ollama_cloud = {
          models = {
            "devstral-small-2:24b-cloud".name = "Devstral Small 2";
            "nemotron-3-nano:30b-cloud".name = "Nemotron 3 Nano";
          };
          name = "Ollama Cloud";
          options = {
            apiKey = "{env:OLLAMA_API_KEY}";
            baseURL = "https://ollama.com/v1";
          };
        };
      };
    };
  };
}
