{
  pkgs,
  lib,
  config,
  pkgs-unstable,
  username,
  ...
}:
let
  inherit (builtins) mapAttrs;
  dotfilesPath = "${config.home.homeDirectory}/.config/home-manager/";
  # Symlink pointing at the live repo rather than a copy in the nix store.
  xdgLink = path: {
    source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/${path}";
  };
in
{
  imports = [
    ./git.nix
    ./nix-index.nix
    ./nvim.nix
    ./utilities.nix
    ./zsh.nix
  ];

  # TODO: Make this work with /etc/nixos/ on NixOS systems, or automate
  # linking .config/home-manager/ to /etc/nixos.
  options = {
    my.xdgConfigFiles = lib.mkOption {
      type = with lib.types; attrsOf (nullOr str);
      default = { };
      description = ''
        Dotfiles to symlink into `$XDG_CONFIG_HOME`. A `null` target
        means `dotconfig/<target>`. Otherwise, the target should be the
        path to the file to link, relative to the root of this repo.
      '';
    };
  };

  config = {
    home.username = username;
    home.homeDirectory = "/home/${username}";
    home.stateVersion = "23.11";
    home.enableDebugInfo = true;

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
      ssm-session-manager-plugin
      google-cloud-sdk
      zk
    ];

    home.shellAliases = {
      "hm" = "cd ${dotfilesPath}; $EDITOR";
      "ls" = "ls --color=auto";
    };

    my.xdgConfigFiles = {
      "awesome/" = null;
      "compton.conf" = null;
      "taffybar/" = null;
    };

    xdg.configFile = mapAttrs (
      target: src: xdgLink (if src == null then "dotconfig/${target}" else src)
    ) config.my.xdgConfigFiles;

    programs.readline = {
      enable = true;
      includeSystemConfig = true;
      variables = {
        "completion-ignore-case" = "On";
      };
    };

    services.ssh-agent = {
      enable = true;
    };
  };
}
