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
    packages = with pkgs; [libnotify screen xsecurelock];
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
