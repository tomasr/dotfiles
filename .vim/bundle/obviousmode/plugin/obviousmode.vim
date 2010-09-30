" ObviousMode: Clearly indicate visually whether Vim is in insert mode via the
" StatusLine highlight group.
"
" 1.22, 2010.09.14
"
" Brian Lewis <brian@lorf.org>
" Sergey Vlasov <sergey.vlsv@gmail.com>
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
"      let g:obviousModeModifiedCurrentHi = 'your settings'
"      let g:obviousModeModifiedNonCurrentHi = 'your settings'
"      let g:obviousModeModifiedVertSplitHi = 'your settings'
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

if !exists('g:obviousModeModifiedCurrentHi')
    let g:obviousModeModifiedCurrentHi = 'term=reverse ctermbg=30'
endif

if !exists('g:obviousModeModifiedNonCurrentHi')
    let g:obviousModeModifiedNonCurrentHi = 'term=reverse ctermbg=30'
endif

if !exists('g:obviousModeModifiedVertSplitHi')
    let g:obviousModeModifiedVertSplitHi = 'term=reverse ctermfg=22 ctermbg=30'
endif

let s:isInsertMode = 0
let s:atCmdwin = 0

" a dict of all possible highlight attrs set to 'none'
" make this once, make copies of it later
let s:hlAttrs = {}
for n in ['term', 'cterm', 'ctermfg', 'ctermbg', 'gui', 'guifg', 'guibg', 'guisp']
    let s:hlAttrs[n] = 'NONE'
endfor

let s:originalHi = {}
function! s:SaveOriginalHi()
    for n in ['StatusLine', 'StatusLineNC', 'VertSplit']
    " capture current values of highlight attrs
    let l:orig = ''
        redir => l:orig | silent exec 'highlight '.n | redir END

    " parse out attributes and values, put into dict
    let l:hlAttrs = copy(s:hlAttrs)
    for token in split(l:orig)[2:-1]
        let [attr, value] = split(token, '=')
        let l:hlAttrs[attr] = value
    endfor

    " save augmented original attributes
        let s:originalHi[n] = join(map(items(l:hlAttrs), 'v:val[0]."=".v:val[1]'))
    endfor
endfunction

function! s:HasModifiedBuffers()
    let l:NBuffers=bufnr('$')
    let l:i = 0

    while (l:i <= l:NBuffers)
        let l:i = l:i + 1
        let l:BufName = bufname(l:i)
        if(getbufvar(l:i, '&modified') == 1)
            return 1
        endif
    endwhile

    return 0
endfunction

function! s:InsertEnter()
    let s:isInsertMode = 1
    exec 'hi StatusLine '.g:obviousModeInsertHi
endfunction

function! s:InsertLeave()
    let s:isInsertMode = 0
    if s:hasModifiedBuffers
        exec 'hi StatusLine '.g:obviousModeModifiedCurrentHi
    else
        exec 'hi StatusLine '.s:originalHi['StatusLine']
    endif
endfunction

function! s:CmdwinEnter()
    let s:atCmdwin = 1
    exec 'hi StatusLine '.g:obviousModeCmdwinHi
endfunction

function! s:CmdwinLeave()
    let s:atCmdwin = 0
    if s:hasModifiedBuffers
        exec 'hi StatusLine '.g:obviousModeModifiedCurrentHi
    else
        exec 'hi StatusLine '.s:originalHi['StatusLine']
    endif
endfunction

function! s:BufferChanged()
    let s:hasModifiedBuffers = s:HasModifiedBuffers()
    if s:hasModifiedBuffers
        if !s:isInsertMode && !s:atCmdwin
            exec 'hi StatusLine '.g:obviousModeModifiedCurrentHi
        endif

        exec 'hi StatusLineNC '.g:obviousModeModifiedNonCurrentHi
        exec 'hi VertSplit '.g:obviousModeModifiedVertSplitHi
    else
        if !s:isInsertMode && !s:atCmdwin
            exec 'hi StatusLine '.s:originalHi['StatusLine']
        endif

        exec 'hi StatusLineNC '.s:originalHi['StatusLineNC']
        exec 'hi VertSplit '.s:originalHi['VertSplit']
    endi
endfunction

au VimEnter,ColorScheme * call s:SaveOriginalHi()

au InsertEnter * call s:InsertEnter()
au InsertLeave * call s:InsertLeave()
au CmdwinEnter * call s:CmdwinEnter()
au CmdwinLeave * call s:CmdwinLeave()
au CursorMoved,CursorMovedI,BufWritePost,FileWritePost * call s:BufferChanged()

let g:loaded_obviousmode = 1
