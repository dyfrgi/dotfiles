require("image").setup({})
require("diagram").setup({})
require("markview").setup({
  preview = {
    modes = { "n", "no", "c", "i" },
    hybrid_modes = { "i" },
  },
})
require 'markview.extras.checkboxes'.setup {}
