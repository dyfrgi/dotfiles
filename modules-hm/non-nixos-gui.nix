{
  pkgs,
  config,
  inputs,
  ...
}:
{
  my.wayland.swaylock_path = "/usr/bin/swaylock";
  targets.genericLinux.gpu.enable = true;
  home.packages = with pkgs; [ niri ];
}
