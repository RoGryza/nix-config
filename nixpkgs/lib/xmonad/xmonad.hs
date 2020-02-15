{-# LANGUAGE FlexibleContexts #-}
import           Data.Foldable
import           XMonad
import qualified XMonad.StackSet               as W
import           XMonad.Actions.UpdateFocus
import           XMonad.Layout.IndependentScreens
import           XMonad.Layout.NoBorders
import           XMonad.Hooks.DynamicLog
import           XMonad.Hooks.ManageDocks
import           XMonad.Hooks.EwmhDesktops
import           XMonad.Util.EZConfig
import           XMonad.Util.Run

myLayoutHook =
  avoidStruts $ noBorders Full ||| smartBorders (Tall 1 (3 / 100) (1 / 2))

addBar :: LayoutClass l Window => XConfig l -> IO (XConfig l)
addBar cfg = do
  nScreens <- countScreens :: IO Int
  hs <- mapM spawnPipe [ "xmobar -x " ++ show i | i <- [0 .. nScreens - 1] ]
  return $ cfg
    { logHook =
      do
        logHook cfg
        forM_ (zip [0 ..] hs) $ \(i, h) ->
          dynamicLogWithPP (marshallPP i xmobarPP) { ppOutput = hPutStrLn h }
    }

main :: IO ()
main = do
  nScreens <- countScreens
  baseCfg  <- addBar $ ewmh $ docks def
    { modMask         = mod4Mask
    , terminal        = "alacritty"
    , startupHook     = adjustEventInput
    , layoutHook      = myLayoutHook
    , handleEventHook = handleEventHook def <+> focusOnMouseMove
    , workspaces      = withScreens nScreens $ fmap show ([1 .. 4] :: [Int])
    , manageHook      = stringProperty "_NET_WM_NAME" =? "Emulator" --> doFloat
    }
  xmonad
    $                 baseCfg
    `additionalKeysP` [ ("M-x"       , kill)
                      , ("M-S-b"     , spawn "firefox")
                      , ("M-<Return>", spawn "alacritty -e tmux new-session")
                      , ("M-l"       , spawn "slock")
                      , ("M-r"       , spawn "rofi -modi drun -show drun")
                      , ( "M-t"
                        , spawn
                          "rofi -show run -run-command 'alacritty -e \"{cmd}\"'"
                        )
                      , ("M-p"      , spawn "passmenu")
                      , ("M-d"      , spawn "emacsclient --create-frame")
                      , ("M-b"      , sendMessage ToggleStruts)
                      , ("M-<Space>", sendMessage NextLayout)
                      ]
    `additionalKeys`  [ ((m .|. mod4Mask, k), windows $ onCurrentScreen f i)
                      | (i, k) <- zip (workspaces' baseCfg) [xK_1 .. xK_9]
                      , (f, m) <- [(W.greedyView, 0), (W.shift, shiftMask)]
                      ]
