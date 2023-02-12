{
  config,
  pkgs,
  ...
}: let
  mkSymlink = config.lib.file.mkOutOfStoreSymlink;
in {
  home = {
    file.".config/pass-git-helper/git-pass-mapping.ini".source = mkSymlink "/run/secrets/git/passGitHelper";
    packages = with pkgs; [
      pass-git-helper
    ];
  };

  programs.git = {
    aliases = {
      conflicts = "diff --name-only --diff-filter=U";
      ignore = "!gi() { curl -L -s https://www.gitignore.io/api/$@ ;}; gi";
      tree = "log --all --decorate --oneline --graph";
    };
    enable = true;
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
    lfs.enable = true;
  };
}
