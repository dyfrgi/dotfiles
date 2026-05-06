require 'zk'.setup {
  picker = "telescope",
  lsp = {
    config = {
      name = "zk",
      cmd = { "zk", "lsp" },
      filetypes = { "markdown" },
    },
    auto_attach = { enabled = true, },
  }
}

vim.keymap.set("n", "<leader>zn", "<Cmd>ZkNew { title = vim.fn.input('Title: ') }<CR>",
  { desc = "Create new note with title" })
vim.keymap.set("n", "<leader>zo", "<Cmd>ZkNotes { sort = { 'modified' } }<CR>", { desc = "Open notes" })
vim.keymap.set("n", "<leader>zt", "<Cmd>ZkTags<CR>", { desc = "Open notes associated with selected tag" })
vim.keymap.set("n", "<leader>zf", "<Cmd>ZkNotes { sort = { 'modified' }, match = { vim.fn.input('Search: ') } }<CR>",
  { desc = "Search for notes" })
vim.keymap.set("v", "<leader>zf", ":'<,'>ZkMatch<CR>", { desc = "Search for notes matching selection" })
