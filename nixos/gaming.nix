{
  config,
  lib,
  pkgs,
  ...
}:
let
  cfg = config.my.gaming;
in
{
  options = {
    my.gaming.enable = lib.options.mkEnableOption "enable gaming packages etc";
  };
  config = lib.mkIf cfg.enable {
    programs.steam = {
      enable = true;
      gamescopeSession.enable = true;
      extraCompatPackages = [ pkgs.proton-ge-bin ];
    };
    programs.gamemode.enable = true;
    programs.gamescope = {
      enable = true;
    };
  };
}
