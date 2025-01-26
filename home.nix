{pkgs, config, lib, ...}:
let
  inherit (builtins) foldl';
  withCompilerFlags = (package: flags: package.overrideAttrs(old: {
      env = (old.env or {}) // { NIX_CFLAGS_COMPILE = toString (old.env.NIX_CFLAGS_COMPILE or "") + " ${toString flags}"; };
  }));
  dotfilesPath = "${config.home.homeDirectory}/.config/home-manager/";
  linkHome = path: config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/home/${path}";
  homeFilesToLink = [
    ".dircolors"
    ".etc/"
    ".gitconfig"
    ".gitignore_global"
    ".gitk"
    ".gtkrc-2.0"
    ".inputrc"
    ".mplayer/"
    ".reportbugrc"
    ".rtorrent.rc"
    ".screenrc"
    ".tmux/"
    ".tmux.conf"
    ".XCompose"
    ".xmonad/"
    ".xscreensaver"
    ".xsession"
    ".zshenv"
    ".zshrc"
  ];
  xdgConfigFilesToLink = [
    "awesome/"
    "compton.conf"
    "nvim/"
    "taffybar/"
  ];
in
{
  home.username = "msl";
  home.homeDirectory = "/home/msl";
  home.stateVersion = "23.11";
  home.enableDebugInfo = true;

  imports = [ ./nvim.nix ];

  xdg.enable = true; # set XDG_ env vars
  xdg.systemDirs.data = ["${config.home.profileDirectory}/share"]; # add nix-profile to XDG_DATA_DIRS
  programs.home-manager.enable = true;
  home.sessionVariables = {
    NIXOS_XDG_OPEN_USE_PORTAL = 1;
  };
  nixpkgs.config = {
    allowUnfree = true;
    permittedInsecurePackages = [
      "electron-27.3.11" # logseq-0.10.9
    ];
  };
  programs.direnv.enable = true;
  programs.pyenv = {
      enable = true;
  };
  programs.alacritty = {
      enable = true;
      settings = {
        font = {
          normal.family = "Fira Code Nerdfont";
          size = 9.0;
        };
      };
  };

  home.packages = with pkgs; [
    acpi
    awscli2
    bat
    brightnessctl
    devenv
    discord
    fd                 # used by telescope-nvim
    flameshot
    firefox
    fzf
    gimp
    google-chrome
    google-cloud-sdk
    lazygit
    logseq
    nerdfonts
    okular
    pavucontrol
    ripgrep
    scc
    slack
    via
    xdg-utils
    xsel
    yt-dlp
  ];

  home.file = {
    ".zsh" = { source = home/.zsh; recursive = true; };
    ".zsh/rc/S15home-manager-extra".text = config.programs.zsh.initExtra;
  } // foldl' (acc: elem: { "${elem}" = { source = linkHome elem; }; } // acc) {} homeFilesToLink;
  xdg.configFile = foldl' (acc: elem: { "${elem}" = { source = linkHome ".config/${elem}"; }; } // acc) {} xdgConfigFilesToLink;

  xsession.windowManager.awesome = {
    enable = true;
  };
  services.picom.enable = true;
  services.ssh-agent.enable = true;
}
