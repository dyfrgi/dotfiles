{pkgs, config, lib, ...}:
{
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

  programs.autorandr.enable = true;
  services.autorandr.enable = true;

  home.packages = with pkgs; [
    brightnessctl
    discord
    flameshot
    firefox
    gimp
    google-chrome
    logseq
    nerdfonts
    okular
    pavucontrol
    slack
    via
    xdg-utils
    xsel
  ];

  xsession.windowManager.awesome = {
    enable = true;
  };

  services.picom.enable = true;
}
