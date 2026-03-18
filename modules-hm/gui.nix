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
      theme = "Gruvbox Dark Hard";
      font-family = "Iosvmata";
      font-size = 11;
      clipboard-read = "allow";
      clipboard-write = "allow";
    };
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhsWithPackages (
      ps: with ps; ([
        python3
      ])
    );
    # profiles.default.extensions = with pkgs.vscode-extensions; [
    #   platformio.platformio-vscode-ide
    #   ms-vscode.cpptools
    #   ms-python.python
    # ];
  };

  #  programs.autorandr.enable = true;
  #  services.autorandr.enable = true;

  fonts.fontconfig.enable = true;

  home.packages = with pkgs; [
    appimage-run
    blueman
    brightnessctl
    firefox
    flameshot
    gimp
    google-chrome
    libreoffice
    mate.atril
    mpv
    oculante
    overskride
    pavucontrol
    python3
    slack
    vesktop
    via
    vlc
    xdg-utils
    xsel
    zoom-us

    # fonts
    inter
    pkgs.nerd-fonts.fantasque-sans-mono
    pkgs.nerd-fonts.symbols-only
    pkgs.nerd-fonts.fira-code
    pkgs.iosvmata
  ];

  xdg.mimeApps = {
    defaultApplications = {
      "image/svg+xml" = [ "firefox.desktop" ];
    };
  };
}
