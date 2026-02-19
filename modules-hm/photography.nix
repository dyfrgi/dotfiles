{ pkgs, ... }:
{
  home.packages = with pkgs; [
    art
    darktable
    digikam
    gimp
    photoprism
    rapid-photo-downloader
    rapidraw
    rawtherapee
  ];
}
