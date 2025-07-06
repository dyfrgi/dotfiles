vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- -- Clipboard configuration
-- vim.g.clipboard = {
--   name = 'OSC 52',
--   copy = {
--     ['+'] = require('vim.ui.clipboard.osc52').copy('+'),
--     ['*'] = require('vim.ui.clipboard.osc52').copy('*'),
--   },
--   paste = {
--     ['+'] = require('vim.ui.clipboard.osc52').paste('+'),
--     ['*'] = require('vim.ui.clipboard.osc52').paste('*'),
--   },
-- }
vim.opt.clipboard = "unnamedplus" -- use the '+' register by default

local opt = vim.opt
opt.completeopt = "menu,menuone,noselect"
opt.conceallevel = 3  -- Hide * markup for bold and italic
opt.confirm = true    -- Confirm to save changes before exiting modified buffer
opt.cursorline = true -- Enable highlighting of the current line
opt.expandtab = true  -- Only use spaces for indenting, no hard tabs
opt.formatoptions = "tcqjroln"
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.ignorecase = true  -- ignore case in patterns by default...
opt.smartcase = true   -- except when there are capital letters
opt.laststatus = 3     -- always global statusline
opt.list = true        -- shows some invisible characters like tabs and trailing spaces
opt.mouse = "a"        -- enable mouse always
opt.number = true      -- print line numbers
opt.pumblend = 10      -- enable pseudo-transparency for the popup-menu
opt.pumheight = 10     -- show at most 10 items in the popup menu
opt.scrolloff = 4      -- lines of context
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
opt.shiftround = true  -- Round indent
opt.shiftwidth = 2     -- Size of an indent
opt.shortmess:append({ W = true, I = true, c = true, C = true })
opt.showmode = false   -- Dont show mode since we have a statusline
opt.sidescrolloff = 8  -- Columns of context
opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
opt.smartindent = true -- Insert indents automatically
opt.softtabstop = 2
opt.spelllang = { "en" }
opt.splitbelow = true    -- Put new windows below current
opt.splitkeep = "screen"
opt.splitright = true    -- Put new windows right of current
opt.tabstop = 2          -- Number of spaces tabs count for
opt.termguicolors = true -- True color support
opt.timeoutlen = 300
opt.title = true         -- Set terminal window title
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200               -- Save swap file and trigger CursorHold
opt.virtualedit = "block"          -- Allow cursor to move where there is no text in visual block mode
opt.wildmode = "longest:full,full" -- Command-line completion mode
opt.winminwidth = 5                -- Minimum window width
opt.wrap = false                   -- Disable line wrap
opt.fillchars = {
  foldopen = "",
  foldclose = "",
  -- fold = "⸱",
  fold = " ",
  foldsep = " ",
  diff = "╱",
  eob = " ",
}

-- Folding
opt.foldlevel = 99
opt.foldmethod = "indent" -- TODO: replace with treesitter

vim.cmd.colorscheme("tokyonight")

require("config.lsp")
require("config.telescope")
require("config.treesitter")
require("config.formatting")
require 'blink.cmp'.setup { fuzzy = { implementation = "lua", prebuilt_binaries = { download = false } } }
require 'blink.cmp.fuzzy'.set_implementation('rust')
require 'lualine'.setup {}
require 'gitsigns'.setup {}
require 'mini.git'.setup {}

require 'zk'.setup { picker = "telescope" }
require 'markview.extras.checkboxes'.setup {}

-- TODO
-- * git
-- * fix blink keymaps
-- * tabs!
-- * windows?
-- * vim-illuminate?
-- * indent-blankline
-- * conform autoformatting

-- Keybindings
-- code action (<leader>c)
vim.keymap.set({ 'v', 'n' }, "<leader>cf", require('conform').format, { desc = "Format file" })
vim.keymap.set('n', "<leader>cl", "<cmd>LspInfo<cr>", { desc = "Lsp Info" })
vim.keymap.set('n', "<leader>ca", vim.lsp.buf.code_action, { desc = "Code Action" })
vim.keymap.set('n', "<leader>cd", vim.diagnostic.open_float, { desc = "Line Diagnostics" })
vim.keymap.set('n', "K", vim.lsp.buf.hover, { desc = "Hover" })
vim.keymap.set('n', "gK", vim.lsp.buf.signature_help, { desc = "Signature Help" })

-- ui (<leader>u)
vim.keymap.set('n', "<leader>ur", "<cmd>nohl<cr>", { desc = "Clear Highlights" })

-- goto (g)
vim.keymap.set('n', "gd", function() require("telescope.builtin").lsp_definitions() end, { desc = "Goto Definition" })
vim.keymap.set('n', "gr", "<cmd>Telescope lsp_references<cr>", { desc = "References" })
vim.keymap.set('n', "gD", vim.lsp.buf.declaration, { desc = "Goto Declaration" })
vim.keymap.set('n', "gI", function() require("telescope.builtin").lsp_implementations() end,
  { desc = "Goto Implementation" })
vim.keymap.set('n', "gy", function() require("telescope.builtin").lsp_type_definitions() end,
  { desc = "Goto Type Definition" })

-- search
vim.keymap.set('n', '<leader><space>', '<cmd>Telescope find_files hidden=true<cr>', { desc = "Find Files (root dir)" })
vim.keymap.set('n', '<leader>sg', '<cmd>Telescope live_grep<cr>', { desc = "Grep (cwd)" })
vim.keymap.set('n', '<leader>sw',
  function() require('telescope.builtin').grep_string({ search = vim.fn.expand("<cword>") }) end,
  { desc = "Search word" })
vim.keymap.set('n', '<leader>,', '<cmd>Telescope buffers sort_mru=true sort_lastused=true<cr>',
  { desc = "Switch Buffer" })

-- insert mode
vim.keymap.set('i', "<c-k>", vim.lsp.buf.signature_help, { desc = "Signature Help" })

-- navigation
vim.keymap.set({ "n", "x", "o" }, "s", function() require("flash").jump() end, { desc = "Flash" })
vim.keymap.set({ "n", "o", "x" }, "S", function() require("flash").treesitter() end, { desc = "Flash Treesitter" })
vim.keymap.set("o", "r", function() require("flash").remote() end, { desc = "Remote Flash" })
vim.keymap.set({ "o", "x" }, "R", function() require("flash").treesitter_search() end, { desc = "Treesitter Search" })
vim.keymap.set("c", "<c-s>", function() require("flash").toggle() end, { desc = "Toggle Flash Search" })

-- buffers
vim.keymap.set('n', "bd", function() require 'mini.bufremove'.delete() end, { desc = "Delete Buffer" })
vim.keymap.set('n', "<leader>e", "<cmd>Neotree toggle<cr>", { desc = "Toggle Neotree" })

-- window navigation
require 'close_with_q' -- closes window and delete buffer for some ephemeral buffers with 'q'

-- git
vim.keymap.set('n', "<leader>gb", "<cmd>Gitsigns blame<cr>", { desc = "Show git blame" })
vim.keymap.set('n', "<leader>gb", "<cmd>Gitsigns blame_line<cr>", { desc = "Show git blame for current line" })
vim.keymap.set('n', "<leader>gs", function() MiniGit.show_at_cursor() end, { desc = "Show git history at cursor" })

require("which-key").setup({
  plugins = { spelling = true },
  spec = {
    {
      mode = { "n", "v" },
      { "<leader><tab>", group = "tabs" },
      { "<leader>b",     group = "buffer" },
      { "<leader>c",     group = "code" },
      { "<leader>f",     group = "file/find" },
      { "<leader>g",     group = "git" },
      { "<leader>gh",    group = "hunks" },
      { "<leader>q",     group = "quit/session" },
      { "<leader>s",     group = "search" },
      { "<leader>u",     group = "ui" },
      { "<leader>w",     group = "windows" },
      { "<leader>x",     group = "diagnostics/quickfix" },
      { "[",             group = "prev" },
      { "]",             group = "next" },
      { "g",             group = "goto" },
      { "gs",            group = "surround" },
    },
  },
})
