" Vim syntax file
" Language:    Python
" Maintainer:  Tomas Restrepo <tomas@winterdom.com>
"     Extends the basic python syntax to handle better highlighting
"
syn keyword pythonDef      def class nextgroup=pythonFunction skipwhite
syn match pythonFunction   "[a-zA-Z_][a-zA-Z0-9_]*" contained nextgroup=pythonArgs skipwhite
syn region pythonArgs      matchgroup=Normal start="(" end=")" contained transparent contains=ALL
syn match pythonArgName    "[a-zA-Z_][a-zA-Z0-9_]*" contained

syn keyword pythonSelf  self

hi link pythonDef       Typedef
hi link pythonArgName   Identifier
hi link pythonSelf      Special
