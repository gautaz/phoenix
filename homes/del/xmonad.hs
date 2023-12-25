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
import XMonad.Actions.PhysicalScreens
  ( onNextNeighbour
  , onPrevNeighbour
  , sendToScreen
  , viewScreen
  )
import XMonad.Hooks.EwmhDesktops (ewmh, ewmhFullscreen)
import XMonad.Hooks.StatusBar (defToggleStrutsKey, statusBarProp, withEasySB)
import XMonad.Hooks.StatusBar.PP (xmobarPP)
import qualified XMonad.StackSet as W
import XMonad.Util.EZConfig (additionalKeys, additionalKeysP, removeKeys)

main :: IO ()
main =
  xmonad . ewmhFullscreen . ewmh . withEasySB mySB defToggleStrutsKey $ myConfig

mySB = statusBarProp "@xmobar@" (pure xmobarPP)

modm = mod4Mask

shiftAndView target = W.view target . W.shift target

tar2art :: ([key], action) -> [(key, action)]
tar2art ([], _) = []
tar2art (key:keys, action) = (key, action) : tar2art (keys, action)

expandMultiKeybinding :: [([key], action)] -> [(key, action)]
expandMultiKeybinding =
  foldl
    (\keyBindings multiKeybinding -> keyBindings ++ tar2art multiKeybinding)
    []

myConfig =
  def
    { borderWidth = 2
    , focusFollowsMouse = False
    , modMask = modm
    , terminal = "@alacritty@"
    } `removeKeys`
  [(modm .|. mask, key) | mask <- [0, shiftMask], key <- [xK_w, xK_e, xK_r]] `additionalKeysP`
  ([ ("M-a", spawn "@findcursor@")
   , ("M-s", spawn "@flameshot@ gui")
   , ("M-i", spawn "@colorswitch@")
   , ("M-o", spawn "@rofi@ -monitor -1 -modi filebrowser -show filebrowser")
   , ( "M-p"
     , spawn
         "@rofi@ -monitor -1 -show combi -modes combi -combi-modes 'window,drun,run'")
   , ("M-r", spawn "@rorandr@")
   , ("M-<Escape>", spawn "@xlocker@")
   , ("M-S-<Escape>", spawn "@systemctl@ hibernate")
   , ("M-M1-j", onNextNeighbour def W.view)
   , ("M-M1-k", onPrevNeighbour def W.view)
   , ("M-M1-S-j", onNextNeighbour def shiftAndView)
   , ("M-M1-S-k", onPrevNeighbour def shiftAndView)
   ] ++
   expandMultiKeybinding
     [ (["M-,", "<XF86AudioLowerVolume>"], spawn "@outctl@ audio-down")
     , (["M-.", "<XF86AudioRaiseVolume>"], spawn "@outctl@ audio-up")
     , (["M-m", "<XF86AudioMute>"], spawn "@outctl@ audio-toggle")
     , (["M-S-,", "<XF86MonBrightnessDown>"], spawn "@outctl@ brightness-down")
     , (["M-S-.", "<XF86MonBrightnessUp>"], spawn "@outctl@ brightness-up")
     ])
