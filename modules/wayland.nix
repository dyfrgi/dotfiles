{pkgs, config, lib, ...}:
{
  programs.fuzzel.enable = true;
  programs.waybar.enable = true;
  programs.waybar.systemd.enable = true;
  services.mako.enable = true;

  home.packages = with pkgs; [
      wl-clipboard
  ];
}
