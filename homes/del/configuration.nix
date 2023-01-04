{
  config,
  pkgs,
  ...
}: {
  imports = [./alacritty.nix ./bash.nix ./neovim.nix ./readline.nix ./rofi.nix ./screen.nix ./screen-locker.nix ./xmobar.nix ./xsession.nix];

  home = {
    username = "del";
    homeDirectory = "/home/del";
    sessionVariables = {EDITOR = "vim";};
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
