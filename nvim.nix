{pkgs, config, lib, ...}:
{
  programs.neovim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [
        nvim-treesitter.withAllGrammars
        telescope-fzf-native-nvim
      ];
      extraPackages = with pkgs; [
        fzf
        lua-language-server
        rust-analyzer
      ];
  };
}
