" Vim color file
"
" Author: Brian Mock <mock.brian@gmail.com>
"
" Note: Based on Oblivion color scheme for gedit (gtk-source-view)
"
" cool help screens
" :he group-name
" :he highlight-groups
" :he cterm-colors

hi clear

set background=dark
if version > 580
    " no guarantees for version 5.8 and below, but this makes it stop
    " complaining
    hi clear
    if exists("syntax_on")
	syntax reset
    endif
endif
let g:colors_name="darkspectrum"

hi Normal guifg=#eeeeec guibg=#2e3436

" highlight groups
hi Cursor		guibg=#ffffff guifg=#000000
hi CursorLine	guibg=#000000
"hi CursorLine	guibg=#3e4446
hi CursorColumn	guibg=#3e4446

"hi DiffText     guibg=#4e9a06 guifg=#FFFFFF gui=bold
"hi DiffChange   guibg=#4e9a06 guifg=#FFFFFF gui=bold
"hi DiffAdd      guibg=#204a87 guifg=#FFFFFF gui=bold
"hi DiffDelete   guibg=#5c3566 guifg=#FFFFFF gui=bold

hi DiffAdd         guifg=#ffcc7f guibg=#a67429 gui=none
hi DiffChange      guifg=#7fbdff guibg=#425c78 gui=none
hi DiffText        guifg=#7fbdff guibg=#425c78 gui=none
hi DiffDelete      guifg=#252723 guibg=#000000 gui=none
"hi ErrorMsg

hi Number		guifg=#fce94f

hi VertSplit	guibg=#eeeeec guifg=#000000 gui=none
hi Folded		guibg=#000000 guifg=#FFFFFF gui=bold
hi vimFold		guibg=#000000 guifg=#FFFFFF gui=bold
hi FoldColumn	guibg=#000000 guifg=#FFFFFF gui=bold

hi LineNr		guifg=#555753 guibg=#000000
hi NonText		guifg=#555753 guibg=#000000
hi Folded		guifg=#555753 guibg=#000000 gui=bold
hi FoldeColumn  guifg=#555753 guibg=#000000 gui=bold
hi StatusLine   guifg=#555753 guibg=#000000 gui=bold
hi StatusLineNC guifg=#555753 guibg=#000000 gui=none
hi VertSplit    guifg=#555753 guibg=#000000 gui=bold

hi StatusLine   guifg=#000000 guibg=#ffffff gui=none
hi StatusLineNC guifg=#000000 guibg=#aaaaaa gui=none

hi ModeMsg		guifg=#fce94f
hi MoreMsg		guifg=#fce94f
hi Visual		guifg=#FFFFFF guibg=#4e5456 gui=none
hi IncSearch	guibg=#FFFFFF guifg=#ef5939
hi Search		guibg=#ad7fa8 guifg=#FFFFFF
hi SpecialKey	guifg=#888a85

hi Title		guifg=#ef5939
hi WarningMsg	guifg=#ef5939
hi Number		guifg=#fcaf3e

hi MatchParen	guibg=#ad7fa8 guifg=#FFFFFF
hi Comment		guifg=#888a85
hi Constant		guifg=#ef5939 gui=none
hi String		guifg=#fce94f
hi Identifier	guifg=#729fcf
hi Statement	guifg=#ffffff
hi PreProc		guifg=#ffffff gui=bold
hi Type			guifg=#8ae234 gui=bold
hi Special		guifg=#e9b96e
hi Underlined	guifg=#ad7fa8 gui=underline
hi Directory	guifg=#729fcf
hi Ignore		guifg=#555753
hi Todo			guifg=#FFFFFF guibg=#ef5939 gui=bold
hi Function		guifg=#ad7fa8

hi link Error			Todo
hi link Character		Number
hi link rubySymbol		Number
hi link htmlTag			htmlEndTag
"hi link htmlTagName     htmlTag
hi link htmlLink		Underlined
hi link pythonFunction	Identifier
hi link Question		Type
hi link CursorIM		Cursor
hi link VisualNOS		Visual
hi link xmlTag			Identifier
hi link xmlTagName		Identifier
hi link shDeref			Identifier
hi link shVariable		Function
hi link rubySharpBang	Special
hi link perlSharpBang	Special
"hi link shSpecialVariables Constant
"hi link bashSpecialVariables Constant

" tabs (non gui)
hi TabLine		guifg=#AAAAAA guibg=#000000 gui=none
hi TabLineFill	guifg=#555753 guibg=#000000 gui=none
hi TabLineSel	guifg=#FFFFFF gui=bold
"hi TabLineSel	guifg=#FFFFFF guibg=#000000 gui=bold
" vim: sw=4 ts=4
