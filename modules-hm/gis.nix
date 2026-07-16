{ pkgs, ... }:
{
  config = {
    home.packages = with pkgs; [ qgis ];
  };
}
