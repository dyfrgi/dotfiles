{pkgs, config, lib, ...}:
{
  programs.neovim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [
        nvim-treesitter.withAllGrammars
      ];
      extraPackages = with pkgs; [
        fzf
      ];
  };
}
