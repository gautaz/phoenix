---@diagnostic disable-next-line: undefined-global
local w = wezterm

return {
  audible_bell = "Disabled",
  color_scheme = "catppuccin-latte",
  default_cursor_style = "BlinkingBlock",
  disable_default_key_bindings = true,
  enable_tab_bar = false,
  font = w.font({
    family = "MonaspiceNe Nerd Font",
    harfbuzz_features = {
      "ss01=1",
      "ss02=1",
      "ss03=1",
      "ss04=1",
      "ss05=1",
      "ss06=1",
      "ss07=1",
      "ss08=1",
      "ss09=1",
      "ss10=1",
    },
  }),
  font_size = 12.0,
  keys = {
    { key='0', mods='CTRL', action=w.action.ResetFontSize },
    { key='-', mods='CTRL', action=w.action.DecreaseFontSize },
    { key='=', mods='CTRL', action=w.action.IncreaseFontSize },
    { key='C', mods='CTRL|SHIFT', action=w.action.CopyTo 'Clipboard' },
    { key='V', mods='CTRL|SHIFT', action=w.action.PasteFrom 'Clipboard' },
    { key='R', mods='CTRL|SHIFT', action=w.action.ReloadConfiguration },
    { key='L', mods='CTRL|SHIFT', action=w.action.ShowDebugOverlay },
    { key='B', mods='CTRL|SHIFT', action=w.action.ScrollByPage(-1) },
    { key='F', mods='CTRL|SHIFT', action=w.action.ScrollByPage(1) },
  },
  mouse_bindings = {
    table.unpack(w.permute_any_or_no_mods({
      event = { Down = { streak = 1, button = { WheelUp = 1 } } },
      action = w.action.Nop,
    })),
    table.unpack(w.permute_any_or_no_mods({
      event = { Down = { streak = 1, button = { WheelDown = 1 } } },
      action = w.action.Nop,
    })),
  },
  visual_bell = {
    fade_in_duration_ms = 75,
    fade_out_duration_ms = 75,
  }
}
