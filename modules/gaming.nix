{ pkgs, ... }:
{
  home.packages = with pkgs; [
    en-croissant
    path-of-building
    protonup
    stockfish
  ];
  home.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\\\${HOME}/.steam/root/compatibilitytools.d";
  };
}
