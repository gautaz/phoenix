{pkgs, ...}: {
  home = {
    packages = with pkgs; [
      aws-sam-cli
      awscli2
      docker-compose
      jira-cli-go
      mark
    ];
  };
}
