import XMonad
import qualified XMonad.StackSet as W
import XMonad.Actions.SpawnOn
import XMonad.Actions.CycleWS
import XMonad.Hooks.DynamicLog
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
import System.Exit
import System.IO
import Data.Monoid
import Control.Monad

main = do
        dout <- spawnPipe "dzen2 -ta l -w 1312 -e 'onstart=lower'"
        --tout <- spawnPipe "trayer --tint 0x000000 --SetDockType true --SetPartialStrut true --widthtype pixel --width 128 --edge top --align right"
        xmonad
            $ withUrgencyHook NoUrgencyHook
            $ myConfig dout

myManageHook = composeAll . concat $ 
                [ [ isFullscreen --> doFullFloat ]
                , [ className =? "HipChat" <&&> isInProperty "_NET_WM_STATE" "_NET_WM_STATE_SKIP_TASKBAR" --> doIgnore ]
                , [ manageDocks ]
                ]


myConfig h = defaultConfig {
    manageHook = myManageHook
    , layoutHook = myLayout
    , logHook = myDynamicLog h
    , modMask = mod4Mask
    , workspaces = myWorkspaces
    , borderWidth = 2
    , terminal = "rxvt"
    , normalBorderColor = "#666677"
    , focusedBorderColor = "#dd9b22"
    , keys = \c -> mkKeymap c $ myKeymap
    , startupHook = do
        return () -- supposedly to avoid inf. loops with checkKeymap
        checkKeymap (myConfig h) myKeymap
}

myLayout = 
    avoidStrutsOn [U] $             -- don't map windows over docks, etc.
    workspaceDir "~" $              -- start all workspaces in ~
    smartBorders $                  -- no borders on full-screen
    onWorkspace "chat" myThree $    -- use 3-column layout on chat desktop
    mkToggle (single REFLECTX) $
    mkToggle (single REFLECTY) $

    myGrid
    ||| myTall 
    ||| myFullTabbed             -- tall and fullscreen tabbed layouts
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
    [ "chat"
    , "mail"
    , "web"
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

myKeymap =
      [ ("<XF86AudioRaiseVolume>", spawn "amixer -q set Master 3%+ unmute")
      , ("<XF86AudioLowerVolume>", spawn "amixer -q set Master 3%- unmute")
      , ("<XF86AudioMute>", spawn "amixer -q set Master toggle")
        -- Run dmenu to launch programs
      , ("M-p", spawn "exe=`dmenu_path | dmenu` && eval \"exec $exe\"")
        -- Close the focused window
      , ("M-S-c", kill)
        -- Switch to the next layout
      , ("M-<Space>", sendMessage NextLayout)
      , ("M-S-<Space>", setLayout $ Layout myLayout)

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
      , ("M-w c", changeDir defaultXPConfig)
        -- Turn off avoiding the toolbar
      , ("M-w m", sendMessage $ ToggleStrut U)
      , ("M-w r", sendMessage $ ToggleStrut R)

        -- Toggle left/right top/bottom reflection of layouts
      , ("M-w x", sendMessage $ Toggle REFLECTX)
      , ("M-w y", sendMessage $ Toggle REFLECTY)

      , ("M-w s", spawn "import -window root ~/screenshots/shot.png")

      , ("M-<Pause>", spawn "gnome-screensaver-command -l")

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
      [("M-" ++ m ++ [key], screenWorkspace sc >>= flip whenJust (windows . f))
        | (key, sc) <- zip "',." [0..]
        , (f, m) <- [(W.view, ""), (W.shift, "S-")]]

myDynamicLog h = dynamicLogWithPP $ dzenPP
    { ppExtras  = map padL
                  [ date "%c"
                  , loadAvg
                  , battery ]
    , ppOrder   = \(ws:l:t:exs) -> [ws,t,l]++exs
    , ppOutput  = hPutStrLn h
    , ppHidden  = dzenColor "black"     "#a8a3f7" . pad
    , ppCurrent = dzenColor "yellow"    "#a8a3f7" . pad
    , ppSep     = ""
    , ppWsSep   = ""
    , ppTitle   = dzenColor "white"     "#383387" . shorten 70 . dzenEscape . pad
    }
