{ pkgs, ... }:
{
  home.packages = with pkgs; [
    en-croissant
    labwc # used for Path of Exile + Advanced PoE Trade overlay
    protonup
    stockfish
  ];
  home.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\\\${HOME}/.steam/root/compatibilitytools.d";
  };
}
