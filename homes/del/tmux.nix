_: {
  programs.tmux = {
    enable = true;
    extraConfig = ''
      unbind-key a
      unbind-key C-a
      bind-key a send-prefix
      bind-key C-a last-window
    '';
    historyLimit = 10000;
    keyMode = "vi";
    prefix = "C-a";
  };
}
