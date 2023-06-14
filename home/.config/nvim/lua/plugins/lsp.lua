return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        clangd = {},
        jsonls = {
          -- disable installing jsonls
          mason = false,
        },
      },
    },
  },
}
