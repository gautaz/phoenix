{pkgs, ...}: {
  home = {
    packages = with pkgs; [
      awscli2
      docker-compose
    ];
    sessionVariables = {
      COMPOSE_PROGRESS = "plain";
    };
  };
}
