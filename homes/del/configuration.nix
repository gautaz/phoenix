{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./alacritty.nix
    ./bash.nix
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
    username = "del";
    homeDirectory = "/home/del";
    stateVersion = "22.05";
    packages = with pkgs; [
      libnotify # provides notify-send to test dunst
      screen # configured by screen.nix
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
