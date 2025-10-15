{
  description = "Everything to restart from scratch: install media, OS, user environment";

  inputs = {
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixpkgs.url = "github:gautaz/nixpkgs/xrandr-invert-colors-fix";
    sops-nix.url = "github:Mic92/sops-nix/master";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs: let
    inherit (inputs.home-manager.lib) homeManagerConfiguration;
    inherit (inputs.nixpkgs.lib) nixosSystem;

    # See https://discourse.nixos.org/t/do-flakes-also-set-the-system-channel/19798
    channels = {
      path = "/etc/nixpkgs/channels";
      nixpkgsPath = "${channels.path}/nixpkgs";
    };

    hardware = inputs.nixos-hardware.nixosModules;

    homeConfigurations = {
      homestation = homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./homes/del
          {
            home = {
              inherit stateVersion;
            };
          }
        ];
      };

      workstation = homeManagerConfiguration {
        inherit pkgs;
        modules = [
          ./homes/del
          ./homes/del/work
          {
            home = {
              inherit stateVersion;
            };
          }
        ];
      };
    };

    hosts = import ./hosts;

    modules = {
      dellLaptopHardware = [
        hardware.common-cpu-intel
        hardware.common-gpu-nvidia
        hardware.common-pc-laptop
        hardware.common-pc-laptop-ssd
      ];
      workstation = [
        inputs.sops-nix.nixosModules.sops
        nixChannelsConfig
      ];
    };

    nixChannelsConfig = {
      nix.nixPath = [
        "nixpkgs=${channels.nixpkgsPath}"
        "/nix/var/nix/profiles/per-user/root/channels"
      ];
      system = {
        inherit stateVersion;
      };
      systemd.tmpfiles.rules = [
        "L+ ${channels.nixpkgsPath} - - - - ${pkgs.path}"
      ];
    };

    pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
    };

    system = "x86_64-linux";
    stateVersion = "23.11";
  in {
    homeConfigurations = {
      del = homeConfigurations.homestation;
      "del@hepao" = homeConfigurations.workstation;
      "del@dante" = homeConfigurations.workstation;
      "del@abelard" = homeConfigurations.workstation;
    };

    nixosConfigurations = {
      abelard = nixosSystem {
        inherit system;
        modules =
          [
            hosts.abelard
          ]
          ++ modules.dellLaptopHardware
          ++ modules.workstation;
      };

      dante = nixosSystem {
        inherit system;
        modules =
          [
            hosts.dante
          ]
          ++ modules.dellLaptopHardware
          ++ modules.workstation;
      };

      echidna = nixosSystem {
        modules = [
          {imports = [./cross-build-aarch64.nix];}
          "${inputs.nixpkgs}/nixos/modules/installer/sd-card/sd-image-aarch64.nix"
          hosts.echidna
          nixChannelsConfig
        ];
      };

      hepao = nixosSystem {
        inherit system;
        modules =
          [
            hardware.framework-12th-gen-intel
            hosts.hepao
          ]
          ++ modules.workstation;
      };

      installMedia = nixosSystem {
        inherit system;
        modules = [
          {imports = [./install-media];}
          "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/channel.nix"
          nixChannelsConfig
        ];
      };

      kusanagi = nixosSystem {
        inherit system;
        modules =
          [
            hosts.kusanagi
          ]
          ++ modules.workstation;
      };

      testbox = nixosSystem {
        inherit system;
        modules = [
          hosts.testbox
          nixChannelsConfig
        ];
      };
    };
  };
}
