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

  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      "electron-27.3.11" # logseq-0.10.9
    ];
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
    brightnessctl
    vesktop
    flameshot
    firefox
    gimp
    google-chrome
    logseq
    okular
    pavucontrol
    slack
    via
    xdg-utils
    xsel

    # fonts
    inter
    (nerdfonts.override {
      fonts = [
        "FiraCode"
        "FantasqueSansMono"
        "NerdFontsSymbolsOnly"
      ];
    })
  ];
}
