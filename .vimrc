set nocompatible        " Use vim defaults instead of vi compatibility
set rtp+=~/.vim/bundle/vundle/
call vundle#rc()

" Let Vundle manage Vundle
Bundle 'gmarik/vundle'

" get vim-ruby from git since vim 7.3's is broken
Bundle 'vim-ruby/vim-ruby'
Bundle 'tpope/vim-rails'

syntax on               " turn on syntax hilighting
filetype plugin indent on " for Vundle

set backspace=indent,eol,start  " more flexible backspace

set autoindent          " turn on autoindenting
set ruler               " show cursor position
set number              " show line numbers
set showmatch           " show matching brackets, parens, etc.

" Make some messages shorter
set shortmess=filnxToOI

" Disable menus, toolbar; enable tab bar stuff
" Also disable left scrollbar due to flickery redraw when using tabs
set guioptions=agirte

" set GUI font to Bitstream Vera Sans Mono 9
set guifont=Bitstream\ Vera\ Sans\ Mono\ 9

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
set tabstop=2
set softtabstop=2
set shiftwidth=2

" Search incrementally, ignoring case, unless there are caps
set incsearch
set ignorecase
set smartcase

" The term is UTF-8, as should be files
set termencoding=utf-8
set encoding=utf-8

" (Maybe) asynchronous sync() for swap files
set swapsync=sync

""" Keyboard mappings
" Allow turning off highlighting
" Note: overrides move down 1
nmap <silent> <C-N> :silent noh<CR>

" Turning paste mode on and off: F10 on, F11 off
map <F10> :set paste<CR>
map <F11> :set nopaste<CR>
imap <F10> <C-O>:set paste<CR>
imap <F11> <nop>
set pastetoggle=<F11>

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

" Set up various filetypes
augroup dyfrgi
augroup end

" Set up colors
let xterm16_colormap = 'soft'
colorscheme xterm16
