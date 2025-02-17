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
require 'lspconfig'.nixd.setup {}
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
