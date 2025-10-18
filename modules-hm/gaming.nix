{ pkgs, ... }:
{
  home.packages = with pkgs; [
    butler
    en-croissant
    itch
    labwc # used for Path of Exile + Advanced PoE Trade overlay
    protonup
    stockfish
  ];
  home.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\\\${HOME}/.steam/root/compatibilitytools.d";
  };
}
