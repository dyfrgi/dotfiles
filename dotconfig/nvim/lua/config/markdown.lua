require("image").setup({})
require("diagram").setup({})
require("markview").setup({
  preview = {
    modes = { "n", "no", "c", "i" },
    hybrid_modes = { "i" },
  },
})
require 'markview.extras.checkboxes'.setup {}
require 'mkdnflow'.setup {}

vim.api.nvim_create_user_command('DailyNote', function()
  local daily_file = os.date("daily/%Y-%m-%d.md")
  local daily_full_path = vim.fn.expand("~/notes/") .. daily_file
  vim.cmd("edit " .. daily_full_path)
end, {})

vim.keymap.set('n', '<leader>dn', ':DailyNote<CR>', { desc = 'Open Today\'s Daily Note' })
