{
  config,
  pkgs,
  ...
}: let
  mkSymlink = config.lib.file.mkOutOfStoreSymlink;
  pinentryRofi = pkgs.writeShellApplication {
    name = "pinentry-rofi-with-env";
    text = ''
      PATH="$PATH:${pkgs.coreutils}/bin:${pkgs.rofi}/bin"
      "${pkgs.pinentry-rofi}/bin/pinentry-rofi" "$@"
    '';
  };
in {
  home = {
    file = {
      ".gnupg/private-keys-v1.d".source = mkSymlink "/run/secrets/gpg/keys";
    };
    packages = with pkgs; [
      pinentry-rofi
      pinentryRofi
    ];
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
    extraConfig = ''
      pinentry-program ${pinentryRofi}/bin/pinentry-rofi-with-env
    '';
  };
}
