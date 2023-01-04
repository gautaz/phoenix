import XMonad (def, mod4Mask, modMask, spawn, terminal, xmonad)
import XMonad.Hooks.StatusBar (defToggleStrutsKey, statusBarProp, withEasySB)
import XMonad.Hooks.StatusBar.PP (xmobarPP)
import XMonad.Util.EZConfig (additionalKeysP)

main :: IO ()
main = xmonad . withEasySB mySB defToggleStrutsKey $ myConfig

mySB = statusBarProp "xmobar" (pure xmobarPP)

myConfig =
  def {modMask = mod4Mask, terminal = "alacritty"} `additionalKeysP`
  [ ( "M-p"
    , spawn "rofi -show combi -modes combi -combi-modes 'window,drun,run'")
  , ("M-<Escape>", spawn "xsecurelock")
  ]
