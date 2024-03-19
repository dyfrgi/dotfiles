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
  home.username = "mleuchtenburg";
  home.homeDirectory = "/home/mleuchtenburg";
  home.stateVersion = "23.11";
  home.enableDebugInfo = true;
  programs.home-manager.enable = true;
  home.sessionVariables = {
    NIXOS_XDG_OPEN_USE_PORTAL = 1;
  };
  nixpkgs.overlays = [
    (final: prev: {
# the call to override is needed because it sets up all the spliced versions of luajit
      luajit = (withCompilerFlags prev.luajit [ "-DLUAJIT_USE_PERFTOOLS" ]).override { self = final.luajit; };
    })
  ];
  nixpkgs.config.allowUnfree = true;
  programs.pyenv = {
      enable = true;
  };
  programs.neovim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [
        nvim-treesitter.withAllGrammars
      ];
  };
  home.packages = [
    pkgs.lazygit
    pkgs.logseq
    pkgs.slack
    pkgs.xdg-utils
    pkgs.yt-dlp
  ];

  home.file = {
    ".zsh" = { source = home/.zsh; recursive = true; };
    ".zsh/rc/S15home-manager-extra".text = config.programs.zsh.initExtra;
  } // foldl' (acc: elem: { "${elem}" = { source = linkHome elem; }; } // acc) {} homeFilesToLink;
  xdg.configFile = foldl' (acc: elem: { "${elem}" = { source = linkHome ".config/${elem}"; }; } // acc) {} xdgConfigFilesToLink;
}
