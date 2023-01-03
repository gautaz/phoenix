{
  config,
  pkgs,
  ...
}: {
  imports = [./bash.nix ./neovim.nix ./readline.nix ./rofi.nix ./screen.nix ./xmobar.nix ./xsession.nix];

  home = {
    username = "del";
    homeDirectory = "/home/del";
    sessionVariables = {EDITOR = "vim";};
    stateVersion = "22.05";
    packages = with pkgs; [libnotify screen];
  };

  programs = {
    alacritty.enable = true;
    home-manager.enable = true;
    qutebrowser.enable = true;
    starship.enable = true;
  };

  services = {
    dunst.enable = true;
  };
}
