{
  pkgs,
  lib,
  ...
}:
{
  programs.fuzzel.enable = true;
  programs.waybar.enable = true;
  programs.waybar.systemd.enable = true;
  services.mako.enable = true;
  services.swayidle = {
    enable = true;
    events = [
      {
        event = "before-sleep";
        command = "${pkgs.swaylock}/bin/swaylock -f";
      }
    ];
    timeouts = [
      {
        timeout = 600;
        command = "${pkgs.swaylock}/bin/swaylock -f";
      }
      {
        timeout = 900;
        command = "niri msg output * off";
      }
    ];
  };

  programs.swaylock = {
    enable = true;
    # catpuccin macchiato theme from https://github.com/catppuccin/swaylock
    settings = {
      color = "24273a";
      bs-hl-color = "f4dbd6";
      caps-lock-bs-hl-color = "f4dbd6";
      caps-lock-key-hl-color = "a6da95";
      inside-color = "00000000";
      inside-clear-color = "00000000";
      inside-caps-lock-color = "00000000";
      inside-ver-color = "00000000";
      inside-wrong-color = "00000000";
      key-hl-color = "a6da95";
      layout-bg-color = "00000000";
      layout-border-color = "00000000";
      layout-text-color = "cad3f5";
      line-color = "00000000";
      line-clear-color = "00000000";
      line-caps-lock-color = "00000000";
      line-ver-color = "00000000";
      line-wrong-color = "00000000";
      ring-color = "b7bdf8";
      ring-clear-color = "f4dbd6";
      ring-caps-lock-color = "f5a97f";
      ring-ver-color = "8aadf4";
      ring-wrong-color = "ee99a0";
      separator-color = "00000000";
      text-color = "cad3f5";
      text-clear-color = "f4dbd6";
      text-caps-lock-color = "f5a97f";
      text-ver-color = "8aadf4";
      text-wrong-color = "ee99a0";
    };
  };

  systemd.user.services.swaybg = {
    Unit = {
      Description = "swaybg wallpaper setter";
      Wants = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Install.WantedBy = [ "niri.service" ];
    Service = {
      ExecStart = "${pkgs.swaybg}/bin/swaybg -i %h/.wallpapers/306579.jpg -m fill";
      Restart = "on-failure";
    };
  };

  systemd.user.services.xwayland-satellite = {
    Unit = {
      Description = "xwayland-satellite";
      Wants = [ "graphical-session.target" ];
      After = [ "graphical-session.target" ];
    };
    Install.WantedBy = [ "niri.service" ];
    Service = {
      ExecStart = "${lib.getExe pkgs.xwayland-satellite} :12";
      Restart = "on-failure";
    };
  };

  home.file.".wallpapers".source = ./wallpapers;

  home.pointerCursor = {
    package = pkgs.catppuccin-cursors.latteDark;
    name = "catppuccin-latte-dark-cursors";
    size = 32;
    gtk.enable = true;
    x11.enable = true;
  };

  home.packages = with pkgs; [
    swaybg
    wl-clipboard
  ];

  # Configure XDG portals. Default to GTK, fall back to Gnome.
  # This should wind up using Gnome for background, clipboard, input capture, remote desktop, screencast, screenshot, and wallpaper.
  # Gtk will be used for access, account, app chooser, dynamic launcher, email, file chooser, inhibit, notification, printing, and settings.
  # Notably, this should make file browsing work without Nautilus installed, using the default Gtk file picker.
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-gnome
    ];
    config = {
      common = {
        default = [
          "gtk"
          "gnome"
        ];
        "org.freedesktop.impl.portal.FileChooser" = [ "gtk" ];
      };
    };
  };
}
