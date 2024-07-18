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

        # use HJKL for pane navigation & co
        bind h select-pane -L
        bind j select-pane -D
        bind k select-pane -U
        bind l select-pane -R
        bind H swap-pane -s '{left-of}'
        bind J swap-pane -s '{down-of}'
        bind K swap-pane -s '{up-of}'
        bind L swap-pane -s '{right-of}'
        bind C-h resize-pane -L 5
        bind C-j resize-pane -D 5
        bind C-k resize-pane -U 5
        bind C-l resize-pane -R 5

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
      _ts_completion() {
        mapfile -t COMPREPLY < <( tmux list-sessions -F "#{session_name}" -f "#{m:$2*,#{session_name}}" 2>/dev/null )
      }

      ts() {
        if [[ -n "$1" ]]; then
          if [[ -z "$TMUX" ]]; then
            tmux attach-session -t "$1"
          else
            tmux switch-client -t "$1"
          fi
          return
        fi

        local cwd='~'
        [ "$PWD" != "$HOME" ] && cwd="''${PWD/#$HOME\//\~\/}"
        local sessionname="$(tac -s / <<< "$cwd" | tr -s '/\n' '^' | tr '.' '_')"

        if [[ -z "$TMUX" ]]; then
          tmux new-session -A -s "$sessionname"
        else
          if ! tmux has-session -t "$sessionname"; then
            tmux new-session -d -s "$sessionname"
            echo "new session created: $sessionname"
            sleep 1 && tmux kill-window &
          fi
          tmux switch-client -t "$sessionname"
        fi
      }

      complete -F _ts_completion ts
    '';
  };
}
