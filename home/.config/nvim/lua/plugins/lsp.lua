return {
  {
    "folke/lazydev.nvim",
    ft = "lua", -- only load on lua files
    opts = {
      library = {
        -- See the configuration section for more details
        -- Load luvit types when the `vim.uv` word is found
        { path = "${3rd}/luv/library", words = { "vim%.uv" } },
      },
    },
  },
  {
    "neovim/nvim-lspconfig",
    event = "VeryLazy",
    keys = {
      { "<leader>cl", "<cmd>LspInfo<cr>", desc = "Lsp Info" },
      { "gd", function() require("telescope.builtin").lsp_definitions({ reuse_win = true }) end, desc = "Goto Definition" },
      { "gr", "<cmd>Telescope lsp_references<cr>", desc = "References" },
      { "gD", vim.lsp.buf.declaration, desc = "Goto Declaration" },
      { "gI", function() require("telescope.builtin").lsp_implementations({ reuse_win = true }) end, desc = "Goto Implementation" },
      { "gy", function() require("telescope.builtin").lsp_type_definitions({ reuse_win = true }) end, desc = "Goto T[y]pe Definition" },
      { "K", vim.lsp.buf.hover, desc = "Hover" },
      { "gK", vim.lsp.buf.signature_help, desc = "Signature Help" },
      { "<c-k>", vim.lsp.buf.signature_help, mode = "i", desc = "Signature Help" },
      { "<leader>ca", vim.lsp.buf.code_action, desc = "Code Action", mode = { "n", "v" } },
      {
        "<leader>cA",
        function()
          vim.lsp.buf.code_action({
            context = {
              only = {
                "source",
              },
              diagnostics = {},
            },
          })
        end,
        desc = "Source Action",
      },
      { "<leader>cr", vim.lsp.buf.rename, desc = "Rename" },
    },
    config = function(_, _)
      require'lspconfig'.rust_analyzer.setup {}
      require'lspconfig'.lua_ls.setup {}
      -- require'lspconfig'.lua_ls.setup {
      --   on_init = function(client)
      --     if client.workspace_folders then
      --       local path = client.workspace_folders[1].name
      --       if vim.loop.fs_stat(path..'/.luarc.json') or vim.loop.fs_stat(path..'/.luarc.jsonc') then
      --         return
      --       end
      --     end
      --
      --     client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
      --       runtime = {
      --         -- Tell the language server which version of Lua you're using
      --         -- (most likely LuaJIT in the case of Neovim)
      --         version = 'LuaJIT'
      --       },
      --       -- Make the server aware of Neovim runtime files
      --       workspace = {
      --         checkThirdParty = false,
      --         library = {
      --           vim.env.VIMRUNTIME
      --           -- Depending on the usage, you might want to add additional paths here.
      --           -- "${3rd}/luv/library"
      --           -- "${3rd}/busted/library",
      --         }
      --         -- or pull in all of 'runtimepath'. NOTE: this is a lot slower and will cause issues when working on your own configuration (see https://github.com/neovim/nvim-lspconfig/issues/3189)
      --         -- library = vim.api.nvim_get_runtime_file("", true)
      --       }
      --     })
      --   end,
      --   settings = {
      --     Lua = {}
      --   }
      -- }
    end,
  },
}
