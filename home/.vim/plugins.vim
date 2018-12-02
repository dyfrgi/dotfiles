set nocompatible
filetype off

set runtimepath+=~/.vim/bundle/neobundle.vim/

" Required:
 call neobundle#begin(expand('~/.vim/bundle/'))

" Let NeoBundle manage NeoBundle
" Required:
NeoBundleFetch 'Shougo/neobundle.vim'

let g:neobundle#install_process_timeout = 1500

" My Bundles here:
" Refer to |:NeoBundle-examples|.
" Note: You don't set neobundle setting in .gvimrc!

" git integration
NeoBundle 'tpope/vim-fugitive', { 'augroup' : 'fugitive' }
NeoBundle 'altercation/vim-colors-solarized'    " solarized color scheme
NeoBundle 'ctrlpvim/ctrlp.vim'                  " CtrlP file finder etc.
NeoBundle 'FelikZ/ctrlp-py-matcher'             " Ctrl-P matcher
NeoBundle 'octol/vim-cpp-enhanced-highlight'    " Better C++ highlighting
NeoBundle 'rking/ag.vim'                        " Ag grep replacement
NeoBundle 'netrw.vim'                           " Latest netrw
NeoBundle 'vim-syntastic/syntastic'             " syntastic syntax checker
NeoBundle 'wlangstroth/vim-racket'              " Racket syntax etc
NeoBundle 'jakwings/vim-pony'                   " Pony syntax highlighting, auto-tab, bracket matching
NeoBundle 'killerswan/pony-currycomb.vim'       " Pony syntastic support

NeoBundle 'mhinz/vim-signify'                   " Use sign column to show VCS changes

NeoBundle 'Shougo/vimproc.vim', {
        \ 'build' : {
        \     'windows' : 'tools\\update-dll-mingw',
        \     'cygwin' : 'make -f make_cygwin.mak',
        \     'mac' : 'make -f make_mac.mak',
        \     'unix' : 'make -f make_unix.mak',
        \    },
        \ }
NeoBundle 'Shougo/unite.vim'                    " Unite search and display plugin
" MRU support for Unite
NeoBundle 'Shougo/neomru.vim', {'autoload': {'unite_sources': 'file_mru'}}
NeoBundle 'majutsushi/tagbar', {'autoload': {'commands':['TagbarToggle']}}

NeoBundle 'chriskempson/tomorrow-theme', { 'rtp': 'vim' }
NeoBundle 'chriskempson/base16-vim'

NeoBundle 'dyfrgi/patchreview-vim'              " :PatchReview, :DiffReview

NeoBundle 'andymass/vim-matchup'

call neobundle#end()

" Required:
filetype plugin indent on

" If there are uninstalled bundles found on startup,
" this will conveniently prompt you to install them.
NeoBundleCheck
