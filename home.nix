{pkgs, ...}:
let
  withCompilerFlags = (package: flags: package.overrideAttrs(old: {
      env = (old.env or {}) // { NIX_CFLAGS_COMPILE = toString (old.env.NIX_CFLAGS_COMPILE or "") + " ${toString flags}"; };
  }));
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
  programs.neovim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [
        nvim-treesitter.withAllGrammars
      ];
  };
  home.packages = [
    pkgs.lazygit
    pkgs.logseq
    pkgs.xdg-utils
    pkgs.yt-dlp
  ];
}
