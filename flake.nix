{
  description = "Everything to restart from scratch: install media, OS, user environment";

  inputs = {
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    nixpkgs.url = "github:NixOS/nixpkgs/master";
    sops-nix.url = "github:Mic92/sops-nix/master";
    sops-nix.inputs.nixpkgs.follows = "nixpkgs";
    opencode-vim = {
      url = "github:leohenon/opencode-vim/ocv";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    opencode-nvim = {
      url = "github:sudo-tee/opencode.nvim";
      flake = false;
    };
  };

  outputs = inputs: let
    inherit (inputs.home-manager.lib) homeManagerConfiguration;
    inherit (inputs.nixpkgs.lib) nixosSystem;

    system = "x86_64-linux";
    stateVersion = "25.11";

    pkgs = import inputs.nixpkgs {
      inherit system;
      config.allowUnfree = true;
      overlays = [
        inputs.opencode-vim.overlays.default
        (final: prev: {
          opencode = prev.opencode.overrideAttrs (old: {
            postPatch =
              (old.postPatch or "")
              + ''
                substituteInPlace packages/script/src/index.ts \
                  --replace-fail 'throw new Error(`This script requires bun@''${expectedBunVersionRange}' \
                                 'console.warn(`Warning: This script requires bun@''${expectedBunVersionRange}'
              '';
          });
          vimPlugins =
            prev.vimPlugins
            // {
              opencode-nvim = prev.vimPlugins.opencode-nvim.overrideAttrs (_: {
                src = inputs.opencode-nvim;
                doCheck = false;
              });
            };
        })
      ];
    };

    # See https://discourse.nixos.org/t/do-flakes-also-set-the-system-channel/19798
    channels = {
      path = "/etc/nixpkgs/channels";
      nixpkgsPath = "${channels.path}/nixpkgs";
    };

    hardware = inputs.nixos-hardware.nixosModules;

    homeConfigurations = {
      workstation = homeManagerConfiguration {
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
    };

    hosts = import ./hosts;

    modules = {
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
  in {
    homeConfigurations = {
      del = homeConfigurations.workstation;
    };

    nixosConfigurations = {
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
