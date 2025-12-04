require("tokyonight").setup {
  on_colors = function(colors)
    colors.border = colors.orange
  end
}
-- vim.cmd.colorscheme("tokyonight")

vim.g.gruvbox_material_background = 'hard'
vim.g.gruvbox_material_foreground = 'original'
vim.g.gruvbox_material_enable_bold = 1
vim.g.gruvbox_material_colors_override = { bg0 = { '#171717', '234' } }
vim.cmd.colorscheme("gruvbox-material")
