{
  pkgs,
  lib,
  config,
  pkgs-unstable,
  username,
  ...
}:
let
  inherit (builtins) foldl';
  dotfilesPath = "${config.home.homeDirectory}/.config/home-manager/";
in
{
  imports = [
    ./git.nix
    ./nix-index.nix
    ./nvim.nix
    ./utilities.nix
    ./zsh.nix
  ];

  options = {
    my.xdgConfigFilesToLink = lib.mkOption {
      type = lib.types.listOf lib.types.str;
      default = [ ];
      description = ''
        Paths under `dotconfig/` to symlink into `$XDG_CONFIG_HOME`, pointing at
        the live repo instead of the nix store. A trailing `/` links a whole
        directory. Modules add the dotfiles they own, so a config is only linked
        on profiles importing that module.
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

    my.xdgConfigFilesToLink = [
      "awesome/"
      "compton.conf"
      "taffybar/"
    ];

    xdg.configFile = foldl' (
      acc: elem:
      {
        "${elem}" = {
          source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/dotconfig/${elem}";
        };
      }
      // acc
    ) { } config.my.xdgConfigFilesToLink;

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
