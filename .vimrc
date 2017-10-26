set runtimepath=~/.vim,$VIMRUNTIME,~/.vim/after
" enable clipboard and other Win32 features
source $VIMRUNTIME/mswin.vim

" Use pathogen.vim to manage and load plugins
call pathogen#runtime_append_all_bundles()
call pathogen#helptags()

"
" appearance options
"
set bg=dark
let g:zenburn_high_Contrast = 1
let g:liquidcarbon_high_contrast = 1
let g:molokai_original = 1

let g:airline#extensions#tabline#enabled = 1
let g:airline_theme='powerlineish'
let g:airline_powerline_fonts = 1
let g:airline_linecolumn_prefix = '§'
let g:airline_enable_syntastic=1


set t_Co=256
colorscheme molokai

if has("gui_running")
   " set default size: 90x35
   set columns=90
   set lines=35
   " No menus and no toolbar
   set guioptions-=m
   set guioptions-=T
endif

set modeline
set tabstop=2 " tab size = 2
set shiftwidth=2 " soft space = 2
set smarttab
set expandtab " expand tabs
set wildchar=9 " tab as completion character

set virtualedit=block
set clipboard+=unnamed  " Yanks go on clipboard instead.
set showmatch " Show matching braces.

" Line wrapping on by default
set wrap
set linebreak

if has("win32") || has("win64")
   set guifont=Input:h14
   set directory=$TMP
   if !has("gui_running")
      colorscheme slate
   end
elseif has("mac")
   set directory=/tmp
   set guifont=Input:h14
else
   set directory=/tmp
   set guifont=Input\ 14
endif

set history=50 " keep track of last commands
set number ruler " show line numbers
set incsearch " incremental searching on
set hlsearch " highlight all matches
set smartcase
set cursorline
set selectmode=key
"set showtabline=2 " show always for console version
set laststatus=2 " Always show the statusline
set tabline=%!MyTabLine()
set wildmenu " menu on statusbar for command autocomplete
" default to UTF-8 encoding
set encoding=utf8
set fileencoding=utf8
" enable visible whitespace
set listchars=tab:»·,trail:·,precedes:<,extends:>
set list

" no beep
autocmd VimEnter * set vb t_vb= 

" tab navigation like firefox
nmap <C-S-tab> :tabprevious<cr>
nmap <C-tab> :tabnext<cr>
map <C-S-tab> :tabprevious<cr>
map <C-tab> :tabnext<cr>
imap <C-S-tab> <ESC>:tabprevious<cr>i
imap <C-tab> <ESC>:tabnext<cr>i
nmap <C-t> :tabnew<cr>
imap <C-t> <ESC>:tabnew<cr> 
" map \tx for the console version as well
if !has("gui_running")
   nmap <Leader>tn :tabnext<cr>
   nmap <Leader>tp :tabprevious<cr>
   nmap <Leader><F4> :tabclose<cr>
end

" Map Ctrl-E Ctrl-W to toggle linewrap option like in VS
noremap <C-E><C-W> :set wrap!<CR>
" Map Ctrl-M Ctrl-L to expand all folds like in VS
noremap <C-M><C-L> :%foldopen!<CR>
" Remap omni-complete to avoid having to type so fast
inoremap <C-Space> <C-X><C-O>

" Windows like movements for long lines with wrap enabled:
noremap j gj
noremap k gk

" disable warnings from NERDCommenter:
let g:NERDShutUp = 1

" Make sure taglist doesn't change the window size
let g:Tlist_Inc_Winwidth = 0
nnoremap <silent> <F8> :TlistToggle<CR>

" language specific customizations:
let g:python_highlight_numbers = 1

" set custom file types I've configured
au BufNewFile,BufRead *.ps1  setf ps1
au BufNewFile,BufRead *.boo  setf boo
au BufNewFile,BufRead *.config  setf xml
au BufNewFile,BufRead *.xaml  setf xml
au BufNewFile,BufRead *.xoml  setf xml
au BufNewFile,BufRead *.blogTemplate  setf xhtml
au BufNewFile,BufRead *.brail  setf xhtml
au BufNewFile,BufRead *.rst  setf xml
au BufNewFile,BufRead *.rsb  setf xml
au BufNewFile,BufRead *.io  setf io
au BufNewFile,BufRead *.notes setf notes
au BufNewFile,BufRead *.mg setf mg

syntax on " syntax hilight on
syntax sync fromstart 
filetype plugin indent on

runtime xmlpretty.vim
command! -range=% Xmlpretty :call XmlPretty(<line1>, <line2>)
map <C-K><C-F> :Xmlpretty<CR>

"
" Bind NERD_Tree plugin to a <Ctrl+E,Ctrl+E>
"
noremap <C-E><C-E> :NERDTree<CR>
noremap <C-E><C-C> :NERDTreeClose<CR>

"
" Configure TOhtml command
"
let html_number_lines = 0
let html_ignore_folding = 1
let html_use_css = 1
"let html_no_pre = 0
let use_xhtml = 1

"
" Configure Ku
"
let g:ku_component_separators='/\\'
"
" Configure syntax specific options
"
let python_highlight_all = 1

"
" Enable spellchecking conditionally
"
map <Leader>se :setlocal spell spelllang=en_us<CR>
map <Leader>ss :setlocal spell spelllang=es_es<CR>
map <Leader>sn :setlocal nospell<CR>

"
" Other stuff
"
runtime 'macros/matchit.vim'
au VimEnter * RainbowParenthesesToggle
au Syntax * RainbowParenthesesLoadRound
au Syntax * RainbowParenthesesLoadSquare
au Syntax * RainbowParenthesesLoadBraces

" 
" Configure tabs for the console version
"
function! MyTabLine()
  let s = ''
  for i in range(tabpagenr('$'))
    " select the highlighting
    if i + 1 == tabpagenr()
      let s .= '%#TabLineSel#'
    else
      let s .= '%#TabLine#'
    endif

    " set the tab page number (for mouse clicks)
    let s .= '%' . (i + 1) . 'T'

    " the label is made by MyTabLabel()
    let s .= ' %{MyTabLabel(' . (i + 1) . ')} '
  endfor

  " after the last tab fill with TabLineFill and reset tab page nr
  let s .= '%#TabLineFill#%T'

  " right-align the label to close the current tab page
  if tabpagenr('$') > 1
    let s .= '%=%#TabLine#%999Xclose'
  endif

  return s
endfunction

function! MyTabLabel(n)
  let buflist = tabpagebuflist(a:n)
  let winnr = tabpagewinnr(a:n)
  return bufname(buflist[winnr - 1])
endfunction

