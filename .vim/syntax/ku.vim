" Vim syntax: ku
" Version: 0.1.8
" Copyright (C) 2008 kana <http://whileimautomaton.net/>
" License: MIT license  {{{
"     Permission is hereby granted, free of charge, to any person obtaining
"     a copy of this software and associated documentation files (the
"     "Software"), to deal in the Software without restriction, including
"     without limitation the rights to use, copy, modify, merge, publish,
"     distribute, sublicense, and/or sell copies of the Software, and to
"     permit persons to whom the Software is furnished to do so, subject to
"     the following conditions:
"
"     The above copyright notice and this permission notice shall be included
"     in all copies or substantial portions of the Software.
"
"     THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
"     OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
"     MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.
"     IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY
"     CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT,
"     TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE
"     SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
" }}}

if exists('b:current_syntax')
  finish
endif




syntax case match

syntax match kuStatusLine /\%1l.*/
\            contains=kuSourcePrompt,kuSourceName,kuHistoryInfo
syntax match kuSourcePrompt /^Source/ contained
syntax match kuSourceName /: \zs[a-zA-Z-]*/ contained
syntax match kuHistoryInfo ! (\zs\d+/\d+\ze)$! contained

syntax match kuInputLine /\%2l.*/ contains=kuInputPrompt
syntax match kuInputPrompt /^>/ contained nextgroup=kuInputPattern
syntax match kuInputPattern /.*/ contained




highlight default link kuSourcePrompt  Statement
highlight default link kuSourceName  Type
highlight default link kuHistoryInfo  NONE
highlight default link kuInputPrompt  Statement
highlight default link kuInputPattern  NONE

" The following definitions are for <Plug>(ku-choose-an-action).  See
" s:choose_action() in autoload/ku.vim for the details.
highlight default link kuChooseAction  NONE
highlight default link kuChooseItem  NONE
highlight default link kuChooseKey  SpecialKey
highlight default link kuChooseMessage  NONE
highlight default link kuChoosePrompt  kuSourcePrompt
highlight default link kuChooseSource  kuSourceName




let b:current_syntax = 'ku'

" __END__
" vim: foldmethod=marker
