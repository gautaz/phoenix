{
  lib,
  pkgs,
  ...
}: {
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
  # https://github.com/nix-community/home-manager/issues/9114
  home.activation.enablePodmanSocket = lib.hm.dag.entryAfter ["writeBoundary"] ''
    $DRY_RUN_CMD mkdir -p "$HOME/.config/systemd/user/sockets.target.wants"
    $DRY_RUN_CMD ln -sfv "$HOME/.nix-profile/share/systemd/user/podman.socket" \
      "$HOME/.config/systemd/user/sockets.target.wants/podman.socket"
    $DRY_RUN_CMD "${pkgs.systemd}/bin/systemctl" --user daemon-reload || true
  '';
}
