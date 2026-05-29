{pkgs, ...}: {
  programs.opencode = {
    enable = true;
    package = pkgs.opencode;
    settings = {
      autoupdate = false;
      model = "opencode/big-pickle";
      permission.external_directory = {
        "*" = "ask";
        "/nix/store/**" = "allow";
      };
    };
  };
}
