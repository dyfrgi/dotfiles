{ pkgs, ... }:
{
  home.packages = with pkgs; [
    butler
    # broken: should be trivial to upgrade to webkitgtk_4_1
    # en-croissant
    itch
    labwc # used for Path of Exile + Advanced PoE Trade overlay
    protonup-ng
    stockfish
  ];
  home.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\\\${HOME}/.steam/root/compatibilitytools.d";
  };
}
