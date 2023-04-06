_: {
  programs.tmux = {
    enable = true;
    extraConfig = ''
      unbind-key a
      unbind-key C-a
      bind-key a send-prefix
      bind-key C-a last-window
      unbind \"
      unbind %
      bind-key _ split-window -v
      bind-key | split-window -h
      set-option -sa terminal-overrides ',alacritty:RGB'
      set-option -sg escape-time 10
    '';
    historyLimit = 10000;
    keyMode = "vi";
    prefix = "C-a";
    terminal = "tmux-256color";
  };
}
