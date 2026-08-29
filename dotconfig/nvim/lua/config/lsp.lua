vim.lsp.enable('rust_analyzer')
-- vim.lsp.config('lua_ls', {
--   settings = {
--     Lua = {
--       diagnostics = {
--         disable = { "missing-fields" }
--       }
--     }
--   }
-- })
-- vim.lsp.enable('lua_ls')
vim.lsp.enable('jsonls')
vim.lsp.config('nixd', {
  settings = {
    nixd = {
      options = {
        home_manager = {
          expr = '(builtins.getFlake ("git+file://" + toString ./.)).homeConfigurations."msl".options',
        },
        nixos = {
          expr = '(builtins.getFlake ("git+file://" + toString ./.)).nixosConfigurations.snail.options',
        },
      },
      nixpkgs = {
        expr = '(builtins.getFlake ("git+file://" + toString ./.)).inputs.nixpkgs { }',
      },
    }
  }
})
vim.lsp.enable('nixd')
vim.lsp.enable('pylsp')
require 'lazydev'.setup {}
vim.lsp.enable('lua_ls')
require 'fidget'.setup {}
vim.lsp.enable('clangd')
vim.lsp.enable('marksman')
