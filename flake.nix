{
  description = "Everything to restart from scratch: install media, OS, user environment";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-22.11";
    home-manager.url = "github:nix-community/home-manager/release-22.11";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = {
    self,
    nixpkgs,
    home-manager,
  }: let
    inherit (home-manager.lib) homeManagerConfiguration;
    inherit (nixpkgs.lib) nixosSystem;
    pkgs = import nixpkgs {inherit system;};
    system = "x86_64-linux";
  in {
    installMedia = nixosSystem {
      inherit system;
      modules = [
        {imports = [./install-media];}
        "${nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
      ];
    };
    homeConfigurations = {
      standard = homeManagerConfiguration {
        inherit pkgs;
        modules = [./homes/standard.nix];
      };
    };
    nixosConfigurations = {
      testbox = nixosSystem {
        inherit system;
        modules = [./hosts/testbox/configuration.nix];
      };

      kusanagi = nixosSystem {
        inherit system;
        modules = [./hosts/kusanagi/configuration.nix];
      };
    };
  };
}
