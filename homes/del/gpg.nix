{
  config,
  pkgs,
  ...
}: let
  mkSymlink = config.lib.file.mkOutOfStoreSymlink;
  pinentryRofi = with pkgs;
    writeShellApplication {
      name = "pinentry-rofi-with-env";
      runtimeInputs = [
        pinentry-rofi
      ];
      text = ''
        PATH="$PATH:${coreutils}/bin:${rofi}/bin"
        "${pinentry-rofi}/bin/pinentry-rofi" "$@"
      '';
    };
in {
  home = {
    file = {
      ".gnupg/private-keys-v1.d".source = mkSymlink "/run/secrets/gpg/keys";
    };
  };

  programs.gpg = {
    enable = true;
    mutableKeys = false;
    mutableTrust = false;
    publicKeys = [
      {
        source = ./gautaz.pub;
        trust = "ultimate";
      }
    ];
  };

  services.gpg-agent = {
    enable = true;
    pinentryPackage = pinentryRofi;
  };
}
