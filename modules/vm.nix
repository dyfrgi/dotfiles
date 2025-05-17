{ pkgs, ... }:
{
  home.packages = with pkgs; [
    quickemu
    spice-gtk
  ];
}
