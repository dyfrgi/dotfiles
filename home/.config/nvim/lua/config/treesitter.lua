require'nvim-treesitter.configs'.setup {
  modules = {
    highlight = {
      enable = true
    }
  }
}
require'treesitter-context'.setup{
  max_lines = 5
}
