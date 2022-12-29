{ pkgs, modulesPath, ... }: {
  imports = [ "${modulesPath}/installer/cd-dvd/installation-cd-base.nix" ];

  isoImage = {
    edition = "minimal";
    contents = [{
      source = pkgs.writeText "README" ''
        The sources of this ISO image are located at https://github.com/gautaz/nixos-install-media.
        For detailed explanations, browse this URL to access the project README file.
      '';
      target = "/README.txt";
    }];
  };
}
