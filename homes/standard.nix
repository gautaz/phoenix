{ config, pkgs, ... }: {
  home = {
    username = "del";
    homeDirectory = "/home/del";

    sessionVariables = { EDITOR = "vim"; };

    stateVersion = "22.05";

    packages = with pkgs; [ screen ];

    file.".screenrc".text = ''
      hardstatus alwayslastline
      hardstatus string '%{= kG}[%{G}%H%? %1`%?%{g}][%= %{= kw}%-w%{+b yk} %n*%t%?(%u)%? %{-}%+w %=%{g}][%{B}%Y-%m-%d %{W}%c%{g}]'

      defscrollback 10000
      startup_message off
      term screen-256color
      maptimeout 5
    '';
  };

  programs = {
    bash = {
      enable = true;
      enableVteIntegration = true;
      bashrcExtra = ''
        ns() {
        local cwd='~'
        [ "$PWD" != "$HOME" ] && cwd="''${PWD/#$HOME\//\~\/}"
        local sessionname="$(tac -s / <<< "$cwd" | tr -s '/\n' '@')"
        screen -d -m -S "$sessionname"
        echo "$sessionname"
        }

        na() {
        local sessionname="$(ns)"
        screen -r "$sessionname"
        }

        hs() {
        screen -r -d '~@' || (cd && na)
        }
      '';
      historyControl = [ "ignoredups" ];
    };

    home-manager.enable = true;

    neovim = {
      enable = true;
      viAlias = true;
      vimAlias = true;
      vimdiffAlias = true;
      plugins = with pkgs.vimPlugins; [ vim-polyglot ];
    };

    readline = {
      enable = true;
      variables = {
        editing-mode = "vi";
        match-hidden-files = "off";
      };
    };

    starship.enable = true;
  };
}
