_: {
  virtualisation = {
    containers = {
      containersConf.settings = {
        engine.compose_warning_logs = false;
      };
      enable = true;
    };

    podman = {
      enable = true;
      dockerCompat = true;
      defaultNetwork.settings.dns_enabled = true;
    };
  };
}
