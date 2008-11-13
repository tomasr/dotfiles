"----------------------------------------------------------------------------
"  Description: Vim MGrammar syntax file
"     Language: MGrammar
"    Copyright: Copyright (C) 2008 Fredrik Eriksson
"   Maintainer: Fredrik Eriksson
"      Version: 1.0
"      History: 01.11.2008 First release
"------------------------------------------------------------------------------

syntax keyword mgKeyword any error token syntax left 
syntax keyword mgKeyword right new override virtual partial identifer
syntax keyword mgKeyword keyword checkpoint interleave nest 
syntax keyword mgKeyword precendence empty nell final id 
syntax keyword mgInclude import export
syntax keyword mgStatement labelof valuesof
syntax keyword mgBoolean true false
syntax keyword mgStorageClass module language

syntax region  mgString	contains=@Spell start=+"+ skip=+""+ end=+"+ 
syntax region  mgString	contains=@Spell start=+'+ skip=+''+ end=+'+ 

syn keyword mgTodo contained TODO FIXME TEMP XXX REVISIT
syn region mgBlockComment start="/\*"  end="\*/" contains=mgTodo,@Spell
syn match mgLineComment	"//.*" contains=dTodo,@Spell

syntax match mgCurlyError "}"
syntax region mgBlock start="{" end="}" contains=ALLBUT, mgCurlyError, mgParenGroup, @Spell fold
syntax cluster mgParenGroup contains=mgIncluded
syn region mgIncluded display contained start=+"+ skip=+\\\\\|\\"+ end=+"+

highlight def link mgKeyword 		Keyword
highlight def link mgString 		String
highlight def link mgBlockComment 	Comment
highlight def link mgLineComment	Comment
highlight def link mgInclude		Include
highlight def link mgStatement		Statement
highlight def link mgBoolean		Boolean
highlight def link mgStorageClass	StorageClass

"vim: textwidth=78 nowrap tabstop=8 shiftwidth=3 softtabstop=3 noexpandtab
"vim: foldmethod=marker
