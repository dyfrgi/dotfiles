require 'blink.cmp'.setup {
  fuzzy = { implementation = "lua", prebuilt_binaries = { download = false } },
  sources = {
    default = { 'lsp', 'buffer', 'snippets', 'path' },
  },
}
require 'blink.cmp.fuzzy'.set_implementation('rust')
