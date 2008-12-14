" ku source: history
" Version: 0.0.0
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

let s:cached_items = []

if !exists('g:ku_history_fallback_source')
  let g:ku_history_fallback_source = 'file'
endif

if !exists('g:ku_history_sorting_style')
  let g:ku_history_sorting_style = 'time'
endif








" Interface  "{{{1
function! ku#history#event_handler(event, ...)  "{{{2
  if a:event ==# 'SourceEnter'
    let _ = {}
    for i in copy(ku#input_history())
      let sources = get(_, i.pattern, {})
      let time = get(sources, i.source, 0)
      let sources[i.source] = max([time, i.time])
      let _[i.pattern] = sources
    endfor

    let s:cached_items = []
    for [pattern, sources] in items(_)
      for [source, time] in items(sources)
        call add(s:cached_items, {
        \      'word': pattern,
        \      'menu': source,
        \      'dup': 1,
        \      '_ku_sort_priority': (g:ku_history_sorting_style ==# 'time'
        \                            ? -time
        \                            : 0),
        \    })
      endfor
    endfor
    return
  else
    return call('ku#default_event_handler', [a:event] + a:000)
  endif
endfunction




function! ku#history#action_table()  "{{{2
  return {
  \   'default': 'ku#history#action_open',
  \   'open': 'ku#history#action_open',
  \ }
endfunction




function! ku#history#key_table()  "{{{2
  return {
  \   "\<C-o>": 'open',
  \   'o': 'open',
  \ }
endfunction




function! ku#history#gather_items(pattern)  "{{{2
  return s:cached_items
endfunction








" Misc.  "{{{1
" Actions  "{{{2
function! ku#history#action_open(item)  "{{{3
  let pattern = a:item.word
  let source = a:item.menu

  if !ku#available_source_p(source)
    let source = g:ku_history_fallback_source
  endif

  call ku#start(source, pattern)
  return
endfunction








" __END__  "{{{1
" vim: foldmethod=marker
