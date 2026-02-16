{pkgs, ...}: {
  imports = [
    ./alacritty.nix # terminal emulator
    ./bash.nix # POSIX shell
    ./dunst.nix # desktop notifications
    ./f3d.nix # CAD files viewer
    ./feh.nix # image viewer
    ./flameshot.nix # screen shots
    ./fzf.nix # multipurpose fuzzy finder
    ./fzf-git.nix # fuzzy finder / git integration
    ./git.nix # source control
    ./gpg.nix # Gnu pretty good privacy
    ./inputplug.nix # XInput monitoring
    ./interview.nix # custom file (pre)viewer
    ./mpd.nix # music player daemon
    ./mpv.nix # video player
    ./neovim.nix # more than a text editor
    ./passage.nix # password manager
    ./qutebrowser.nix # internet browser
    ./readline.nix # shell line editing configuration
    ./rofi.nix # more than an application launcher
    ./screen-locker.nix # graphical screen locker
    ./ssh.nix # secure shell
    ./tmux.nix # terminal multiplexer
    ./xdg.nix # X Desktop Group configuration
    ./xmobar.nix # status bar for xmonad
    ./xsession.nix # Graphical session management
    ./zathura.nix # document viewer
  ];

  home = {
    homeDirectory = "/home/del";
    packages = with pkgs; [
      age # used as the main encryption tool
      arandr # used to manually set the displays layout
      find-cursor # way to find the mouse pointer
      libnotify # provides notify-send to test dunst
      orca-slicer # 3D printer slicer
      pavucontrol # used to set the audio mixer settings
      tageditor # view/edit tags in MP3, Vorbis, ...
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
