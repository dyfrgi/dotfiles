return {
  {
    "neovim/nvim-lspconfig",
    opts = {
      servers = {
        jsonls = {
          -- disable installing jsonls
          mason = false,
        },
      },
    },
  },
}
