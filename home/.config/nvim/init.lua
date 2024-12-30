vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.autowrite = true
vim.clipboard = "unnamedplus" -- use the '+' register by default

local opt = vim.opt
opt.completeopt = "menu,menuone,noselect"
opt.conceallevel = 3 -- Hide * markup for bold and italic
opt.confirm = true -- Confirm to save changes before exiting modified buffer
opt.cursorline = true -- Enable highlighting of the current line
opt.expandtab = true -- Only use spaces for indenting, no hard tabs
opt.formatoptions = "tcqjroln"
opt.grepformat = "%f:%l:%c:%m"
opt.grepprg = "rg --vimgrep"
opt.ignorecase = true -- ignore case in patterns by default...
opt.smartcase = true -- except when there are capital letters
opt.laststatus = 3 -- always global statusline
opt.list = true -- shows some invisible characters like tabs and trailing spaces
opt.mouse = "a" -- enable mouse always
opt.number = true -- print line numbers
opt.pumblend = 10 -- enable pseudo-transparency for the popup-menu
opt.pumheight = 10 -- show at most 10 items in the popup menu
opt.scrolloff = 4 -- lines of context
opt.sessionoptions = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" }
opt.shiftround = true -- Round indent
opt.shiftwidth = 2 -- Size of an indent
opt.shortmess:append({ W = true, I = true, c = true, C = true })
opt.showmode = false -- Dont show mode since we have a statusline
opt.sidescrolloff = 8 -- Columns of context
opt.signcolumn = "yes" -- Always show the signcolumn, otherwise it would shift the text each time
opt.smartindent = true -- Insert indents automatically
opt.softtabstop = 2
opt.spelllang = { "en" }
opt.splitbelow = true -- Put new windows below current
opt.splitkeep = "screen"
opt.splitright = true -- Put new windows right of current
opt.tabstop = 2 -- Number of spaces tabs count for
opt.termguicolors = true -- True color support
opt.timeoutlen = 300
opt.undofile = true
opt.undolevels = 10000
opt.updatetime = 200 -- Save swap file and trigger CursorHold
opt.virtualedit = "block" -- Allow cursor to move where there is no text in visual block mode
opt.wildmode = "longest:full,full" -- Command-line completion mode
opt.winminwidth = 5 -- Minimum window width
opt.wrap = false -- Disable line wrap
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

require("config.lazy")

require("lazy").setup({
  spec = {
    { import = "plugins" },
  },
  defaults = {
    lazy = false,
    version = false, -- always use the latest git commit
  },
  install = { colorscheme = { "tokyonight" } },
  checker = { enabled = true }, -- automatically check for plugin updates
  performance = {
    rtp = {
      reset = false,
      -- disable some rtp plugins
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
--        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})
