{config, ...}: let
  mkSymlink = config.lib.file.mkOutOfStoreSymlink;
in {
  programs.git = {
    enable = true;
    lfs.enable = true;
    extraConfig = {
      init = {
        defaultBranch = "main";
      };
      user.useConfigOnly = true;
    };
    includes = [
      {
        path = mkSymlink "/run/secrets/git/profilesInclude";
      }
    ];
  };
}
