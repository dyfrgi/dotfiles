require'telescope'.setup {
  defaults = {
    file_ignore_patterns = { "^.git/" },
  },
}
require'telescope'.load_extension("fzf")
