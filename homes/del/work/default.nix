{pkgs, ...}: {
  home = {
    file.".local/bin/docker".source = "${pkgs.podman}/bin/podman";
    packages = with pkgs; [
      awscli2
      docker-compose
    ];
    sessionVariables = {
      COMPOSE_PROGRESS = "plain";
    };
  };
  services.podman = {
    enable = true;
    settings.containers = {
      engine.compose_warning_logs = false;
    };
  };
}
