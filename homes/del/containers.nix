{pkgs, ...}: {
  home = {
    file.".local/bin/docker".source = "${pkgs.podman}/bin/podman";
    packages = with pkgs; [
      docker-compose
      regctl
      skopeo
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
