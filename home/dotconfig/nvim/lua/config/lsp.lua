vim.lsp.enable('rust_analyzer')
vim.lsp.config('lua_ls', {
  settings = {
    Lua = {
      diagnostics = {
        disable = { "missing-fields" }
      }
    }
  }
})
vim.lsp.enable('lua_ls')
vim.lsp.enable('jsonls')
vim.lsp.config('nixd', {
  settings = {
    nixd = {
      options = {
        home_manager = {
          expr = '(builtins.getFlake ("git+file://" + toString ./.)).homeConfigurations."msl".options',
        },
      }
    }
  }
})
vim.lsp.enable('nixd')
vim.lsp.enable('pylsp')
require 'lazydev'.setup(
  {
    library = {
      { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      { path = "LazyVim",            words = { "LazyVim" } },
      { path = "snacks.nvim",        words = { "Snacks" } },
      { path = "lazy.nvim",          words = { "LazyVim" } },
    },
  })
require 'fidget'.setup {}
vim.lsp.enable('clangd')
vim.lsp.enable('marksman')
