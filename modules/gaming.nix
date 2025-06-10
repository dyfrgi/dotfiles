{ pkgs, ... }:
{
  home.packages = with pkgs; [
    en-croissant
    protonup
    stockfish
  ];
  home.sessionVariables = {
    STEAM_EXTRA_COMPAT_TOOLS_PATHS = "\\\${HOME}/.steam/root/compatibilitytools.d";
  };
}
