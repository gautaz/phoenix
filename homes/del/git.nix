{
  config,
  pkgs,
  ...
}: let
  mkSymlink = config.lib.file.mkOutOfStoreSymlink;
in {
  home.file.".config/pass-git-helper/git-pass-mapping.ini".source = mkSymlink "/run/secrets/git/passGitHelper";

  programs.git = {
    enable = true;
    lfs.enable = true;
    extraConfig = {
      credential.helper = "${pkgs.pass-git-helper}/bin/pass-git-helper";
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
