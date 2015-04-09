" Modeline and Notes {
" vim: set foldmarker={,} foldlevel=0 foldmethod=marker :
" }

" Basics {
set nocompatible        " Use vim defaults instead of vi compatibility
let mapleader="-"
" }

" Use plugins config {
source ~/.vim/plugins.vim
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
set guifont=DejaVu\ Sans\ Mono\ 8

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

" Don't sync swap files
set swapsync=""
" }

" Keyboard mappings {
map <silent> <F8> :if exists(":BufExplorer")<Bar>exe "BufExplorer"<Bar>else<Bar>buffers<Bar>endif<CR>

" Turning paste mode on and off
set pastetoggle=<F11>

" Allow turning off highlighting
" Note: overrides move down 1
nmap <silent> <C-N> :silent nohlsearch<CR>
" }

" Unite config {
let g:unite_prompt='» '
let g:unite_source_history_yank_enable=1

call unite#filters#matcher_default#use(['matcher_fuzzy'])
call unite#filters#sorter_default#use(['sorter_selecta'])

" Unite config {
function! s:unite_settings()
    imap <buffer> <esc> <plug>(unite_exit)
    nmap <buffer> <esc> <plug>(unite_exit)
endfunction

" autocmd FileType unite call s:unite_settings()

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

" Colors {
" Set up colors
set background=dark
let base16colorspace=256
colorscheme base16-isotope
" style SignColumn the same as LineNr
" Not needed with base16 - not sure what theme this was needed for, maybe
" solarized?
" highlight! link SignColumn LineNr
" }

" Tagbar {
nnoremap <silent> <leader>tt :TagbarToggle<CR>
" }

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
set statusline=[%n]\ %<%.99f\ %h%w%m%r%y%=%-16(\ %l,%c-%v\ %)%P
" }

let g:ctrlp_max_files = 200000     " show more files in very large directories
let g:ctrlp_switch_buffer = ''    " don't jump to already open buffers
let g:ctrlp_root_markers = ['tags']
