set runtimepath=~/.vim,$VIMRUNTIME,~/.vim/after
" enable clipboard and other Win32 features
source $VIMRUNTIME/mswin.vim

"
" appearance options
"
if has("win32") || has("win64")
   set guifont=Envy\ Code\ R:h13
else
   set guifont=Envy\ Code\ R\ 16
end
set bg=dark

if has("gui_running")
   colorscheme molokai
   let g:zenburn_high_Contrast = 1
   " set default size: 90x35
   set columns=90
   set lines=35
   " No menus and no toolbar
   set guioptions-=m
   set guioptions-=T
   let g:obviousModeInsertHi = "guibg=Black guifg=White"
else
   let g:obviousModeInsertHi = "term=reverse ctermbg=5"
endif

set tabstop=3 " tab size = 3
set shiftwidth=3 " soft space = 3
set smarttab
set expandtab " expand tabs
set wildchar=9 " tab as completion character

set virtualedit=block
set clipboard+=unnamed  " Yanks go on clipboard instead.
set showmatch " Show matching braces.

" Line wrapping on by default
set wrap
set linebreak
" Map Ctrl-E Ctrl-W to toggle linewrap option like in VS
noremap <C-E><C-W> :set wrap!<CR>
" Map Ctrl-M Ctrl-L to expand all folds like in VS
noremap <C-M><C-L> :%foldopen!<CR>
" Remap omni-complete to avoid having to type so fast
inoremap <C-Space> <C-X><C-O>

set history=50 " keep track of last commands
set number ruler " show line numbers
set incsearch " incremental searching on
set hlsearch " highlight all matches
set ignorecase
set cursorline
set selectmode=key
set showtabline=2 " show always for console version
set tabline=%!MyTabLine()
" default to UTF-8 encoding
set encoding=utf8
set fileencoding=utf8

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

" make tab and shift-tab work like windows
vmap <silent> <Tab>        :<C-u>call Cream_indent("v")<CR>
imap <silent> <S-Tab> <C-o>:call Cream_unindent("i")<CR>
vmap <silent> <S-Tab>      :<C-u>call Cream_unindent("v")<CR>

" Windows like movements for long lines with wrap enabled:
noremap j gj
noremap k gk

" disable warnings from NERDCommenter:
let g:NERDShutUp = 1

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
au BufNewFile,BufRead *.rst  setf html
au BufNewFile,BufRead *.rsb  setf xml
au BufNewFile,BufRead *.io  setf io

syntax on " syntax hilight on
syntax sync fromstart 
filetype plugin indent on

" enable visible whitespace
set listchars=tab:»·,trail:·,precedes:<,extends:>
set list

runtime xmlpretty.vim
command! -range=% Xmlpretty :call XmlPretty(<line1>, <line2>)
map <C-K><C-F> :Xmlpretty<CR>

"
" Bind NERD_Tree plugin to a <Ctrl+E,Ctrl+E>
"
noremap <C-E><C-E> :NERDTree<CR>

"
" Configure TOhtml command
"
let html_number_lines = 0
let html_ignore_folding = 1
let html_use_css = 1
let html_no_pre = 1
let use_xhtml = 1

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
" Configure tabs for the console version
"
function MyTabLine()
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

function MyTabLabel(n)
  let buflist = tabpagebuflist(a:n)
  let winnr = tabpagewinnr(a:n)
  return bufname(buflist[winnr - 1])
endfunction



"
" helper functions from Cream
"
function! Cream_pos(...)
" return current position in the form of an executable command
" Origins: Benji Fisher's foo.vim, available at
"          http://vim.sourceforge.net

	"let mymark = "normal " . line(".") . "G" . virtcol(".") . "|"
	"execute mymark
	"return mymark

	" current pos
	let curpos = line(".") . "G" . virtcol(".") . "|"

	" mark statement
	let mymark = "normal "

	" go to screen top
	normal H
	let mymark = mymark . line(".") . "G"
	" go to screen bottom
	normal L
	let mymark = mymark . line(".") . "G"

	" go back to curpos
	execute "normal " . curpos

	" cat top/bottom screen marks to curpos
	let mymark = mymark . curpos

	execute mymark
	return mymark

endfunction

function! Cream_indent(mode)
	if a:mode == "v"
		normal gv
		normal >
		normal gv
	endif
endfunction

function! Cream_unindent(mode)
	if a:mode == "v"
		normal gv
		normal <
		normal gv
	elseif a:mode == "i"
		let mypos = Cream_pos()
		" select line and unindent
		normal V
		normal <
		execute mypos
		" now adjust for shift
		let i = 0
		let myline = line('.')
		while i < &tabstop
			normal h
			" oops, go back to current line if we jumped up
			if line('.') < myline
				normal l
			endif
			let i = i + 1
		endwhile
		" select one char so
		" * user can see a selection is in place
		" * if tab is used immediately following this routine believes
		"   the whole line is selected rather than inserting a single
		"   tab
		normal vl
		if mode() == "v"
			" change to select mode
			execute "normal \<C-G>"
		endif
	endif
endfunction

"
" Status line configuration gotten from: XXXXX
"
set ls=2 " Always show status line
if has('statusline')
   " Status line detail:
   " %f		file path
   " %y		file type between braces (if defined)
   " %([%R%M]%)	read-only, modified and modifiable flags between braces
   " %{'!'[&ff=='default_file_format']}
   "			shows a '!' if the file format is not the platform
   "			default
   " %{'$'[!&list]}	shows a '*' if in list mode
   " %{'~'[&pm=='']}	shows a '~' if in patchmode
   " (%{synIDattr(synID(line('.'),col('.'),0),'name')})
   "			only for debug : display the current syntax item name
   " %=		right-align following items
   " #%n		buffer number
   " %l/%L,%c%V	line number, total number of lines, and column number
   function SetStatusLineStyle()
      if &stl == '' || &stl =~ 'synID'
         let &stl="%f %y%([%R%M]%)%{'!'[&ff=='".&ff."']}%{'$'[!&list]}%{'~'[&pm=='']}%=#%n %l/%L,%c%V "
      else
         let &stl="%f %y%([%R%M]%)%{'!'[&ff=='".&ff."']}%{'$'[!&list]} (%{synIDattr(synID(line('.'),col('.'),0),'name')})%=#%n %l/%L,%c%V "
      endif
   endfunc
   " Switch between the normal and vim-debug modes in the status line
   nmap _ds :call SetStatusLineStyle()<CR>
   call SetStatusLineStyle()
   " Window title
   if has('title')
	   set titlestring=%t%(\ [%R%M]%)
   endif
endif

