import XMonad (def, mod4Mask, modMask, spawn, terminal, xmonad)
import XMonad.Util.EZConfig (additionalKeysP)

main =
  xmonad $
  def {modMask = mod4Mask, terminal = "alacritty"} `additionalKeysP`
  [ ( "M-p"
    , spawn "rofi -show combi -modes combi -combi-modes 'window,drun,run'")
  ]
