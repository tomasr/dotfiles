" Vim syntax file
" Language:	Windows PowerShell
" Maintainer:	Peter Provost <peter@provost.org>
" Version: 2.8
" Url: http://www.vim.org/scripts/script.php?script_id=1327
" 
" $LastChangedDate: 2007-03-05 21:18:39 -0800 (Mon, 05 Mar 2007) $
" $Rev: 58 $
"
" Contributions by:
" 	Jared Parsons <jaredp@beanseed.org>
" 	Heath Stewart <heaths@microsoft.com>
" 	Tomas Restrepo <tomas@winterdom.com>

" Compatible VIM syntax file start
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

" PowerShell doesn't care about case
syn case ignore

" Sync-ing method
syn sync minlines=100

syn cluster ps1NotTop contains=@ps1Comment,ps1CDocParam,ps1Function


" Comments and special comment words
syn keyword ps1CommentTodo TODO FIXME XXX TBD HACK contained
syn match ps1CDocParam /.*/ contained
syn match ps1CommentDoc /^\s*\zs\.\w\+\>/ nextgroup=ps1CDocParam contained
syn match ps1CommentDoc /#\s*\zs\.\w\+\>/ nextgroup=ps1CDocParam contained
syn match ps1Comment /#.*/ contains=ps1CommentTodo,ps1CommentDoc
syn region ps1Comment start="<#" end="#>" contains=ps1CommentTodo,ps1CommentDoc

" Language keywords and elements
syn keyword ps1Conditional if else elseif switch
syn keyword ps1Repeat while default for do until break continue
syn match ps1Repeat /\<foreach\>/ nextgroup=ps1Cmdlet
syn keyword ps1Keyword return filter in trap throw param begin process end
syn match ps1Keyword /\<while\>/ nextgroup=ps1Cmdlet

" Functions and Cmdlets
syn match ps1Cmdlet /\w\+-\w\+/
syn keyword ps1Keyword function nextgroup=ps1Function skipwhite
syn match ps1Function /\w\+-*\w*/ contained

" Type declarations
syn match ps1Type /\[[a-z0-9_:.]\+\(\[\]\)\?\]/
"syn match ps1StandaloneType /[a-z0-9_.]\+/ contained
syn keyword ps1Scope global local private script contained

" Variables and other user defined items
syn match ps1Variable /\$\w\+/
syn match ps1Variable /\${.\+}/
syn match ps1ScopedVariable /\$\w\+:\w\+/ contains=ps1Scope
"syn match ps1VariableName /\w\+/ contained

" Operators all start w/ dash
syn match ps1OperatorStart /-c\?/ nextgroup=ps1Operator
syn keyword ps1Operator eq ne ge gt lt le like notlike match notmatch replace /contains/ notcontains contained
syn keyword ps1Operator ieq ine ige igt ile ilt ilike inotlike imatch inotmatch ireplace icontains inotcontains contained
syn keyword ps1Operator ceq cne cge cgt clt cle clike cnotlike cmatch cnotmatch creplace ccontains cnotcontains contained
syn keyword ps1Operator is isnot as contained
syn keyword ps1Operator and or band bor not contained
syn keyword ps1Operator f contained
syn keyword ps1Operator split contained

" Regular Strings
syn region ps1String start=/"/ skip=/`"/ end=/"/ contains=@ps1StringSpecial
syn region ps1String start=/'/ end=/'/  

" Here-Strings
syn region ps1String start=/@"$/ end=/^"@$/ contains=@ps1StringSpecial
syn region ps1String start=/@'$/ end=/^'@$/

" Interpolation
syn match ps1Escape /`./ contained
syn region ps1Interpolation matchgroup=ps1InterpolationDelimiter start="$(" end=")" contained contains=ALLBUT,@ps1NotTop
syn region ps1NestedParentheses start="(" skip="\\\\\|\\)" matchgroup=ps1Interpolation end=")" transparent contained
syn cluster ps1StringSpecial contains=ps1Escape,ps1Interpolation,ps1Variable,ps1Boolean,ps1Constant,ps1BuiltIn

" Numbers
syn match ps1Number /\<[0-9]\+/
syn match ps1Number /\<0x[0-9A-Fa-f]\+/
syn match ps1Number /\<[0-9]\*\.[0-9]\+/

" constants
syn match ps1Boolean /\$true\|\$false/
syn match ps1Constant /\$null/
syn match ps1BuiltIn /\$_\|\$\^\|\$\$\|\$?/
syn match ps1BuiltIn /\$args\|\$error\|\$foreach\|\$home\|\$input/
syn match ps1BuiltIn /\$match\|\$myinvocation\|\$host\|\$lastexitcode/
syn match ps1BuiltIn /\$ofs\|\$shellid\|\$stacktrace/

" Setup default color highlighting
if version >= 508 || !exists("did_ps1_syn_inits")
  if version < 508
    let did_ps1_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink ps1String String
  HiLink ps1Escape SpecialChar
  HiLink ps1InterpolationDelimiter Delimiter
  HiLink ps1Conditional Conditional
  HiLink ps1Function Function
  HiLink ps1Variable Identifier
  HiLink ps1ScopedVariable Identifier
"  HiLink ps1VariableName Identifier
  HiLink ps1Type Type
  HiLink ps1Scope Type
"  HiLink ps1StandaloneType Type
  HiLink ps1Number Number
  HiLink ps1Comment Comment
  HiLink ps1CommentDoc Tag
  HiLink ps1CDocParam Todo
  HiLink ps1CommentTodo Todo
  HiLink ps1Operator Operator
  HiLink ps1Repeat Repeat
  HiLink ps1RepeatAndCmdlet Repeat
  HiLink ps1Keyword Keyword
  HiLink ps1KeywordAndCmdlet Keyword
  HiLink ps1Cmdlet Statement
  HiLink ps1Boolean Boolean
  HiLink ps1Constant Constant
  HiLink ps1BuiltIn StorageClass
  delcommand HiLink
endif

let b:current_syntax = "powershell"
