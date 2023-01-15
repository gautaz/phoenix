{
  config,
  pkgs,
  ...
}: let
  mkSymlink = config.lib.file.mkOutOfStoreSymlink;
in {
  imports = [
    ./alacritty.nix
    ./bash.nix
    ./git.nix
    ./gpg.nix
    ./neovim.nix
    ./readline.nix
    ./rofi.nix
    ./screen-locker.nix
    ./screen.nix
    ./ssh.nix
    ./xmobar.nix
    ./xsession.nix
  ];

  home = {
    file.".gnupg/private-keys-v1.d".source = mkSymlink "/run/secrets/gpg/keys";
    homeDirectory = "/home/del";
    packages = with pkgs; [
      libnotify # provides notify-send to test dunst
      screen # configured by screen.nix
      xclip # needed by neovim to access X11 clipboard
      xsecurelock # needed by screen-locker.nix
    ];
    stateVersion = "22.11";
    username = "del";
  };

  programs = {
    home-manager.enable = true;
    qutebrowser.enable = true;
    starship.enable = true;
  };

  services = {
    dunst.enable = true;
  };
}
