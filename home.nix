{pkgs, ...}: {
  home.username = "mleuchtenburg";
  home.homeDirectory = "/home/mleuchtenburg";
  home.stateVersion = "23.11";
  programs.home-manager.enable = true;
  home.sessionVariables = {
    NIXOS_XDG_OPEN_USE_PORTAL = 1;
  };
  programs.neovim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [
        nvim-treesitter.withAllGrammars
      ];
  };
  home.packages = [
    pkgs.logseq
    pkgs.xdg-utils
  ];
}
