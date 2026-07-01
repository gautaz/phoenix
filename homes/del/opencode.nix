{pkgs, ...}: let
  opencode-bwrap-podman-proxy = pkgs.buildGoModule {
    name = "opencode-bwrap-podman-proxy";
    src = ./opencode-bwrap-podman-proxy;
    vendorHash = null;
  };
in {
  programs.opencode = {
    enable = true;
    package = pkgs.writeShellApplication {
      name = "opencode";
      runtimeInputs = with pkgs; [
        betterleaks
        bubblewrap
        coreutils
        gawk
        opencode
        opencode-bwrap-podman-proxy
      ];
      text = builtins.readFile ./opencode-bwrap.bash;
    };
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
