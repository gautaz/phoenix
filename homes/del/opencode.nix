{pkgs, ...}: {
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
      ];
      text = builtins.readFile ./opencode-bwrap.bash;
    };
    settings = {
      autoupdate = false;
      enabled_providers = [
        "opencode"
        "ollama_cloud"
      ];
      permission = {
        "*" = "allow";
        external_directory = {
          "*" = "allow";
        };
      };
      provider = {
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
