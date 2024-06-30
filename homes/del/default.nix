{pkgs, ...}: {
  imports = [
    ./alacritty.nix
    ./bash.nix
    ./dunst.nix
    ./feh.nix
    ./flameshot.nix
    ./fzf.nix
    ./git.nix
    ./gpg.nix
    ./inputplug.nix
    ./interview.nix
    ./neovim.nix
    ./passage.nix
    ./qutebrowser.nix
    ./readline.nix
    ./rofi.nix
    ./screen-locker.nix
    ./ssh.nix
    ./tmux.nix
    ./xmobar.nix
    ./xsession.nix
    ./vscode.nix
    ./zathura.nix
  ];

  home = {
    homeDirectory = "/home/del";
    packages = with pkgs; [
      age # used as the main encryption tool
      arandr # used to manually set the displays layout
      find-cursor # way to find the mouse pointer
      libnotify # provides notify-send to test dunst
      pavucontrol # used to set the audio mixer settings
    ];
    sessionPath = ["$HOME/.local/bin"];
    sessionVariables = {
      # https://wiki.haskell.org/Xmonad/Frequently_asked_questions#Problems_with_Java_applications.2C_Applet_java_console
      _JAVA_AWT_WM_NONREPARENTING = "1";
    };
    username = "del";
  };

  programs = {
    home-manager.enable = true;
    starship.enable = true;
  };

  services = {
    udiskie.enable = true;
  };
}
