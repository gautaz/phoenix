{
  config,
  pkgs,
  ...
}: let
  mkSymlink = config.lib.file.mkOutOfStoreSymlink;
  passageBootstrap = pkgs.writeShellApplication {
    name = "passage-bootstrap";
    text = builtins.readFile ./passage-bootstrap.bash;
  };
in {
  imports = [
    ./alacritty.nix
    ./bash.nix
    ./git.nix
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
    file = {
      ".gnupg/private-keys-v1.d".source = mkSymlink "/run/secrets/gpg/keys";
      ".local/bin/pass".source = "${pkgs.passage}/bin/passage";
      ".passage/identities".source = mkSymlink "/run/secrets/passage/identities";
    };
    homeDirectory = "/home/del";
    packages = with pkgs; [
      age # used as the main encryption tool
      libnotify # provides notify-send to test dunst
      pass-git-helper # needed by git.nix
      passage # will be used instead of pass as the password manager
      passageBootstrap # ensure passage has access to the password store
      screen # configured by screen.nix
      tree # needed by passage to list secrets
      xclip # needed by neovim to access X11 clipboard
      xsecurelock # needed by screen-locker.nix
    ];
    sessionPath = ["$HOME/.local/bin"];
    stateVersion = "22.11";
    username = "del";
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
