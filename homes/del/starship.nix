_: {
  programs.starship = {
    enable = true;
    settings.git_status = {
      # These defaults are overloaded because the two first default characters are missing from the main font:
      # ❯ wezterm ls-fonts --text '⇡⇣⇕'
      #  0 ⇡    \u{21e1}     x_adv=10 cells=1  glyph=upwardsdashedarrow,402  wezterm.font("B612 Mono", {weight="Regular", stretch="Normal", style="Normal"})
      #  3 ⇣    \u{21e3}     x_adv=10 cells=1  glyph=downwardsdashedarrow,404  wezterm.font("B612 Mono", {weight="Regular", stretch="Normal", style="Normal"})
      #  6 ⇕    \u{21d5}     x_adv=10 cells=1  glyph=uni21D5,1052 wezterm.font("MonaspiceNe Nerd Font", {weight="Regular", stretch="Normal", style="Normal"})
      ahead = "󰜷";
      behind = "󰜮";
      diverged = "󰹺";
    };
  };
}
