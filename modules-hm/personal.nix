{ pkgs, ... }:
{
  home.packages = with pkgs; [
    audacity
    calibre
    foliate
    signal-desktop
  ];
}
