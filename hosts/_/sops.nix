{config, ...}: let
  delSecret = {
    owner = config.users.users.del.name;
    group = config.users.groups.keys.name;
  };
in {
  sops = {
    defaultSopsFile = ./sops.yaml;
    age.sshKeyPaths = ["/etc/ssh/ssh_host_ed25519_key"];
    secrets = {
      "git/profilesInclude" = delSecret;
      "git/profiles/github" = delSecret;
      "git/profiles/employer" = delSecret;
      "gpg/keys/15C501426314ED1962D8F43E67B9B2E632E667FC.key" = delSecret;
      "gpg/keys/D31D2622AAE7EB10A24E751DF63450A6B26CAAC9.key" = delSecret;
      "ssh/config/work" = delSecret;
    };
  };
}
