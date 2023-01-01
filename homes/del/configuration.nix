{
  config,
  pkgs,
  ...
}: {
  imports = [./bash.nix ./neovim.nix ./readline.nix ./rofi.nix ./screen.nix ./xsession.nix];

  home = {
    username = "del";
    homeDirectory = "/home/del";
    sessionVariables = {EDITOR = "vim";};
    stateVersion = "22.05";
    packages = with pkgs; [screen];
  };

  programs = {
    alacritty.enable = true;
    home-manager.enable = true;
    starship.enable = true;
  };
}
