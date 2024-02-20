{pkgs, ...}: {
  home = {
    packages = with pkgs; [
      aws-sam-cli
      awscli2
      jira-cli-go
      mark
    ];
  };

  programs.chromium.enable = true;
}
