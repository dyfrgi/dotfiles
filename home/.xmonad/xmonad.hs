import XMonad
import qualified XMonad.StackSet as W
import XMonad.Actions.SpawnOn
import XMonad.Actions.CycleWS
import XMonad.Actions.PhysicalScreens
import XMonad.Hooks.DynamicLog
import XMonad.Hooks.EwmhDesktops (ewmh, fullscreenEventHook)
import XMonad.Hooks.ManageDocks
import XMonad.Hooks.ManageHelpers
import XMonad.Hooks.UrgencyHook
import XMonad.Layout.Grid
import XMonad.Layout.MultiToggle
import XMonad.Layout.NoBorders
import XMonad.Layout.PerWorkspace
import XMonad.Layout.Reflect
import XMonad.Layout.Renamed
import XMonad.Layout.ResizableTile
import XMonad.Layout.Tabbed
import XMonad.Layout.ThreeColumns
import XMonad.Layout.WorkspaceDir
import XMonad.Prompt
import XMonad.Prompt.Workspace
import XMonad.Util.EZConfig
import XMonad.Util.Run
import XMonad.Util.Loggers
import System.Taffybar.Hooks.PagerHints (pagerHints)
import System.Exit
import System.IO
import Data.Default
import Data.Monoid
import Data.Maybe (maybeToList)
import Control.Monad
import System.Directory (getHomeDirectory)

main = do
        homedir <- getHomeDirectory
        xmonad
            $ withUrgencyHook NoUrgencyHook
            $ docks
            $ ewmh
            $ pagerHints
            $ myConfig homedir

--                [ className =? "HipChat" <&&> isInProperty "_NET_WM_STATE" "_NET_WM_STATE_SKIP_TASKBAR" --> doIgnore
myManageHook :: ManageHook
myManageHook = (composeAll . concat $
                [   [ className =? c     --> doCenterFloat   | c <- myFloatsC   ]
                ,   [ manageDocks                                               ]
                ])
                where
                    myFloatsC = ["VirtualBox"]


myConfig homedir = def {
    manageHook = myManageHook
    , handleEventHook = handleEventHook def <+> fullscreenEventHook
    , layoutHook = myLayout homedir
    , modMask = mod4Mask
    , workspaces = myWorkspaces
    , borderWidth = 2
    , terminal = "rxvt"
    , normalBorderColor = "#666677"
    , focusedBorderColor = "#dd9b22"
    , keys = \c -> mkKeymap c $ myKeymap homedir
    , startupHook = do
        return () -- extra laziness to avoid infinite loops
        checkKeymap (myConfig homedir) (myKeymap homedir)
        addEWMHFullscreen
        startupHook def
}

-- https://github.com/xmonad/xmonad-contrib/issues/183
-- https://github.com/xmonad/xmonad-contrib/pull/109 will eliminate the need for this eventually
addNETSupported :: Atom -> X ()
addNETSupported x   = withDisplay $ \dpy -> do
    r               <- asks theRoot
    a_NET_SUPPORTED <- getAtom "_NET_SUPPORTED"
    a               <- getAtom "ATOM"
    liftIO $ do
       sup <- (join . maybeToList) <$> getWindowProperty32 dpy a_NET_SUPPORTED r
       when (fromIntegral x `notElem` sup) $
         changeProperty32 dpy r a_NET_SUPPORTED a propModeAppend [fromIntegral x]

addEWMHFullscreen :: X ()
addEWMHFullscreen   = do
    wms <- getAtom "_NET_WM_STATE"
    wfs <- getAtom "_NET_WM_STATE_FULLSCREEN"
    mapM_ addNETSupported [wms, wfs]

myLayout homedir = 
    avoidStruts $                   -- don't map windows over docks, etc.
    workspaceDir homedir $          -- start all workspaces in ~
    smartBorders $                  -- no borders on full-screen
    mkToggle (single REFLECTX) $
    mkToggle (single REFLECTY) $

    myGrid
    ||| myTall 
    ||| myFullTabbed                -- tall and fullscreen tabbed layouts
    where
        myThree = ThreeCol 1 0.03 0.50
        myGrid = renamed [Replace "Grid"] $ GridRatio (19 / 21)
        myTall = Tall 1 0.05 0.5
        myFullTabbed = simpleTabbed

myXPConfig = greenXPConfig {
      font = "xft:Bitstream Vera Sans Mono:pixelsize=20:autohint=true"
    , autoComplete = Just 50000
    }

myWorkspaces =
    [ "1"
    , "2"
    , "3"
    , "4"
    , "5"
    , "6"
    , "7"
    , "8"
    , "9"
    , "0"
    ]

promptedGoto = workspacePrompt myXPConfig $ windows . W.greedyView
promptedShift = workspacePrompt myXPConfig $ windows . W.shift

myKeymap homedir =
      [ ("<XF86AudioRaiseVolume>", spawn "pactl set-sink-volume 0 +3%")
      , ("<XF86AudioLowerVolume>", spawn "pactl set-sink-volume 0 -3%")
      , ("M-<F11>", spawn "pactl set-sink-volume 0 -3%")
      , ("M-<F12>", spawn "pactl set-sink-volume 0 +3%")
      , ("<XF86AudioMute>", spawn "pactl set-sink-mute 0 toggle")
      -- , ("<XF86AudioMicMute>", spawn "pactl set-source-mute 1 toggle")
        -- Run dmenu to launch programs
      , ("M-p", spawn "dmenu_run")
        -- Close the focused window
      , ("M-S-c", kill)
        -- Switch to the next layout
      , ("M-<Space>", sendMessage NextLayout)
      , ("M-S-<Space>", setLayout $ Layout $ myLayout homedir)

        -- Focus the next window
      , ("M-n", windows W.focusDown)
        -- Focus the previous window
      , ("M-t", windows W.focusUp)

        -- Swap the focused window with the next window
      , ("M-S-n", windows W.swapDown)
        -- Swap the focused window with the previous window
      , ("M-S-t", windows W.swapUp)

        -- Shrink the master window
      , ("M-c", sendMessage Shrink)
        -- Expand the master window
      , ("M-r", sendMessage Expand)

        -- Increment the number of windows in the master area
      , ("M-l", sendMessage (IncMasterN 1))
        -- Decrement the number of windows in the master area
      , ("M-/", sendMessage (IncMasterN (-1)))

        -- Focus urgent window
      , ("M-a", focusUrgent)

        -- Swap the focused window and the master window
      , ("M-m", windows W.swapMaster)

      , ("M-g", promptedGoto)
      , ("M-S-g", promptedShift)

        -- Quit
      , ("M-S-q", io (exitWith ExitSuccess))
        -- Restart xmonad
      , ("M-q", restart "xmonad" True)

        -- Start a terminal
      , ("M-<Return>", safeSpawn "urxvt" [])

        -- Push the focused window back into tiling
      , ("M-w t", withFocused $ windows . W.sink)
        -- Change the working dir of the current workspace
      , ("M-w c", changeDir def)
        -- Turn off avoiding the toolbar
      , ("M-w m", sendMessage $ ToggleStrut U)
      , ("M-w r", sendMessage $ ToggleStrut R)

        -- Toggle left/right top/bottom reflection of layouts
      , ("M-w x", sendMessage $ Toggle REFLECTX)
      , ("M-w y", sendMessage $ Toggle REFLECTY)

      , ("M-w s", spawn "import -window root ~/screenshots/shot.png")

      -- lock the screen
      , ("M-<Pause>", spawn "cinnamon-screensaver-command -l")
      , ("M-C-M1-<Space>", spawn "cinnamon-screensaver-command -l")

        -- Workspace cycling
      , ("M-s", nextWS)
      , ("M-h", prevWS)
      , ("M-S-s", shiftToNext)
      , ("M-S-h", shiftToPrev)
      , ("M-z", toggleWS)
      ]
      -- Move between workspaces, move windows between workspaces
      ++
      [("M-" ++ m ++ [k], windows $ f i)
        | (i, k) <- zip myWorkspaces "1234567890",
          (f, m) <- [(W.greedyView, ""), (W.shift, "S-")]]
      -- Move between screens
      ++
      [("M-" ++ m ++ [key], f sc)
        | (key, sc) <- zip "',." [0..]
        , (f, m) <- [(viewScreen def, ""), (sendToScreen def, "S-")]]
