_: {
  programs.tmux = {
    enable = true;
    extraConfig = ''
      unbind-key a
      unbind-key C-a
      bind-key a send-prefix
      bind-key C-a last-window
      set-option -sa terminal-overrides ',alacritty:RGB'
      set-option -sg escape-time 10
    '';
    historyLimit = 10000;
    keyMode = "vi";
    prefix = "C-a";
    terminal = "tmux-256color";
  };
}
