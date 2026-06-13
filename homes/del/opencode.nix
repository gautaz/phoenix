{pkgs, ...}: let
  internal_permissions = {
    "*" = "allow";
    "*.env*" = "deny";
  };
in {
  programs.opencode = {
    enable = true;
    package = pkgs.writeShellApplication {
      name = "opencode";
      runtimeInputs = with pkgs; [
        bubblewrap
        opencode
      ];
      text = builtins.readFile ./opencode-bwrap.bash;
    };
    settings = {
      autoupdate = false;
      model = "opencode/big-pickle";
      permission = {
        "*" = "allow";
        bash = internal_permissions;
        edit = internal_permissions;
        external_directory = {
          "*" = "ask";
          "/nix/store/*" = "allow";
          "/tmp/*" = "allow";
        };
        glob = internal_permissions;
        grep = internal_permissions;
        read = internal_permissions;
      };
    };
  };
}
