{ pkgs, ... }:
{
  home.packages = with pkgs; [
    bambu-studio
    bottles
    freecad-wayland
    gmsh
    graphviz
    kicad
    librecad
  ];
}
