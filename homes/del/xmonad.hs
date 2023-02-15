import XMonad
  ( borderWidth
  , def
  , focusFollowsMouse
  , mod4Mask
  , modMask
  , spawn
  , terminal
  , xmonad
  )
import XMonad.Hooks.EwmhDesktops (ewmh, ewmhFullscreen)
import XMonad.Hooks.StatusBar (defToggleStrutsKey, statusBarProp, withEasySB)
import XMonad.Hooks.StatusBar.PP (xmobarPP)
import XMonad.Util.EZConfig (additionalKeysP)

main :: IO ()
main =
  xmonad . ewmhFullscreen . ewmh . withEasySB mySB defToggleStrutsKey $ myConfig

mySB = statusBarProp "xmobar" (pure xmobarPP)

myConfig =
  def
    { borderWidth = 2
    , focusFollowsMouse = False
    , modMask = mod4Mask
    , terminal = "alacritty"
    } `additionalKeysP`
  [ ( "M-p"
    , spawn "rofi -show combi -modes combi -combi-modes 'window,drun,run'")
  , ("M-<Escape>", spawn "xsecurelock")
  , ("<XF86AudioLowerVolume>", spawn "outctl audio-down")
  , ("<XF86AudioMute>", spawn "outctl audio-toggle")
  , ("<XF86AudioRaiseVolume>", spawn "outctl audio-up")
  , ("<XF86MonBrightnessDown>", spawn "outctl brightness-down")
  , ("<XF86MonBrightnessUp>", spawn "outctl brightness-up")
  ]
