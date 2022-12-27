{
  description = "Flake for building a custom NixOS installation media image";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
  };
  outputs = { self, nixpkgs }: {
    installMedia = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        {
          imports = [ ./modules ];
        }
        "${nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
      ];
    };
  };
}
