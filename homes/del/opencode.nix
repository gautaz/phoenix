{
  pkgs,
  agent-isle,
  ...
}: let
  agentIslePkg = agent-isle.packages.${pkgs.system}.mkAgentIsle {
    agents = {
      inherit (pkgs) opencode;
    };
    maskedAgents = ["opencode"];
  };

  rtkPlugin =
    pkgs.runCommand "rtk-opencode-plugin" {
      src = pkgs.fetchFromGitHub {
        owner = "rtk-ai";
        repo = "rtk";
        rev = "v${pkgs.lib.getVersion pkgs.rtk}";
        hash = "sha256-n5bkPPsrdM4fE5ltocTjlq+JwRgp39yib6S79fci4m4=";
      };
    } ''
      mkdir -p "$out"
      cp "$src/hooks/opencode/rtk.ts" "$out/rtk.ts"
    '';
in {
  home.packages = [agentIslePkg pkgs.rtk];

  xdg.configFile = {
    "agent-isle/config.yml".source = ./agent-isle.yaml;
    "opencode/plugins/rtk.ts".source = "${rtkPlugin}/rtk.ts";
  };

  programs.opencode = {
    enable = true;
    package = agentIslePkg;
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
