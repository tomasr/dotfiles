" Vim compiler file
" Compiler:         MGrammar Compiler
" Maintainer:       Fredrik Eriksson <fredrik.eriksson@thebc.se>
" Latest Revision:  2008-11-01

if exists("current_compiler")
	finish
endif
let current_compiler = "mg"

" The errorformat for MGrammar Compiler is the default.
CompilerSet errorformat&
CompilerSet makeprg=mg\ -nologo\ \"%:p\"
