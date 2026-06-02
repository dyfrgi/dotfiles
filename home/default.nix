{
  pkgs,
  config,
  pkgs-unstable,
  username,
  ...
}:
let
  inherit (builtins) foldl';
  dotfilesPath = "${config.home.homeDirectory}/.config/home-manager/";
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
    ./git.nix
    ./nix-index.nix
    ./nvim.nix
    ./utilities.nix
    ./zsh.nix
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
    pkgs-unstable.awscli2
    pkgs-unstable.ssm-session-manager-plugin
    google-cloud-sdk
    qalculate-gtk
    zk
  ];

  home.shellAliases = {
    "hm" = "cd ${dotfilesPath}; $EDITOR";
    "ls" = "ls --color=auto";
  };

  xdg.configFile = foldl' (
    acc: elem:
    {
      "${elem}" = {
        source = config.lib.file.mkOutOfStoreSymlink "${dotfilesPath}/dotconfig/${elem}";
      };
    }
    // acc
  ) { } xdgConfigFilesToLink;

  programs.gpg.scdaemonSettings.disable-ccid = true;

  programs.readline = {
    enable = true;
    includeSystemConfig = true;
    variables = {
      "completion-ignore-care" = "On";
    };
  };

  services.gpg-agent = {
    enable = true;
    enableSshSupport = true;
    enableZshIntegration = true;
    pinentry.package = pkgs.pinentry-gtk2;
  };
}
