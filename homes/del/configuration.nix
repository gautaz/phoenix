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
  pinentryRofi = pkgs.writeShellApplication {
    name = "pinentry-rofi-with-env";
    text = ''
      PATH="$PATH:${pkgs.coreutils}/bin:${pkgs.rofi}/bin"
      "${pkgs.pinentry-rofi}/bin/pinentry-rofi" "$@"
    '';
  };
  # language servers used by neovim.nix
  languageServers = with pkgs; [nil];
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
    ./ssh.nix
    ./tmux.nix
    ./xmobar.nix
    ./xsession.nix
  ];

  fonts.fontconfig.enable = true;

  home = {
    file = {
      ".gnupg/private-keys-v1.d".source = mkSymlink "/run/secrets/gpg/keys";
      ".local/bin/pass".source = "${pkgs.passage}/bin/passage";
      ".passage/identities".source = mkSymlink "/run/secrets/passage/identities";
    };
    homeDirectory = "/home/del";
    packages = with pkgs;
      [
        (nerdfonts.override {fonts = ["UbuntuMono"];}) # used by alacritty.nix
        age # used as the main encryption tool
        arandr # used to manually set the displays layout
        libnotify # provides notify-send to test dunst
        pass-git-helper # used by git.nix
        passage # used instead of pass as the password manager
        passageBootstrap # ensure passage has access to the password store
        pinentry-rofi
        pinentryRofi
        tree # used by passage to list secrets
        xclip # used by neovim to access X11 clipboard
        xsecurelock # used by screen-locker.nix
      ]
      ++ languageServers;
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

  services.gpg-agent = {
    enable = true;
    extraConfig = ''
      pinentry-program ${pinentryRofi}/bin/pinentry-rofi-with-env
    '';
    pinentryFlavor = null;
  };
}
