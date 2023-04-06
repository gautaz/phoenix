_: {
  programs.tmux = {
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

      # alacritty sends escape sequences in less than 10ms
      # https://unix.stackexchange.com/questions/608142/whats-the-effect-of-escape-time-in-tmux
      set-option -sg escape-time 10
    '';
    historyLimit = 10000;
    keyMode = "vi";
    prefix = "C-a";
    terminal = "tmux-256color";
  };
}
