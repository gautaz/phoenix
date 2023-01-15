{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./alacritty.nix
    ./bash.nix
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
    file.".gnupg/private-keys-v1.d".source = config.lib.file.mkOutOfStoreSymlink "/run/secrets/gpg/keys";
    username = "del";
    homeDirectory = "/home/del";
    stateVersion = "22.11";
    packages = with pkgs; [
      libnotify # provides notify-send to test dunst
      screen # configured by screen.nix
      xclip # needed by neovim to access X11 clipboard
      xsecurelock # needed by screen-locker.nix
    ];
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
