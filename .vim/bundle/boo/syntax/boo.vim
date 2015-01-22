" Vim syntax file
" Language:	Boo
" Maintainer:	Tomas Restrepo (tomas@winterdom.com)
" Updated:	2007-03-22
"		Based on Neil Schemenauer <nas@boo.ca> python syntax
"               and Heath Stewart <clubstew@hotmail.com> csharp syntax 
"

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif


syn keyword booStatement	checked unchecked params ref
syn keyword booStatement	except ensure
syn keyword booStatement	pass raise
syn keyword booStatement	return try
syn keyword booStatement	global assert
syn keyword booStatement	public private protected static final self super
syn keyword booStatement	get set callable event
syn keyword booStatement	def nextgroup=booFunction skipwhite
syn keyword booClass		class interface struct enum nextgroup=booFunction skipwhite 
syn keyword booClass            namespace override
syn keyword booClass		virtual final abstract 
syn keyword booSpecial          Getter Setter Property
syn match   booFunction	        "[a-zA-Z_][a-zA-Z0-9_]*" contained
syn keyword booRepeat	        for while
syn keyword booConditional	if else elif
syn keyword booOperator	        and in is not or of cast as isa
syn keyword booPreCondit	import 

syn region  booCommentString    contained start=+"+ end=+"+ end=+$+ end=+\*/+me=s-1,he=s-1 contains=booSpecial,booCommentStar,booSpecialChar,@Spell
syn region  booComment2String   contained start=+"+  end=+$\|"+  contains=booSpecial,booSpecialChar,@Spell
syn match   booCommentCharacter contained "'\\[^']\{1,6\}'" contains=booSpecialChar
syn match   booCommentCharacter contained "'\\''" contains=booSpecialChar
syn match   booCommentCharacter contained "'[^\\]'"
syn region  booComment          start="/\*"  end="\*/" contains=booCommentString,booCommentCharacter,booNumber,booTodo,@Spell
syn match   booCommentStar      contained "^\s*\*[^/]"me=e-1
syn match   booCommentStar      contained "^\s*\*$"
syn match   booLineComment      "#.*$" contains=booTodo
syn match   booLineComment      "//.*" contains=booComment2String,booCommentCharacter,booNumber,booTodo,@Spell
syn keyword booTodo		TODO FIXME XXX contained

" strings
syn region booString		matchgroup=booStringDel start=+[uU]\='+ end=+'+ skip=+\\\\\|\\'+ contains=booEscape,booInterpolation
syn region booString		matchgroup=booStringDel start=+[uU]\="+ end=+"+ skip=+\\\\\|\\"+ contains=booEscape,booInterpolation
syn region booString		matchgroup=booStringDel start=+[uU]\="""+ end=+"""+ contains=booEscape,booInterpolation
syn region booString		matchgroup=booStringDel start=+[uU]\='''+ end=+'''+ contains=booEscape,booInterpolation
syn region booRawString	        matchgroup=booStringDel start=+[uU]\=[rR]'+ end=+'+ skip=+\\\\\|\\'+
syn region booRawString	        matchgroup=booStringDel start=+[uU]\=[rR]"+ end=+"+ skip=+\\\\\|\\"+
syn region booRawString	        matchgroup=booStringDel start=+[uU]\=[rR]"""+ end=+"""+
syn region booRawString	        matchgroup=booStringDel start=+[uU]\=[rR]'''+ end=+'''+
syn match  booInterpolation	"${[^}]*}"
syn match  booEscape		+\\[abfnrtv'"\\]+ contained
syn match  booEscape		"\\\o\{1,3}" contained
syn match  booEscape		"\\x\x\{2}" contained
syn match  booEscape		"\(\\u\x\{4}\|\\U\x\{8}\)" contained
syn match  booEscape		"\\$"

syn region booRegex             matchgroup=booRegexDel start="/\ze[^\/\*]" end="/" skip="\\/" contains=booEscape

 " numbers (including longs and complex)
syn match   booNumber	"\<0x\x\+[Ll]\=\>"
syn match   booNumber	"\<\d\+[LljJ]\=\>"
syn match   booNumber	"\.\d\+\([eE][+-]\=\d\+\)\=[jJ]\=\>"
syn match   booNumber	"\<\d\+\.\([eE][+-]\=\d\+\)\=[jJ]\=\>"
syn match   booNumber	"\<\d\+\.\d\+\([eE][+-]\=\d\+\)\=[jJ]\=\>"

syn keyword booTypes	        int byte short long object string 
syn keyword booTypes  	        uint ushort ulong sbyte date bool

syn keyword booConstant	        true false null

" built in functions and macros
syn keyword booBuiltins         array BooVersion enumerate iterator
syn keyword booBuiltins         gets join map matrix print prompt
syn keyword booBuiltins         range reversed shell zip
syn keyword booMacros           assert using lock debug

" This is fast but code inside triple quoted strings screws it up. It
" is impossible to fix because the only way to know if you are inside a
" triple quoted string is to start from the beginning of the file. If
" you have a fast machine you can try uncommenting the "sync minlines"
" and commenting out the rest.
syn sync match booSync grouphere NONE "):$"
syn sync maxlines=200
"syn sync minlines=2000

if !exists("did_boo_syn_inits")
  let did_boo_syn_inits = 1

  " The default methods for highlighting.  Can be overridden later
  hi link booClass              Type  
  hi link booTypes	        Type
  hi link booStatement	        Statement
  hi link booFunction		Function
  hi link booConditional	Conditional
  hi link booRepeat		Repeat
  hi link booString		String
  hi link booRegex		String
  hi link booRawString	        String
  hi link booEscape		Special
  hi link booOperator		Operator
  hi link booConstant		Constant
  hi link booPreCondit	        Preproc
  hi link booComment		Comment
  hi link booLineComment	Comment
  hi link booTodo		Todo
  hi link booSpecial            Special
  hi link booAttribute          Identifier
  hi link booNumber	        Number
  hi link booBuiltins           Special 
  hi link booMacros             Special 
  hi link booInterpolation      Special
  hi link booStringDel          Special
  hi link booRegexDel           Special
endif

let b:current_syntax = "boo"

" vim: ts=8
