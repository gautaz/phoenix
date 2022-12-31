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
  phoenixUmount = writeShellApplication {
    name = "phx-umount";
    text = readFile ./shell/mount.bash;
  };
in
  pkgs.mkShell {
    name = "phoenix";
    packages = [
      alejandra
      cryptsetup
      git
      git-lfs
      haskellPackages.hindent
      haskellPackages.hlint
      less
      kmod
      mount
      nix
      OVMF
      phoenixBuild
      phoenixLintFmt
      phoenixMount
      phoenixTest
      phoenixUmount
      qemu
      statix
      umount
    ];
    shellHook = ''
      alias sudo=/run/wrappers/bin/sudo
      phx-lint-fmt install
    '';
  }
