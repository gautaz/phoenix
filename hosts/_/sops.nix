{config, ...}: {
  sops = {
    defaultSopsFile = ./sops.yaml;
    age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
    secrets."ssh/config/work" = {
      owner = config.users.users.del.name;
      group = config.users.groups.keys.name;
    };
  };
}
