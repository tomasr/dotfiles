" rob.robb.ns
" Last Change: 3 sep 2009

set background=dark
hi clear
if exists("syntax_on")
    syntax reset
endif

let g:colors_name="twilight"

hi Normal         guifg=#F8F8F8           guibg=#141414
hi Cursor         guifg=#141414           guibg=#f8f8f8
hi CursorLine	  						  guibg=#3f3c40
hi Directory      guifg=#8F9D6A           guibg=#141414
hi VertSplit      guifg=#3f3c40           guibg=#3f3c40
hi Folded         guifg=#888888           guibg=#282828
hi FoldColumn	  guifg=#cf6a4c           guibg=#141414
hi vimFold		  guifg=#f8f8f8			  guibg=#282828
hi IncSearch      guifg=#4f94cd           guibg=#f8f8f8
hi LineNr         guifg=#a6a6a6           guibg=#141414
hi ModeMsg        guifg=#f9ee98           guibg=#141414
hi MoreMsg        guifg=#f9ee98           guibg=#141414
hi NonText        guifg=#665f57           guibg=#141414
hi Search         guifg=#f8f8f8           guibg=#4f94cd
hi StatusLine     guifg=#0E2231           guibg=#8693A5
hi StatusLineNC   guifg=#0e2231           guibg=#8693a5
hi Visual         guifg=#f8f8f8           guibg=#4f94cd
hi WildMenu       guifg=#9b70f3           guibg=#0e2231
hi MatchParen	  guifg=#f8f8f8		      guibg=#4f94cd
hi ErrorMsg		  guifg=#cf6a4c           guibg=NONE
hi WarningMsg	  guifg=#cf6a4c			  guibg=NONE

"Syntax hilight groups

hi Comment        guifg=#665f57
hi Constant       guifg=#7587a6
hi String         guifg=#8f9d6a
hi Variable       guifg=#7587a6
hi Number         guifg=#cf6a4c
hi Boolean        guifg=#CF6A4C
hi Float          guifg=#cf6a4c
hi Identifier     guifg=#7587a6
hi Statement      guifg=#cda869
hi Keyword        guifg=#cda869
hi PreProc        guifg=#7587a6
hi Type           guifg=#9b859d				
hi Typedef        guifg=#cda869
hi Special        guifg=#cda869
hi SpecialChar    guifg=#7587a6
hi SpecialComment guifg=#4f94cd
hi Ignore         guifg=#888888
hi Error          guifg=#cf6a4c          guibg=NONE
hi Todo           guifg=#f9ee98
hi Pmenu          guifg=#8693a5          guibg=#0e2231
hi PmenuSel       guifg=#cda869          guibg=#0e2231
hi PmenuSbar      guibg=#665f57
hi PmenuThumb     guifg=#a6a6a6
