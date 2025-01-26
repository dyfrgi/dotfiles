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
  programs.direnv.enable = true;
  programs.pyenv = {
      enable = true;
  };

  home.packages = with pkgs; [
    acpi
    awscli2
    bat
    devenv
    fd                 # used by telescope-nvim
    fzf
    google-cloud-sdk
    lazygit
    ripgrep
    scc
    yt-dlp
  ];

  home.file = {
    ".zsh" = { source = home/.zsh; recursive = true; };
    ".zsh/rc/S15home-manager-extra".text = config.programs.zsh.initExtra;
  } // foldl' (acc: elem: { "${elem}" = { source = linkHome elem; }; } // acc) {} homeFilesToLink;
  xdg.configFile = foldl' (acc: elem: { "${elem}" = { source = linkHome ".config/${elem}"; }; } // acc) {} xdgConfigFilesToLink;

  services.ssh-agent.enable = true;
}
