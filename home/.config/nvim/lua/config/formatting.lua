require 'conform'.setup({
  default_format_opts = {
    lsp_format = "fallback"
  },
  notify_no_formatters = true,
  format_on_save = {
    timeout = 500
  },
})
vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
