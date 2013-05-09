--
-- Configuration file for XMonad + MATE
--
--  Usage:
--      * Copy this file to ~/.xmonad/
--      * Run:    $ xmonad --recompile
--      * Launch: $ xmonad --replace
--      [Optional] Create an autostart to command with "xmonad --replace"
--
--  Author: Arturo Fernandez <arturo at bsnux dot com>
--  Inspired by:
--      Spencer Janssen <spencerjanssen@gmail.com>
--      rfc <reuben.fletchercostin@gmail.com>
--  License: BSD
--
import XMonad
import XMonad.Config.Desktop
import XMonad.Util.Run (safeSpawn)
import qualified Data.Map as M
import System.Environment (getEnvironment)
import XMonad.Util.EZConfig

import XMonad
import XMonad.Hooks.ICCCMFocus
import XMonad.Actions.CycleWS
import XMonad.Actions.GridSelect
import XMonad.Config.Azerty
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.UrgencyHook
import XMonad.Layout.Grid
import XMonad.Layout.IM
import XMonad.Layout.NoBorders(noBorders)
import XMonad.Layout.PerWorkspace
import XMonad.Layout.Spacing
import XMonad.Prompt
import XMonad.Prompt.Shell
import XMonad.Util.EZConfig
import XMonad.Hooks.SetWMName
import XMonad.Hooks.EwmhDesktops

import qualified XMonad.StackSet as W

import Control.Monad
import Data.Monoid (Monoid)
import System.Environment (getEnvironment)

-- Define workspaces as (workspaceId, [className]) tuples where
-- [className] contains the X WM_CLASS propertes of the windows
-- bound to workspaceId.
workspaces' = [ ("1:main", ["google-chrome"])
              , ("2:term", []) 
              , ("3", []) 
              , ("4", []) 
              , ("5", []) ]

-- [ubuntu] apt-get remove appmenu-gtk3 appmenu-gtk appmenu-qt
terminal' = "mate-terminal --hide-menubar"

-- status bars font
font' = "xft:Mensch:size=9:bold:antialias=true"

xpConfig' = defaultXPConfig { bgColor  = "black", fgColor  = "yellow"
                      , font = font', position = Top, promptBorderWidth = 0
                      , height = 20, historySize = 256 }

gsConfig' = defaultGSConfig { gs_font=font', gs_cellwidth=400 }

xmobar' = statusBar xmobar pp toggleStrutsKey
    where
        xmobar = "xmobar ~/.xmonad/xmobar/xmobarrc.hs -f " ++ font'
        pp = xmobarPP
           { ppTitle = xmobarColor "green" ""
            , ppLayout = const ""
            , ppUrgent = xmobarColor "yellow" "red" . xmobarStrip }
        toggleStrutsKey = const (mod4Mask, xK_b)

mateConfig = desktopConfig
    { terminal = "mate-terminal"
    , keys     = mateKeys <+> keys desktopConfig
    }

mateKeys (XConfig {modMask = modm}) = M.fromList $
    [ ((modm, xK_p), mateRun)
    , ((modm .|. shiftMask, xK_q), spawn "mate-session-save --kill") ]

mateRun :: X ()
mateRun = withDisplay $ \dpy -> do
    rw <- asks theRoot
    mate_panel <- getAtom "_MATE_PANEL_ACTION"
    panel_run   <- getAtom "_MATE_PANEL_ACTION_RUN_DIALOG"

    io $ allocaXEvent $ \e -> do
        setEventType e clientMessage
        setClientMessageEvent e rw mate_panel 32 panel_run 0
        sendEvent dpy rw False structureNotifyMask e
        sync dpy False

main = do
    xmonad <=< xmobar' $ mateConfig
                { workspaces = map fst workspaces'
                 , logHook = takeTopFocus >> setWMName "LG3D"
                 , handleEventHook = fullscreenEventHook
                 , terminal = terminal'
                 , modMask = mod4Mask
                 , borderWidth = 2
                 , normalBorderColor  = "#586e75" -- solarized base01
                 , focusedBorderColor = "#cb4b16" -- solarized orange
                } `additionalKeysP` myKeys

myKeys = [  (("M4-p"), shellPrompt xpConfig')
          , (("M4-n"), spawn "caja --no-desktop")
          , (("M4-<Tab>"), goToSelected gsConfig')
          , (("M4-<Left>"), moveTo Prev NonEmptyWS)
          , (("M4-<Right>"), moveTo Next NonEmptyWS)
          , (("M4-z"), kill)
         ]
