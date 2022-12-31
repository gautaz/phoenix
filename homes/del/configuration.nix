{
  config,
  pkgs,
  ...
}: {
  imports = [./bash.nix ./neovim.nix ./readline.nix ./screen.nix];

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

  xsession = {
    enable = true;

    windowManager.xmonad = {
      enable = true;
      config = ./xmonad.hs;
    };
  };
}
