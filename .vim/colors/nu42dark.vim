" Vim color file -- nu42dark.vim
" Modified from CandyCode
" Maintainer:   A. Sinan Unur <sinan@unur.com>
" Last Change:  20111125

set background=dark
highlight clear
let g:colors_name="nu42dark"

let save_cpo = &cpo
set cpo&vim

hi Normal       guifg=#f7f7f7       guibg=#0f0a1f       gui=NONE
            \   ctermfg=white       ctermbg=black       cterm=NONE

hi Folded       guifg=#bfaf9f       guibg=NONE          gui=NONE
            \   ctermfg=lightgray   ctermbg=black       cterm=NONE

hi LineNr       guifg=#8fbfaf       guibg=NONE          gui=NONE
            \   ctermfg=darkgray    ctermbg=NONE        cterm=NONE

hi Directory    guifg=#3884da       guibg=NONE          gui=NONE
            \   ctermfg=cyan        ctermbg=NONE        cterm=NONE

hi NonText      guifg=#ffeda1       guibg=NONE          gui=bold
            \   ctermfg=yellow      ctermbg=NONE        cterm=NONE

hi SpecialKey   guifg=#38da84       guibg=NONE          gui=NONE
            \   ctermfg=green       ctermbg=NONE        cterm=NONE

hi SpellBad     guifg=NONE          guibg=NONE          gui=undercurl
            \   ctermfg=white       ctermbg=darkred     guisp=#ff0011

hi SpellCap     guifg=NONE          guibg=NONE          gui=undercurl
            \   ctermfg=white       ctermbg=darkblue    guisp=#0044ff

hi SpellLocal   guifg=NONE          guibg=NONE          gui=undercurl
            \   ctermfg=black       ctermbg=cyan        guisp=#00dd99   

hi SpellRare    guifg=NONE          guibg=NONE          gui=undercurl
            \   ctermfg=white       ctermbg=darkmagenta guisp=#ff22ee   

hi DiffAdd      guifg=#ffffff       guibg=#126493       gui=NONE
            \   ctermfg=white       ctermbg=darkblue    cterm=NONE

hi DiffChange   guifg=#000000       guibg=#976398       gui=NONE
            \   ctermfg=black       ctermbg=darkmagenta cterm=NONE

hi DiffDelete   guifg=#000000       guibg=#be1923       gui=bold
            \   ctermfg=black       ctermbg=red         cterm=bold

hi DiffText     guifg=#ffffff       guibg=#976398       gui=bold
            \   ctermfg=white       ctermbg=green       cterm=bold

hi FoldColumn   guifg=#c8bcb9       guibg=#786d65       gui=bold            
            \   ctermfg=lightgray   ctermbg=darkgray    cterm=NONE

hi SignColumn   guifg=#c8bcb9       guibg=#786d65       gui=bold
            \   ctermfg=lightgray   ctermbg=darkgray    cterm=NONE

hi Pmenu        guifg=#000000       guibg=#a6a190       gui=NONE
            \   ctermfg=white       ctermbg=darkgray    cterm=NONE

hi PmenuSel     guifg=#ffffff       guibg=#133293       gui=NONE
            \   ctermfg=white       ctermbg=lightblue   cterm=NONE

hi PmenuSbar    guifg=NONE          guibg=#555555       gui=NONE
            \   ctermfg=black       ctermbg=black       cterm=NONE

hi PmenuThumb   guifg=NONE          guibg=#cccccc       gui=NONE
            \   ctermfg=gray        ctermbg=gray        cterm=NONE

hi StatusLine   guifg=#0f0f1f       guibg=#7f9faf       gui=bold    
            \   ctermfg=black       ctermbg=white       cterm=bold

hi StatusLineNC guifg=#3f3f48       guibg=#ccbbbf       gui=NONE    
            \   ctermfg=darkgray    ctermbg=white       cterm=NONE

hi WildMenu     guifg=#ffffff       guibg=#1f3f9f       gui=bold
            \   ctermfg=white       ctermbg=darkblue    cterm=bold

hi VertSplit    guifg=#99acbd       guibg=#99acbd       gui=NONE
            \   ctermfg=white       ctermbg=white       cterm=NONE

hi TabLine      guifg=#000000       guibg=#c2bfa5       gui=NONE
            \   ctermfg=black       ctermbg=white       cterm=NONE

hi TabLineFill  guifg=#000000       guibg=#c2bfa5       gui=NONE
            \   ctermfg=black       ctermbg=white       cterm=NONE

hi TabLineSel   guifg=#ffffff       guibg=#133293       gui=NONE
            \   ctermfg=white       ctermbg=black       cterm=NONE

hi Cursor       guifg=#f0f080       guibg=#3f3fef       gui=bold,underline
            \   ctermfg=black       ctermbg=white       cterm=NONE

hi CursorIM     guifg=#f0f080       guibg=#3f3fef       gui=bold,underline
            \   ctermfg=black       ctermbg=white       cterm=reverse

hi CursorLine   guifg=NONE          guibg=#1f1a2f       gui=NONE
            \   ctermfg=NONE        ctermbg=NONE        cterm=NONE

hi CursorColumn guifg=NONE          guibg=#1f1a2f       gui=NONE
            \   ctermfg=NONE        ctermbg=NONE        cterm=NONE

hi Visual       guifg=#ffffff       guibg=#2f6f4f       gui=NONE
            \   ctermfg=white       ctermbg=lightgreen   cterm=NONE

hi VisualNOS    guifg=#ffffff       guibg=#1f3f2f       gui=NONE
            \   ctermfg=white       ctermbg=green   cterm=NONE

hi IncSearch    guifg=#000000       guibg=#efdf3f       gui=bold 
            \   ctermfg=white       ctermbg=yellow      cterm=NONE

hi Search       guifg=#efefd0       guibg=#5f9f4f       gui=NONE
            \   ctermfg=white       ctermbg=darkgreen   cterm=NONE

hi MatchParen   guifg=NONE          guibg=#3377aa       gui=NONE
            \   ctermfg=white       ctermbg=blue        cterm=NONE

hi ModeMsg      guifg=#f09050       guibg=NONE          gui=NONE
            \   ctermfg=yellow      ctermbg=NONE        cterm=NONE

hi Title        guifg=#dd4452       guibg=NONE          gui=bold
            \   ctermfg=red         ctermbg=NONE        cterm=bold

hi Question     guifg=#66d077       guibg=NONE          gui=NONE
            \   ctermfg=green       ctermbg=NONE        cterm=NONE

hi MoreMsg      guifg=#39d049       guibg=NONE          gui=NONE
            \   ctermfg=green       ctermbg=NONE        cterm=NONE

hi ErrorMsg     guifg=#ffffff       guibg=#ff0000       gui=bold
            \   ctermfg=white       ctermbg=red         cterm=bold

hi WarningMsg   guifg=#ccae22       guibg=NONE          gui=bold    
            \   ctermfg=yellow      ctermbg=NONE        cterm=bold

hi Comment      guifg=#8fcfaf       guibg=NONE          gui=italic
            \   ctermfg=brown       ctermbg=NONE        cterm=NONE

hi Constant     guifg=#ef7f6f       guibg=NONE          gui=NONE
            \   ctermfg=red         ctermbg=NONE        cterm=NONE

hi Boolean      guifg=#ef4fff       guibg=NONE          gui=bold  
            \   ctermfg=red         ctermbg=NONE        cterm=bold

hi Identifier   guifg=#dfdf6f       guibg=NONE          gui=NONE
            \   ctermfg=yellow      ctermbg=NONE        cterm=NONE

hi Statement    guifg=#6fef7f       guibg=NONE          gui=bold
            \   ctermfg=green       ctermbg=NONE        cterm=bold

hi PreProc      guifg=#afafaf       guibg=NONE          gui=NONE
            \   ctermfg=darkgreen   ctermbg=NONE        cterm=NONE

hi Type         guifg=#9f9fef       guibg=NONE          gui=bold
            \   ctermfg=lightblue   ctermbg=NONE        cterm=bold

hi Special      guifg=#9f9faf       guibg=NONE          gui=bold  
            \   ctermfg=lightgray   ctermbg=NONE        cterm=bold

hi Underlined   guifg=#8fafff       guibg=NONE          gui=underline
            \   ctermfg=NONE        ctermbg=NONE        cterm=underline
            \   term=underline 

hi Ignore       guifg=#8f8f8f       guibg=NONE          gui=NONE
            \   ctermfg=darkgray    ctermbg=NONE        cterm=NONE

hi Error        guifg=#ffffff       guibg=#ff0000       gui=NONE
            \   ctermfg=white       ctermbg=red         cterm=NONE

hi Todo         guifg=#ffffff       guibg=#ee7700       gui=bold
            \   ctermfg=black       ctermbg=yellow      cterm=bold

let &cpo = save_cpo

