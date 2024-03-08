local cmp = require("cmp")
return {
 "hrsh7th/nvim-cmp",
  opts = {
    completion = {
      completeopt = "menu,menuone,noselect",
    },
    mapping = cmp.mapping.preset.insert({
      ["<CR>"] = cmp.mapping.confirm({ select = false }),
    }),
  }
}
