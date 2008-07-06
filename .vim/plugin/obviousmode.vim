" ObviousMode: Clearly indicate visually whether Vim is in insert mode via the
" StatusLine highlight group.
"
" Brian Lewis <brian@lorf.org>
" 1.21 2008.04.25
"
" Thank you:
"   frogonwheels @ freenode #vim
"   Markus Braun
"   Erik Falor
"
" 1. Put obviousmode.vim in plugins/
" 2. You probably want to
"      set laststatus=2
" 3. Optionally,
"      let g:obviousModeInsertHi = 'your settings'
"      let g:obviousModeCmdwinHi = 'your settings'
"        (see :h highlight-args)

if &cp || exists('g:loaded_obviousmode')
    finish
endif

if !exists('g:obviousModeInsertHi')
    let g:obviousModeInsertHi = 'term=reverse ctermbg=52'
endif

if !exists('g:obviousModeCmdwinHi')
    let g:obviousModeCmdwinHi = 'term=reverse ctermbg=22'
endif

" a dict of all possible highlight attrs set to 'none'
" make this once, make copies of it later
let s:hlAttrs = {}
for n in ['term', 'cterm', 'ctermfg', 'ctermbg', 'gui', 'guifg', 'guibg', 'guisp']
    let s:hlAttrs[n] = 'NONE'
endfor

function! s:SaveOriginalHi()
    " capture current values of highlight attrs
    let l:orig = ''
    redir => l:orig | silent highlight StatusLine | redir END

    " parse out attributes and values, put into dict
    let l:hlAttrs = copy(s:hlAttrs)
    for token in split(l:orig)[2:-1]
        let [attr, value] = split(token, '=')
        let l:hlAttrs[attr] = value
    endfor

    " save augmented original attributes
    let s:originalHi = join(map(items(l:hlAttrs), 'v:val[0]."=".v:val[1]'))
endfunction

function! s:InsertEnter()
    exec 'hi StatusLine '.g:obviousModeInsertHi
endfunction

function! s:InsertLeave()
    exec 'hi StatusLine '.s:originalHi
endfunction

function! s:CmdwinEnter()
    exec 'hi StatusLine '.g:obviousModeCmdwinHi
endfunction

function! s:CmdwinLeave()
    exec 'hi StatusLine '.s:originalHi
endfunction

au VimEnter,ColorScheme * call s:SaveOriginalHi()

au InsertEnter * call s:InsertEnter()
au InsertLeave * call s:InsertLeave()
au CmdwinEnter * call s:CmdwinEnter()
au CmdwinLeave * call s:CmdwinLeave()

let g:loaded_obviousmode = 1
