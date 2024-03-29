" Modeline and Notes {
" vim: set foldmarker={,} foldlevel=0 foldmethod=marker :
" }

source ~/.vim/rc/functions.vim


" Basics {
set nocompatible        " Use vim defaults instead of vi compatibility
let mapleader="-"
" }

" Use plugins config {
source ~/.vim/plugins.vim
" }

" Colors {
" Enable true color
if exists('+termguicolors')
   let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
   let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
   set termguicolors
endif

" turn on undercurl support
let &t_Cs = "\e[4:3m"
let &t_Ce = "\e[4:0m"

" Set up colors
if exists('$BASE16_THEME')
      \ && (!exists('g:colors_name') || g:colors_name != 'base16-$BASE16_THEME')
    let base16colorspace=256
    colorscheme base16-$BASE16_THEME
endif

" style SignColumn the same as LineNr
" Not needed with base16 - not sure what theme this was needed for, maybe
" solarized?
" highlight! link SignColumn LineNr
" }

" Various {
syntax on               " turn on syntax hilighting
filetype plugin indent on

set backspace=indent,eol,start  " more flexible backspace

set autoindent          " turn on autoindenting
set ruler               " show cursor position
" set number              " show line numbers
set showmatch           " show matching brackets, parens, etc.
set hlsearch            " hilight last searched

set foldmethod=marker   " allow folding with {{{,}}}

" Make some messages shorter
set shortmess=filnxToOI

" Disable menus, toolbar; enable tab bar stuff
" Also disable left scrollbar due to flickery redraw when using tabs
set guioptions=agirte

" set font for gvim
set guifont=DejaVu\ Sans\ Mono\ 10

" Always show tab-line
set showtabline=2

" Suffixes that get lower priority when doing tab completion for filenames.
" These are files we are not likely to want to edit or read.
set suffixes=.bak,~,.swp,.o,.info,.aux,.log,.dvi,.bbl,.blg,.brf,.cb,.ind,.idx,.ilg,.inx,.out,.toc

set grepprg=grep\ -nH\ $* " requested setting by latexsuite
let g:Tex_ViewRule_pdf = 'evince'
let g:Tex_DefaultTargetFormat = 'pdf'

" Make tabs as spaces, tabs are 4 spaces, 4 spaces is a tab, still 4 spaces
set expandtab
set tabstop=4
set softtabstop=4
set shiftwidth=4

" Search incrementally, ignoring case, unless there are caps
set incsearch
set ignorecase
set smartcase

" The term is UTF-8, as should be files
set termencoding=utf-8
set encoding=utf-8

set swapsync=""         " Don't sync swap files
set autoread            " Automatically read files when changed outside vim and unchanged in vim

" }

" Keyboard mappings {
map <silent> <F8> :if exists(":BufExplorer")<Bar>exe "BufExplorer"<Bar>else<Bar>buffers<Bar>endif<CR>

" Turning paste mode on and off
set pastetoggle=<F11>

" Allow turning off highlighting
" Note: overrides move down 1
nmap <silent> <C-N> :silent nohlsearch<CR>

" Tabs {
nmap <leader>tn :tabnew<CR>
nmap <leader>tc :tabclose<CR>
" }
" }

" Unite config {
let g:unite_prompt='» '
let g:unite_source_history_yank_enable=1
let g:unite_source_rec_max_cache_files=0

call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#filters#sorter_default#use(['sorter_selecta'])
call unite#custom#source('file_rec,file_rec/async',
                        \ 'max_candidates', 0)

function! s:unite_settings()
    imap <buffer> <esc> <plug>(unite_exit)
    nmap <buffer> <esc> <plug>(unite_exit)
endfunction

autocmd FileType unite call s:unite_settings()

nnoremap <leader>p :<C-u>Unite -buffer-name=files   -start-insert file_rec/async:!<CR>
nnoremap <leader>e :<C-u>Unite -buffer-name=recent  -start-insert file_mru<cr>
nnoremap <leader>b :<C-u>Unite -buffer-name=buffers -start-insert buffer<cr>
nnoremap <leader>y :<C-u>Unite -buffer-name=yanks history/yank<cr>
"}

" Cscope setup {
" Read in cscope files if they exist
" FIXME: should make this run on loading C, C++ files
" and pick up from the same dir
if has("cscope")
  set csto=0
  set cst
  set nocsverb
  set cscopequickfix=s-,c-,d-,i-,t-,e-,g-
  set cspc=3
  " add any database in current directory
  if filereadable("cscope.out")
    cs add cscope.out
  " else add database pointed to by environment
  elseif $CSCOPE_DB != ""
    cs add $CSCOPE_DB
  endif

  nmap <C-\> :cs find c <C-R>=expand("<cword>")<CR><CR> 

  set csverb
endif
" }

autocmd VimResized * :wincmd =

" Qargs {
command! -nargs=0 -bar Qargs execute 'args' QuickfixFilenames()
function! QuickfixFilenames()
  " Building a hash ensures we get each buffer only once
  let buffer_numbers = {}
  for quickfix_item in getqflist()
    let buffer_numbers[quickfix_item['bufnr']] = bufname(quickfix_item['bufnr'])
  endfor
  return join(map(values(buffer_numbers), 'fnameescape(v:val)'))
endfunction
" }

" Status bar {
set laststatus=2
set statusline=[%n]             " buffer number
set statusline+=\ %<            " truncate here if the line is too long
set statusline+=%.99f           " filename, max length 99 characters
set statusline+=\ %h%w%m%r      " help, warning, modified, readonly flags
set statusline+=%y              " filetype
set statusline+=%=              " start right-aligned items
set statusline+=%-16(\ %l,%c-%v\ %) " line number, column number, virtual column number - left justified, minwidth 16
set statusline+=%P              " percent through the file
" }

" CtrlP settings {
let g:ctrlp_max_files = 500000     " show more files in very large directories
let g:ctrlp_switch_buffer = 'evht'   " jump to open buffer in current tab, or in another tab if opening in new tab
let g:ctrlp_root_markers = ['tags', 'TAGS', 'METADATA']
let g:ctrlp_match_window = 'top,order:ttb,min:1,max:10,results:100'
let g:ctrlp_match_func = { 'match' : 'pymatcher#PyMatch' }
" Use The Silver Searcher https://github.com/ggreer/the_silver_searcher
if executable('ag')
  " Use Ag over Grep
  set grepprg=ag\ --nogroup\ --nocolor

  " Use ag in CtrlP for listing files. Lightning fast and respects .gitignore
  let g:ctrlp_user_command = 'ag %s -l --hidden --nocolor -g ""'
endif
" }

" LSP completion settings {
" Send async completion requests.
" WARNING: Might interfere with other completion plugins.
let g:lsp_async_completion = 1

" Enable UI for diagnostics
let g:lsp_signs_enabled = 1           " enable diagnostics signs in the gutter
let g:lsp_diagnostics_echo_cursor = 1 " enable echo under cursor when in
normal mode

" Automatically show completion options
let g:asyncomplete_auto_popup = 1

function! s:on_lsp_buffer_enabled() abort
    setlocal omnifunc=lsp#complete
    setlocal signcolumn=yes
    if exists('+tagfunc') | setlocal tagfunc=lsp#tagfunc | endif
    nmap <buffer> <leader>gd <plug>(lsp-definition)
    nmap <buffer> <leader>gr <plug>(lsp-references)
    nmap <buffer> <leader>gi <plug>(lsp-implementation)
    nmap <buffer> <leader>gt <plug>(lsp-type-definition)
    nmap <buffer> <leader>rn <plug>(lsp-rename)
    nmap <buffer> [g <Plug>(lsp-previous-diagnostic)
    nmap <buffer> ]g <Plug>(lsp-next-diagnostic)
    nmap <buffer> K <plug>(lsp-hover)

    let g:lsp_format_sync_timeout = 1000
    autocmd! BufWritePre *.rs,*.go call execute('LspDocumentFormatSync')
endfunction

augroup lsp_install
    au!
    " call s:on_lsp_buffer_enabled only for languages that has the server
    " registered.
    autocmd User lsp_buffer_enabled call s:on_lsp_buffer_enabled()
augroup END
" }

call SourceAllInDirectory('~/.vim/rc/after/')

" workaround for base16 bustedness
hi SpellCap ctermbg=NONE
