{pkgs, config, lib, ...}:
{
  programs.fuzzel.enable = true;
  programs.waybar.enable = true;
  programs.waybar.systemd.enable = true;
  services.mako.enable = true;
  services.swayidle = {
      enable = true;
      events = [
        { event = "before-sleep"; command = "${pkgs.swaylock}/bin/swaylock -f"; }
      ];
      timeouts = [
        { timeout = 600; command = "${pkgs.swaylock}/bin/swaylock -f"; }
        { timeout = 900; command = "niri msg output * off"; }
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
        Description = "sway background service";
        PartOf = [ "graphical-session.target" ];
        After = [ "graphical-session.target" ];
      };

      Service = {
        Type = "simple";
        ExecStart = "${pkgs.swaybg}/bin/swaybg -i %h/.wallpapers/306579.jpg -m fill";
        Restart = "on-failure";
      };

      Install.WantedBy = [ "graphical-session.target" ];
  };

  home.file.".wallpapers".source = ./wallpapers;

  home.packages = with pkgs; [
      swaybg
      wl-clipboard
  ];
}
