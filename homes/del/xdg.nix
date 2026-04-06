_: {
  xdg = {
    enable = true;
    userDirs = {
      enable = true;
      # The following is currently necessary because of:
      # - homes/del/_/outctl.bash
      # - homes/del/rofi-script-youtube.sh
      # These scripts should use `xdg-user-dir` or `$XDG_CONFIG_HOME/user-dirs.dirs` instead.
      setSessionVariables = true;
    };
  };
}
