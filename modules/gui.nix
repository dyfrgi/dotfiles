{
  pkgs,
  config,
  lib,
  pkgs-unstable,
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

  programs.ghostty = {
    enable = true;
    enableZshIntegration = true;
    settings = {
      theme = "Spacedust";
      font-family = "Fira Code Nerdfont";
      font-size = 9;
      clipboard-read = "allow";
    };
  };

  #  programs.autorandr.enable = true;
  #  services.autorandr.enable = true;

  home.packages = with pkgs; [
    mate.atril
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
    pkgs-unstable.nerd-fonts.fantasque-sans-mono
    pkgs-unstable.nerd-fonts.symbols-only
    pkgs-unstable.nerd-fonts.fira-code
  ];
}
