import System.Taffybar

import System.Taffybar.Systray
import System.Taffybar.XMonadLog
import System.Taffybar.SimpleClock
import System.Taffybar.FreedesktopNotifications
import System.Taffybar.Weather
import System.Taffybar.MPRIS
import System.Taffybar.NetMonitor

import System.Taffybar.Widgets.PollingBar
import System.Taffybar.Widgets.PollingGraph

import System.Information.Memory
import System.Information.CPU

memCallback = do
    mi <- parseMeminfo
    return $ memoryUsedRatio mi

cpuCallback = do
  (userLoad, systemLoad, totalLoad) <- cpuLoad
  return [totalLoad, systemLoad]

colorMem v =
  case  v of
    _ | v < 0.25 -> (0, 0, 1)
    _ | v < 0.5  -> (0, 0.5, 1)
    _ | v < 0.625-> (0, 1, 0.5)
    _ | v < 0.75 -> (0, 1, 0)
    _ | v < 0.8  -> (0.5, 1, 0)
    _ | v < 0.9  -> (1, 1, 0)
    _ | v < 0.95 -> (1, 0.5, 0)
    _            -> (1, 0, 0)

main = do
  let memCfg = defaultBarConfig colorMem
      cpuCfg = defaultGraphConfig { graphDataColors = [ (0, 1, 0, 1)
                                                      , (1, 0, 1, 0.5)
                                                      ]
                                  , graphLabel = Just "cpu"
                                  }
  let clock = textClockNew Nothing "<span fgcolor='orange'>%a %b %-d %H:%M</span>" 1
      log = xmonadLogNew
      note = notifyAreaNew defaultNotificationConfig
      wcfg = (defaultWeatherConfig "KBOS") { weatherTemplate = "$tempC$°C $humidity$%" }
      wea = weatherNew wcfg 10
      mpris = mprisNew
      net = netMonitorNew 1 "eth0"
      mem = pollingBarNew memCfg 1 memCallback
      cpu = pollingGraphNew cpuCfg 0.5 cpuCallback
      tray = systrayNew
  defaultTaffybar defaultTaffybarConfig { startWidgets = [ log, note ]
                                        , endWidgets = [ tray, wea, clock, net, mem, cpu ]
                                        , barHeight = 20
                                        }
