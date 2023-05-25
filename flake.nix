{
  description = "Everything to restart from scratch: install media, OS, user environment";
  inputs = {
    csharp-ls.url = "github:gautaz/csharp-ls-nix/main";
    csharp-ls.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixpkgs.url = "github:nixos/nixpkgs/master";
    sops-nix.url = "github:Mic92/sops-nix/master";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };
  outputs = {self, ...} @ inputs: let
    inherit (inputs.home-manager.lib) homeManagerConfiguration;
    inherit (inputs.nixpkgs.lib) nixosSystem;
    hardware = inputs.nixos-hardware.nixosModules;
    hosts = import ./hosts;
    pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [
        (_: _: {csharp-ls = inputs.csharp-ls.packages.${system}.default;})
      ];
    };
    system = "x86_64-linux";
  in {
    homeConfigurations = {
      del = homeManagerConfiguration {
        inherit pkgs;
        modules = [./homes/del/configuration.nix];
      };
    };

    installMedia = nixosSystem {
      inherit system;
      modules = [
        {imports = [./install-media];}
        "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
      ];
    };

    nixosConfigurations = {
      dante = nixosSystem {
        inherit system;
        modules = [
          hardware.common-cpu-intel
          hardware.common-gpu-intel
          hardware.common-gpu-nvidia
          hardware.common-pc-laptop
          hardware.common-pc-laptop-ssd
          hosts.dante
          inputs.sops-nix.nixosModules.sops
        ];
      };

      hepao = nixosSystem {
        inherit system;
        modules = [hardware.framework-12th-gen-intel hosts.hepao inputs.sops-nix.nixosModules.sops];
      };

      kusanagi = nixosSystem {
        inherit system;
        modules = [hosts.kusanagi inputs.sops-nix.nixosModules.sops];
      };

      testbox = nixosSystem {
        inherit system;
        modules = [hosts.testbox];
      };
    };
  };
}
