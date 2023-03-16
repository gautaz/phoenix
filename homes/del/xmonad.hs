import Graphics.X11.Types (xK_a, xK_d, xK_e, xK_r, xK_s, xK_w)
import XMonad
  ( (.|.)
  , borderWidth
  , def
  , focusFollowsMouse
  , mod4Mask
  , modMask
  , shiftMask
  , spawn
  , terminal
  , xmonad
  )
import XMonad.Actions.PhysicalScreens (sendToScreen, viewScreen)
import XMonad.Hooks.EwmhDesktops (ewmh, ewmhFullscreen)
import XMonad.Hooks.StatusBar (defToggleStrutsKey, statusBarProp, withEasySB)
import XMonad.Hooks.StatusBar.PP (xmobarPP)
import XMonad.Util.EZConfig (additionalKeys, additionalKeysP, removeKeys)

main :: IO ()
main =
  xmonad . ewmhFullscreen . ewmh . withEasySB mySB defToggleStrutsKey $ myConfig

mySB = statusBarProp "@xmobar@" (pure xmobarPP)

modm = mod4Mask

myConfig =
  def
    { borderWidth = 2
    , focusFollowsMouse = False
    , modMask = modm
    , terminal = "@alacritty@"
    } `additionalKeysP`
  [ ( "M-p"
    , spawn "@rofi@ -show combi -modes combi -combi-modes 'window,drun,run'")
  , ( "M-o"
    , spawn "@rofi@ -modi file-browser-extended -show file-browser-extended")
  , ("M-S-<Escape>", spawn "@systemctl@ suspend")
  , ("M-<Escape>", spawn "@xlocker@")
  , ("<XF86AudioLowerVolume>", spawn "@outctl@ audio-down")
  , ("<XF86AudioMute>", spawn "@outctl@ audio-toggle")
  , ("<XF86AudioRaiseVolume>", spawn "@outctl@ audio-up")
  , ("<XF86MonBrightnessDown>", spawn "@outctl@ brightness-down")
  , ("<XF86MonBrightnessUp>", spawn "@outctl@ brightness-up")
  ] `additionalKeys`
  [ ((modm .|. mask, key), action screenId)
  | (key, screenId) <- zip [xK_a, xK_s, xK_d] [0 ..]
  , (action, mask) <- [(viewScreen def, 0), (sendToScreen def, shiftMask)]
  ] `removeKeys`
  [(modm .|. mask, key) | mask <- [0, shiftMask], key <- [xK_w, xK_e, xK_r]]
