{
  pkgs,
  config,
  inputs,
  ...
}:
{
  my.wayland.swaylock_path = "/usr/bin/swaylock";
  targets.genericLinux.nixGL.packages = inputs.nixGL.packages;
  home.packages = with pkgs; [ (config.lib.nixGL.wrap niri) ];
  programs.ghostty.package = with pkgs; (config.lib.nixGL.wrap ghostty);
  programs.alacritty.package = with pkgs; (config.lib.nixGL.wrap alacritty);
}
