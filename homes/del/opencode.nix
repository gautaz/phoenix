{pkgs, ...}: {
  programs.opencode = {
    enable = true;
    package = pkgs.writeShellApplication {
      name = "opencode";
      runtimeInputs = with pkgs; [
        bubblewrap
        gitleaks
        jq
        opencode
      ];
      text = builtins.readFile ./opencode-bwrap.bash;
    };
    settings = {
      autoupdate = false;
      model = "opencode/big-pickle";
      permission = {
        "*" = "allow";
        external_directory = {
          "*" = "allow";
        };
      };
    };
  };
}
