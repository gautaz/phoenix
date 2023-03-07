{pkgs, ...}: {
  imports = [
    ./alacritty.nix
    ./bash.nix
    ./feh.nix
    ./git.nix
    ./gpg.nix
    ./neovim.nix
    ./outctl.nix
    ./passage.nix
    ./qutebrowser.nix
    ./readline.nix
    ./rofi.nix
    ./screen-locker.nix
    ./ssh.nix
    ./tmux.nix
    ./xmobar.nix
    ./xsession.nix
    ./zathura.nix
  ];

  home = {
    homeDirectory = "/home/del";
    packages = with pkgs; [
      age # used as the main encryption tool
      arandr # used to manually set the displays layout
      libnotify # provides notify-send to test dunst
      pavucontrol # used to set the audio mixer settings
    ];
    sessionPath = ["$HOME/.local/bin"];
    stateVersion = "22.11";
    username = "del";
  };

  programs = {
    home-manager.enable = true;
    starship.enable = true;
  };

  services = {
    dunst.enable = true;
    udiskie.enable = true;
  };
}
