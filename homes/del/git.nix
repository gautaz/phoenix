{
  config,
  pkgs,
  ...
}: let
  mkSymlink = config.lib.file.mkOutOfStoreSymlink;

  # Temporary fix to https://github.com/languitar/pass-git-helper/issues/387
  pass-git-helper = pkgs.pass-git-helper.overrideAttrs (finalAttrs: previousAttrs: rec {
    name = "pass-git-helper-${version}";
    version = "1.4.0";
    src = pkgs.fetchFromGitHub {
      owner = "languitar";
      repo = "pass-git-helper";
      rev = "refs/tags/v${version}";
      sha256 = "sha256-wkayj7SvT3SOM+rol17+8LQJR/YXSC6I+iKbHRUbdZc=";
    };
  });
in {
  home = {
    file.".config/pass-git-helper/git-pass-mapping.ini".source = mkSymlink "/run/secrets/git/passGitHelper";
  };

  programs.git = {
    aliases = {
      conflicts = "diff --name-only --diff-filter=U";
      ignore = "!gi() { curl -L -s https://www.gitignore.io/api/$@ ;}; gi";
      tree = "log --all --decorate --oneline --graph";
    };
    enable = true;
    extraConfig = {
      credential.helper = "${pass-git-helper}/bin/pass-git-helper";
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
