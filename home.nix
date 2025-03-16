{
  pkgs,
  config,
  pkgs-unstable,
  lib,
  ...
}:
let
  inherit (builtins) foldl';
  withCompilerFlags = (
    package: flags:
    package.overrideAttrs (old: {
      env = (old.env or { }) // {
        NIX_CFLAGS_COMPILE = toString (old.env.NIX_CFLAGS_COMPILE or "") + " ${toString flags}";
      };
    })
  );
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
    ".xmonad/"
    ".xscreensaver"
  ];
  xdgConfigFilesToLink = [
    "awesome/"
    "compton.conf"
    "nvim/"
    "taffybar/"
    "niri/"
    "waybar/"
  ];
in
{
  home.username = "msl";
  home.homeDirectory = "/home/msl";
  home.stateVersion = "23.11";
  home.enableDebugInfo = true;

  imports = [
    modules/nvim.nix
    modules/zsh.nix
    modules/git.nix
  ];

  xdg.enable = true; # set XDG_ env vars
  xdg.systemDirs.data = [ "${config.home.profileDirectory}/share" ]; # add nix-profile to XDG_DATA_DIRS

  programs.home-manager.enable = true;
  programs.direnv.enable = true;
  programs.pyenv = {
    enable = true;
  };
  programs.nix-index-database.comma.enable = true;

  home.packages = with pkgs; [
    acpi
    awscli2
    bat
    (pkgs-unstable.devenv)
    fd # used by telescope-nvim
    fzf
    google-cloud-sdk
    lazygit
    ripgrep
    scc
    whois
    yt-dlp
  ];

  home.file = foldl' (
    acc: elem:
    {
      "${elem}" = {
        source = linkHome elem;
      };
    }
    // acc
  ) { } homeFilesToLink;
  xdg.configFile = foldl' (
    acc: elem:
    {
      "${elem}" = {
        source = linkHome ".config/${elem}";
      };
    }
    // acc
  ) { } xdgConfigFilesToLink;

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    enableZshIntegration = true;
    pinentryPackage = pkgs.pinentry-gtk2;
  };
}
