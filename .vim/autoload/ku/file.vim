" ku source: file
" Version: 0.0.2
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
" Variables  "{{{1

  " FIXME: more smart caching
  " BUGS: assumes that the current working directory is not changed in
  "       a single ku session.
let s:cached_items = {}  " pattern -> [item, ...]








" Interface  "{{{1
function! ku#file#event_handler(event, ...)  "{{{2
  if a:event ==# 'SourceEnter'
    let s:cached_items = {}
    return
  else
    return call('ku#default_event_handler', [a:event] + a:000)
  endif
endfunction




function! ku#file#action_table()  "{{{2
  return {
  \   'default': 'ku#file#action_open',
  \   'open!': 'ku#file#action_open_x',
  \   'open': 'ku#file#action_open',
  \ }
endfunction




function! ku#file#key_table()  "{{{2
  return {
  \   "\<C-o>": 'open',
  \   'O': 'open!',
  \   'o': 'open',
  \ }
endfunction




function! ku#file#gather_items(pattern)  "{{{2
  " FIXME: path separator assumption
  let cache_key = (a:pattern != '' ? a:pattern : "\<Plug>(ku)")
  if has_key(s:cached_items, cache_key)
    return s:cached_items[cache_key]
  endif

  let i = strridx(a:pattern, '/')
  let components = split(a:pattern, '/', !0)
  let root_directory_pattern_p = i == 0
  let user_seems_want_dotfiles_p = components[-1][:0] == '.'
  let wildcard = (user_seems_want_dotfiles_p
  \               ? ('{*,.*' . (root_directory_pattern_p ? '' : ',..') . '}')
  \               : '*')
  if i < 0  " no path separator
    let glob_pattern = wildcard
  elseif root_directory_pattern_p
    let glob_pattern = '/' . wildcard
  else  " more than one path separators
    let glob_pattern = join(components[:-2], '/') . '/' . wildcard
  endif

  let _ = []
  for entry in split(glob(glob_pattern), "\n")
    call add(_, {
    \      'word': entry,
    \      'menu': (isdirectory(entry) ? 'dir' : 'file'),
    \    })
  endfor

  let s:cached_items[cache_key] = _
  return _
endfunction




function! ku#file#acc_valid_p(item, sep)  "{{{2
  return a:sep ==# '/' && isdirectory(a:item.word)
endfunction








" Misc.  "{{{1
function! s:open(bang, item)  "{{{2
  execute 'edit'.a:bang fnameescape(a:item.word)
endfunction




" Actions  "{{{2
function! ku#file#action_open(item)  "{{{3
  call s:open('', a:item)
  return
endfunction


function! ku#file#action_open_x(item)  "{{{3
  call s:open('!', a:item)
  return
endfunction








" __END__  "{{{1
" vim: foldmethod=marker
