{ pkgs, ... }:
{
  home.packages = with pkgs; [
    bambu-studio
    bottles
    freecad-wayland
    librecad
  ];
}
