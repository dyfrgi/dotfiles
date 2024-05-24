{pkgs, config, lib, ...}:
{
  programs.neovim = {
      enable = true;
      plugins = with pkgs.vimPlugins; [
#				mini-nvim
#				neo-tree-nvim
#        nvim-treesitter.withAllGrammars
#				suda-vim
				telescope-nvim
				telescope-fzf-native-nvim
				tokyonight-nvim
      ];
  };
}
