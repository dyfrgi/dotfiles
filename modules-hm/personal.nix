{ pkgs, ... }:
{
  home.packages = with pkgs; [
    calibre
    foliate
    signal-desktop
  ];
}
