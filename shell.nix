{pkgs ? import <nixpkgs> {}}:
with pkgs;
with builtins; let
  nimBuild = writeShellApplication {
    name = "nim-build";
    text = readFile ./shell/build.bash;
  };
  nimMount = writeShellApplication {
    name = "nim-mount";
    text = readFile ./shell/mount.bash;
  };
  nimTest = writeShellApplication {
    name = "nim-test";
    text = readFile ./shell/test.bash;
  };
  nimUmount = writeShellApplication {
    name = "nim-umount";
    text = readFile ./shell/mount.bash;
  };
  nixLintFmt = writeShellApplication {
    name = "nix-lint-fmt";
    text = readFile ./shell/lintfmt.bash;
  };
in
  pkgs.mkShell {
    name = "NIM-shell";
    packages = [
      alejandra
      cryptsetup
      git
      git-lfs
      less
      kmod
      mount
      nimBuild
      nimMount
      nimTest
      nimUmount
      nix
      nixLintFmt
      OVMF
      qemu
      statix
      umount
    ];
    shellHook = ''
      alias sudo=/run/wrappers/bin/sudo
      nix-lint-fmt install
    '';
  }
