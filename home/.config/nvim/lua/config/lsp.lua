require 'lspconfig'.rust_analyzer.setup {}
require 'lspconfig'.lua_ls.setup {
  settings = {
    Lua = {
      diagnostics = {
        disable = { "missing-fields" }
      }
    }
  }
}
require 'lspconfig'.jsonls.setup {}
require 'lspconfig'.nixd.setup {
  settings = { nixd = { options = {
    home_manager = {
      expr = '(builtins.getFlake ("git+file://" + toString ./.)).homeConfigurations."msl".options',
    },
  } } }
}
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
