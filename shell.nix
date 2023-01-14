{pkgs ? import <nixpkgs> {}}:
with pkgs;
with builtins; let
  phoenixBuild = writeShellApplication {
    name = "phx-build";
    text = readFile ./shell/build.bash;
  };
  phoenixLintFmt = writeShellApplication {
    name = "phx-lint-fmt";
    text = readFile ./shell/lintfmt.bash;
  };
  phoenixMount = writeShellApplication {
    name = "phx-mount";
    text = readFile ./shell/mount.bash;
  };
  phoenixTest = writeShellApplication {
    name = "phx-test";
    text = readFile ./shell/test.bash;
  };
  phoenixTestBuild = writeShellApplication {
    name = "phx-test-build";
    text = readFile ./shell/test-build.bash;
  };
  phoenixUmount = writeShellApplication {
    name = "phx-umount";
    text = readFile ./shell/mount.bash;
  };
in
  pkgs.mkShell {
    name = "phoenix";
    packages = [
      OVMF
      age
      alejandra
      cacert
      cryptsetup
      git
      git-lfs
      haskellPackages.hindent
      haskellPackages.hlint
      home-manager
      kmod
      less
      mount
      nix
      nixos-rebuild
      phoenixBuild
      phoenixLintFmt
      phoenixMount
      phoenixTest
      phoenixTestBuild
      phoenixUmount
      qemu
      sops
      ssh-to-age
      statix
      umount
    ];
    shellHook = ''
      alias sudo=/run/wrappers/bin/sudo
      phx-lint-fmt install
    '';
  }
