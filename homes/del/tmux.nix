_: {
  programs = {
    tmux = {
      enable = true;
      extraConfig = ''
        # sending prefix is less common than switching to last window
        unbind-key a
        unbind-key C-a
        bind-key a send-prefix
        bind-key C-a last-window

        # _ and | for terminal splits
        unbind \"
        unbind %
        bind-key _ split-window -v
        bind-key | split-window -h

        # ensure truecolor
        # https://github.com/alacritty/alacritty/issues/109
        set-option -sa terminal-overrides ',alacritty:RGB'

        set-option -g copy-mode-match-style bg=#848484,fg=#bebe24
        set-option -g copy-mode-current-match-style bg=#000000,fg=#ffff42
        set-option -g message-style bg=#550055,fg=#ffffff
        set-option -g mode-style bg=#550055,fg=#ffffff
        set-option -g status-style bg=#424242,fg=#bebebe

        set-option -g status-left ""
        set-option -g status-justify left
        set-option -g status-right " #S"
      '';
      # alacritty sends escape sequences in less than 10ms
      # https://unix.stackexchange.com/questions/608142/whats-the-effect-of-escape-time-in-tmux
      escapeTime = 10;
      historyLimit = 10000;
      keyMode = "vi";
      prefix = "C-a";
      terminal = "tmux-256color";
    };

    bash.initExtra = ''
      ns() {
        local cwd='~'
        [ "$PWD" != "$HOME" ] && cwd="''${PWD/#$HOME\//\~\/}"
        local sessionname="$(tac -s / <<< "$cwd" | tr -s '/\n' '^' | tr '.' '_')"

        if [[ -z "$TMUX" ]]; then
          tmux new-session -A -s "$sessionname"
        else
          if ! tmux has-session -t "$sessionname"; then
            tmux new-session -d -s "$sessionname"
            echo "new session created: $sessionname"
          fi
          tmux switch-client -t "$sessionname"
        fi
      }
    '';
  };
}
