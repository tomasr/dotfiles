
set nocompatible            " disable compatibility to old-time vi
set showmatch               " show matching 
set ignorecase              " case insensitive 
set mouse=v                 " middle-click paste with 
set hlsearch                " highlight search 
set incsearch               " incremental search
set tabstop=2               " number of columns occupied by a tab 
set softtabstop=2           " see multiple spaces as tabstops so <BS> does the right thing
set smarttab
set expandtab               " converts tabs to white space
set shiftwidth=2            " width for autoindents
set autoindent              " indent a new line the same amount as the line just typed
set number                  " add line numbers

set wrap
set linebreak

set smartcase
set cursorline
set selectmode=key

" default to UTF-8 encoding
set encoding=utf8
set fileencoding=utf8
" enable visible whitespace
set listchars=tab:»·,trail:·,precedes:<,extends:>
set list

set wildmode=longest,list   " get bash-like tab completions
" set cc=80                   " set an 80 column border for good coding style
filetype plugin indent on   " allow auto-indenting depending on file type
syntax on                   " syntax highlighting
set mouse=a                 " enable mouse click
set clipboard=unnamedplus   " using system clipboard
filetype plugin on
set cursorline              " highlight current cursorline
set ttyfast                 " Speed up scrolling in Vim
" set spell                 " enable spell check (may need to download language package)
" set noswapfile            " disable creating swap file
" set backupdir=~/.cache/vim " Directory to store backup files.

call plug#begin()
Plug 'sainnhe/everforest'
Plug 'navarasu/onedark.nvim'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'nvim-treesitter/nvim-treesitter', {'do': ':TSUpdate'}
Plug 'HiPhish/rainbow-delimiters.nvim'
call plug#end()

let g:onedark_config = {
      \ 'style': 'darker',
      \}
colorscheme everforest

let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='powerlineish'
let g:airline_powerline_fonts = 1
let g:airline_linecolumn_prefix = '§'
let g:airline_enable_syntastic=1

lua require('config')
