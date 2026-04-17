{
  config,
  pkgs,
  ...
}: let
  delta = "${pkgs.delta}/bin/delta";
  mkSymlink = config.lib.file.mkOutOfStoreSymlink;
in {
  home = {
    file.".config/pass-git-helper/git-pass-mapping.ini".source = mkSymlink "/run/secrets/git/passGitHelper";
  };

  programs.git = {
    enable = true;
    ignores = [
      ".harper.dictionary"
    ];
    includes = [
      {
        path = mkSymlink "/run/secrets/git/profilesInclude";
      }
    ];
    lfs.enable = true;
    settings = {
      alias = {
        # Audit aliases come from https://piechowski.io/post/git-commands-before-reading-code/
        audit-bugs = "!git log -i -E --grep='fix|bug|broken' --name-only --format='' | sort | uniq -c | sort -nr | head -20";
        audit-changes = "!git log --format=format: --name-only --since='1 year ago' | sort | uniq -c | sort -nr | head -20";
        audit-hotfix = "!git log --oneline --since='1 year ago' | grep -iE 'revert|hotfix|emergency|rollback'";
        audit-velocity = "!git log --format='%ad' --date=format:'%Y-%m' | sort | uniq -c";
        audit-who = "shortlog -sn --no-merges";
        conflicts = "diff --name-only --diff-filter=U";
        ignore = "!gi() { curl -L -s \"https://www.gitignore.io/api/$(IFS=,; echo \"$*\")\" ;}; gi";
        tree = "log --all --decorate --oneline --graph";
      };
      core.pager = delta;
      credential.helper = "${pkgs.pass-git-helper}/bin/pass-git-helper";
      delta = {
        navigate = true;
        light = true;
      };
      init = {
        defaultBranch = "main";
      };
      interactive.diffFilter = "${delta} --color-only";
      merge.conflictStyle = "zdiff3";
      user.useConfigOnly = true;
    };
    signing.format = "openpgp";
  };
}
