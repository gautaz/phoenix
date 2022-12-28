{
  description = "Everything to restart from scratch: install media, OS, user environment";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
  };
  outputs = { self, nixpkgs }:
  let
    system = "x86_64-linux";
    lib = nixpkgs.lib;
  in {
    installMedia = lib.nixosSystem {
      inherit system;
      modules = [
        { imports = [ ./install-media ]; }
        "${nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
      ];
    };
    nixosConfigurations = {
      testbox = lib.nixosSystem {
        inherit system;
        modules = [
          ./hosts/testbox/configuration.nix
        ];
      };

      kusanagi = lib.nixosSystem {
        inherit system;
        modules = [
          ./hosts/kusanagi/configuration.nix
        ];
      };
    };
  };
}
