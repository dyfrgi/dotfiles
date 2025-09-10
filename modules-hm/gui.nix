{
  pkgs,
  config,
  lib,
  ...
}:
{
  imports = [
    ./x11.nix
    ./wayland.nix
  ];

  home.sessionVariables = {
    NIXOS_XDG_OPEN_USE_PORTAL = 1;
  };

  programs.alacritty = {
    enable = true;
    settings = {
      terminal = {
        osc52 = "CopyPaste";
      };
      font = {
        normal.family = "Fira Code Nerdfont";
        size = 9.0;
      };
    };
  };

  services.udiskie = {
    enable = true;
    settings.terminal = "${pkgs.ghostty}/bin/ghostty --working-directory=";
  };

  services.network-manager-applet.enable = true;

  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      theme = "Adwaita Dark";
      font-family = "Fira Code Nerdfont";
      font-size = 9;
      clipboard-read = "allow";
    };
  };

  #  programs.autorandr.enable = true;
  #  services.autorandr.enable = true;

  home.packages = with pkgs; [
    appimage-run
    mate.atril
    blueman
    overskride
    brightnessctl
    vesktop
    flameshot
    firefox
    gimp
    google-chrome
    libreoffice
    pavucontrol
    slack
    via
    xdg-utils
    xsel
    vlc
    zoom-us

    # fonts
    inter
    pkgs.nerd-fonts.fantasque-sans-mono
    pkgs.nerd-fonts.symbols-only
    pkgs.nerd-fonts.fira-code
  ];

  xdg.mimeApps = {
    defaultApplications = {
      "image/svg+xml" = [ "firefox.desktop" ];
    };
  };
}
