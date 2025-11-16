{
  pkgs,
  config,
  pkgs-unstable,
  lib,
  username,
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
  home.username = username;
  home.homeDirectory = "/home/${username}";
  home.stateVersion = "23.11";
  home.enableDebugInfo = true;

  imports = [
    modules-hm/git.nix
    modules-hm/nix-index.nix
    modules-hm/nvim.nix
    modules-hm/utilities.nix
    modules-hm/zsh.nix
  ];

  xdg.enable = true; # set XDG_ env vars
  xdg.systemDirs.data = [ "${config.home.profileDirectory}/share" ]; # add nix-profile to XDG_DATA_DIRS

  programs.home-manager.enable = true;
  programs.direnv.enable = true;
  programs.pyenv = {
    enable = true;
  };
  programs.uv.enable = true;
  programs.poetry.enable = true;

  home.packages = with pkgs; [
    awscli2
    google-cloud-sdk
    qalculate-gtk
    zk
  ];

  home.shellAliases = {
    "hm" = "cd ${dotfilesPath}; $EDITOR";
  };

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
        source = linkHome "dotconfig/${elem}";
      };
    }
    // acc
  ) { } xdgConfigFilesToLink;

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    enableZshIntegration = true;
    pinentry.package = pkgs.pinentry-gtk2;
  };
}
