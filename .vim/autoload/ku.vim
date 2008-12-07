" ku - Support to do something
" Version: 0.1.4
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

" Misc.
let s:FALSE = 0
let s:TRUE = !s:FALSE


" The buffer number of ku.
let s:INVALID_BUFNR = -1
if exists('s:bufnr') && bufexists(s:bufnr)
  execute s:bufnr 'bwipeout'
endif
let s:bufnr = s:INVALID_BUFNR


" The name of the ku buffer.
if !exists('g:ku_buffer_name')
  if has('win16') || has('win32') || has('win64')  " on Microsoft Windows
    let g:ku_buffer_name = '[ku]'
  else
    let g:ku_buffer_name = '*ku*'
  endif
endif


" The name of the current source given to ku#start() or :Ku.
let s:INVALID_SOURCE = '*invalid*'
let s:current_source = s:INVALID_SOURCE


" For automatic completion.
let s:KEYS_TO_START_COMPLETION = "\<C-x>\<C-o>\<C-p>"
let s:PROMPT = '>'  " must be a single character.

let s:INVALID_COL = -3339
let s:last_col = s:INVALID_COL

let s:automatic_component_completion_done_p = s:FALSE
  " Special characters to activate automatic component completion.
if !exists('g:ku_component_separators')
  let g:ku_component_separators = '/\:'
endif


" To take action on the appropriate item.
let s:last_completed_items = []

  " There are 2 versions for user input:
  "
  "   raw              Text which user inserts at the ku window.
  "   prefix-expanded  User input, its prefix is expanded.
  "                    (see ku#custom_prefix())
  "
  " Variables which hold user input are named with the following suffixes:
  " "_raw" if variables hold raw version,
  " "_ped" if variables hold prefix-expanded version.
  "
  " Note that user input in the ku window is always raw version.  User will
  " never see prefix-expanded version of user input in the ku window.  This
  " policy is to avoid recursive prefix expansion whenever user types in the
  " ku window.
let s:last_user_input_raw = ''


" Values to be restored after the ku window is closed.
let s:completeopt = ''
let s:curwinnr = 0
let s:ignorecase = ''
let s:winrestcmd = ''


" User defined action tables, key tables and prefix table for sources.
if !exists('s:custom_action_tables')
  let s:custom_action_tables = {}  " source -> action-table
endif
if !exists('s:custom_key_tables')
  let s:custom_key_tables = {}  " source -> key-table
endif
if !exists('s:custom_prefix_tables')
  let s:custom_prefix_tables = {}  " source -> prefix-table
endif


" Junk patterns.
if !exists('g:ku_common_junk_pattern')
  let g:ku_common_junk_pattern = ''
endif

" There may be g:ku_{source}_junk_pattern.


" Priorities table: source -> priority
if !exists('s:priority_table')
  let s:priority_table = {}
endif
let s:DEFAULT_PRIORITY = 500
let s:MIN_PRIORITY = 100
let s:MAX_PRIORITY = 999


" Session ID.  A session is a period of time during the ku window is opened.
let s:session_id = 0


" For s:recall_input_history()
let s:current_hisotry_index = -1


" For ku#restart()
let s:last_used_source = s:INVALID_SOURCE
let s:last_used_input_pattern = ''


if !exists('g:ku_history_added_p')
  let g:ku_history_added_p = 'ku#_history_added_p'
endif








" Interface  "{{{1
function! ku#available_sources()  "{{{2
  " Assumes that s:available_sources will be never changed during a session.
  if s:ku_active_p() && s:session_id == s:_session_id_source_cache
    return s:available_sources
  endif

  let _ = s:FALSE

  if s:normal_source_cache_expired_p()
    call s:update_normal_source_cache()
    let _ = s:TRUE
  endif

  if s:special_source_cache_expired_p()
    call s:update_special_source_cache()
    let _ = s:TRUE
  endif

  if s:source_priorities_changed_p
    let s:source_priorities_changed_p = s:FALSE
    let _ = s:TRUE
  endif

  if _
    let s:available_sources = s:sort_sources(s:available_normal_sources
    \                                        + s:available_special_sources)
  endif

  let s:_session_id_source_cache = s:session_id
  return s:available_sources
endfunction

if !exists('s:available_sources')
  let s:available_sources = []  " [source-name, ...]
endif
let s:_session_id_source_cache = 0
let s:source_priorities_changed_p = s:TRUE


" cache for normal sources  "{{{3
let s:available_normal_sources = []  " [source-name, ...]
let s:last_normal_source_directory_timestamps = []  " [timestamp, ...]
let s:current_normal_source_directory_timestamps = []  " [timestamp, ...]

function! s:normal_source_cache_expired_p()
  let s:current_normal_source_directory_timestamps
  \   = map(s:runtime_files('autoload/ku/'), 'getftime(v:val)')

  return s:current_normal_source_directory_timestamps
  \      != s:last_normal_source_directory_timestamps
endfunction

function! s:update_normal_source_cache()
  let s:available_normal_sources = map(s:runtime_files('autoload/ku/*.vim'),
  \                                    'fnamemodify(v:val, ":t:r")')

  let s:last_normal_source_directory_timestamps
  \   = s:current_normal_source_directory_timestamps
endfunction


" cache for special sources  "{{{3
" FIXME: Implement proper caching.  The following interface is just to hide
"        the detail of caching.
let s:available_special_sources = []  " [source-name, ...]

function! s:special_source_cache_expired_p()
  return s:TRUE
endfunction

function! s:update_special_source_cache()
  let s:available_special_sources = []
  for f in s:runtime_files('autoload/ku/special/*_.vim')
    let s:available_special_sources
    \   += ku#special#{fnamemodify(f, ':t:r')}#sources()
  endfor
endfunction




function! ku#command_complete(arglead, cmdline, cursorpos)  "{{{2
  return join(ku#available_sources(), "\n")
endfunction




function! ku#custom_action(source, action, ...)  "{{{2
  if !has_key(s:custom_action_tables, a:source)
    let s:custom_action_tables[a:source] = {}
  endif

  if a:0 == 1
    call call('s:ku_custom_action_3', [a:source, a:action] + a:000)
  elseif a:0 == 2
    call call('s:ku_custom_action_4', [a:source, a:action] + a:000)
  else
    echoerr printf('Invalid arguments: %s', string([a:source,a:action]+a:000))
  endif
endfunction


function! s:ku_custom_action_3(source, action, function)  "{{{3
  let s:custom_action_tables[a:source][a:action] = a:function
endfunction


function! s:ku_custom_action_4(source, action, source2, action2)  "{{{3
  let action_table = s:api(a:source2, 'action_table')
  let function2 = get(action_table, a:action2, 0)
  if function2 is 0
    echoerr printf('No such action for %s/%s: %s',
    \              a:type, a:source2, string(a:action2))
    return
  endif

  let s:custom_action_tables[a:source][a:action] = function2
endfunction




function! ku#custom_key(source, key, action)  "{{{2
  if !has_key(s:custom_key_tables, a:source)
    let s:custom_key_tables[a:source] = {}
  endif

  let s:custom_key_tables[a:source][a:key] = a:action
endfunction




function! ku#custom_prefix(source, prefix, text)  "{{{2
  if !has_key(s:custom_prefix_tables, a:source)
    let s:custom_prefix_tables[a:source] = {}
  endif
  let _ = s:custom_prefix_tables[a:source]

  if a:text != ''
    let _[a:prefix] = a:text
  else
    if has_key(_, a:prefix)
      call remove(_, a:prefix)
    endif
  endif
endfunction




function! ku#custom_priority(source, priority)  "{{{2
  if type(a:priority) != type(0)
    echoerr 'priority must be integer, but got:' string(a:priority)
    return
  endif
  if a:priority < s:MIN_PRIORITY || s:MAX_PRIORITY < a:priority
    echoerr 'priority is out of the range:' string(a:priority)
    return
  endif

  let s:priority_table[a:source] = a:priority

  let s:source_priorities_changed_p = s:TRUE
endfunction




function! ku#default_event_handler(event, ...)  "{{{2
  if a:event ==# 'BeforeAction'
    return a:1
  else
    " a:event ==# 'SourceEnter'
    " a:event ==# 'SourceLeave'
    "   Nothing to do.
    return
  endif
endfunction




function! ku#default_key_mappings(override_p)  "{{{2
  let _ = a:override_p ? '' : '<unique>'
  call s:ni_map(_, '<buffer> <C-c>', '<Plug>(ku-cancel)')
  call s:ni_map(_, '<buffer> <Return>', '<Plug>(ku-do-the-default-action)')
  call s:ni_map(_, '<buffer> <C-m>', '<Plug>(ku-do-the-default-action)')
  call s:ni_map(_, '<buffer> <Tab>', '<Plug>(ku-choose-an-action)')
  call s:ni_map(_, '<buffer> <C-i>', '<Plug>(ku-choose-an-action)')
  call s:ni_map(_, '<buffer> <C-j>', '<Plug>(ku-next-source)')
  call s:ni_map(_, '<buffer> <C-k>', '<Plug>(ku-previous-source)')
  call s:ni_map(_, '<buffer> <Esc>j', '<Plug>(ku-newer-history)')
  call s:ni_map(_, '<buffer> <Esc>k', '<Plug>(ku-older-history)')
  return
endfunction




function! ku#do_action(name)  "{{{2
  if !s:ku_active_p()
    echoerr 'ku is not active'
    return s:FALSE
  endif

  return s:do(a:name)
endfunction




function! ku#input_history()  "{{{2
  return s:history_list()
endfunction




function! ku#restart()  "{{{2
  return ku#start(s:last_used_source, s:last_used_input_pattern)
endfunction




function! ku#start(source, ...)  "{{{2
  if !s:available_source_p(a:source)
    echoerr 'ku: Not a valid source name:' string(a:source)
    return s:FALSE
  endif

  if s:ku_active_p()
    " ":Ku {source}" change the current source as a:source if ku is already
    " active.
    call s:switch_current_source(a:source)
    return s:TRUE
  endif

  let s:current_source = a:source
  let s:session_id = localtime()
  let s:current_hisotry_index = -1

  " Save some values to restore the original state.
  let s:completeopt = &completeopt
  let s:ignorecase = &ignorecase
  let s:curwinnr = winnr()
  let s:winrestcmd = winrestcmd()

  " Open or create the ku buffer.
  let v:errmsg = ''
  if bufexists(s:bufnr)
    topleft split
    if v:errmsg != ''
      return s:FALSE
    endif
    silent execute s:bufnr 'buffer'
  else
    topleft new
    if v:errmsg != ''
      return s:FALSE
    endif
    let s:bufnr = bufnr('')
    call s:initialize_ku_buffer()
  endif
  2 wincmd _

  " Set some options
  set completeopt=menu,menuone
  set ignorecase

  " Reset the content of the ku buffer
  silent % delete _
  call append(1, (a:0 == 0 ? '' : a:1))
  normal! 2G

  " Start Insert mode.
  call feedkeys('A', 'n')

  call s:api(s:current_source, 'event_handler', 'SourceEnter')
  return s:TRUE
endfunction








" Core  "{{{1
function! ku#_omnifunc(findstart, base)  "{{{2
  " FIXME: caching
  " items = a list of items
  " item = a dictionary as described in :help complete-items.
  "        '^_ku_.*$' - additional keys used by ku.
  "        '^_{source}_.*$' - additional keys used by {source}.
  if a:findstart
    let s:last_completed_items = []
    return 0
  else
    let pattern = s:expand_prefix(s:remove_prompt(a:base))

    let asis_regexp = s:make_asis_regexp(pattern)
    let word_regexp = s:make_word_regexp(pattern)
    let skip_regexp = s:make_skip_regexp(pattern)

    let s:last_completed_items
    \   = copy(s:api(s:current_source, 'gather_items', pattern))
    for _ in s:last_completed_items
      let _['_ku_completed_p'] = s:TRUE
      let _['_ku_source'] = s:current_source
      let _['_ku_sort_priorities'] = [
      \     has_key(_, '_ku_sort_priority') ? _['_ku_sort_priority'] : 0,
      \     _.word =~# g:ku_common_junk_pattern,
      \     (exists('g:ku_{s:current_source}_junk_pattern')
      \      && _.word =~# g:ku_{s:current_source}_junk_pattern),
      \     s:match(_.word, '\C' . asis_regexp),
      \     s:matchend(_.word, '\C' . asis_regexp),
      \     s:match(_.word, '\c' . asis_regexp),
      \     s:matchend(_.word, '\c' . asis_regexp),
      \     s:match(_.word, '\C' . word_regexp),
      \     s:matchend(_.word, '\C' . word_regexp),
      \     s:match(_.word, '\c' . word_regexp),
      \     s:matchend(_.word, '\c' . word_regexp),
      \     match(_.word, '\C' . skip_regexp),
      \     matchend(_.word, '\C' . skip_regexp),
      \     match(_.word, '\c' . skip_regexp),
      \     matchend(_.word, '\c' . skip_regexp),
      \     _.word,
      \   ]
    endfor

      " Remove items not matched to case-insensitive skip_regexp, because user
      " doesn't want such items to be completed.
      " BUGS: Don't forget to update the index for the matched position of
      "       case-insensitive skip_regexp.
    call filter(s:last_completed_items, '0 <= v:val._ku_sort_priorities[-3]')
    call sort(s:last_completed_items, function('s:_compare_items'))
    if exists('g:ku_debug_p') && g:ku_debug_p
      echomsg 'base' string(a:base)
      echomsg 'asis' string(asis_regexp)
      echomsg 'word' string(word_regexp)
      echomsg 'skip' string(skip_regexp)
      for _ in s:last_completed_items
        echomsg string(_._ku_sort_priorities)
      endfor
    endif
    return s:last_completed_items
  endif
endfunction


function! s:_compare_items(a, b)
  return s:_compare_lists(a:a._ku_sort_priorities, a:b._ku_sort_priorities)
endfunction

function! s:_compare_lists(a, b)
  " Assumption: len(a:a) == len(a:b)
  for i in range(len(a:a))
    if a:a[i] < a:b[i]
      return -1
    elseif a:a[i] > a:b[i]
      return 1
    endif
  endfor
  return 0
endfunction




function! s:do(action_name)  "{{{2
  let current_user_input_raw = getline(2)
  if current_user_input_raw !=# s:last_user_input_raw
    " current_user_input_raw seems to be inserted by completion.
    for _ in s:last_completed_items
      if current_user_input_raw ==# _.word
        let item = _
        break
      endif
    endfor
    if !exists('item')
      echoerr 'Internal error: No match found in s:last_completed_items'
      echoerr 'current_user_input_raw' string(current_user_input_raw)
      echoerr 's:last_user_input_raw' string(s:last_user_input_raw)
      throw 'ku:e1'
    endif
  else
    " current_user_input_raw seems NOT to be inserted by completion, but ...
    if 0 < len(s:last_completed_items)
      " there are 1 or more items -- user seems to take action on the 1st one.
      let item = s:last_completed_items[0]
    else
      " there's no item -- user seems to take action on current_user_input_raw.
      let item = {'word':
      \             s:expand_prefix(s:remove_prompt(current_user_input_raw)),
      \           '_ku_completed_p': s:FALSE}
    endif
  endif

  call s:history_add(s:remove_prompt(s:last_user_input_raw))
  let s:last_used_source = s:current_source
  let s:last_used_input_pattern = s:last_user_input_raw

  if a:action_name == ''
    let action = s:choose_action(item)
  else
    let action = a:action_name
  endif

  " To avoid doing some actions on this buffer and/or this window, close the
  " ku window.
  call s:end()

  let item = s:api(s:current_source, 'event_handler', 'BeforeAction', item)
  call s:do_action(action, item)
  return
endfunction




function! s:end()  "{{{2
  if s:_end_locked_p
    return s:FALSE
  endif
  let s:_end_locked_p = s:TRUE

  call s:api(s:current_source, 'event_handler', 'SourceLeave')
  close

  let &completeopt = s:completeopt
  let &ignorecase = s:ignorecase
  execute s:curwinnr 'wincmd w'
  execute s:winrestcmd

  let s:_end_locked_p = s:FALSE
  return s:TRUE
endfunction
let s:_end_locked_p = s:FALSE




function! s:initialize_ku_buffer()  "{{{2
  " Basic settings.
  setlocal bufhidden=hide
  setlocal buftype=nofile
  setlocal nobuflisted
  setlocal noswapfile
  setlocal omnifunc=ku#_omnifunc
  silent file `=g:ku_buffer_name`

  " Autocommands.
  autocmd InsertEnter <buffer>  call feedkeys(s:on_InsertEnter(), 'n')
  autocmd CursorMovedI <buffer>  call feedkeys(s:on_CursorMovedI(), 'n')
  autocmd BufLeave <buffer>  call s:end()
  autocmd WinLeave <buffer>  call s:end()
  " autocmd TabLeave <buffer>  call s:end()  " not necessary

  " Key mappings.
  nnoremap <buffer> <silent> <Plug>(ku-cancel)
  \        :<C-u>call <SID>end()<Return>
  nnoremap <buffer> <silent> <Plug>(ku-do-the-default-action)
  \        :<C-u>call <SID>do('default')<Return>
  nnoremap <buffer> <silent> <Plug>(ku-choose-an-action)
  \        :<C-u>call <SID>do('')<Return>
  nnoremap <buffer> <silent> <Plug>(ku-next-source)
  \        :<C-u>call <SID>switch_current_source(1)<Return>
  nnoremap <buffer> <silent> <Plug>(ku-previous-source)
  \        :<C-u>call <SID>switch_current_source(-1)<Return>
  nnoremap <buffer> <silent> <Plug>(ku-newer-history)
  \        :<C-u>call <SID>recall_input_history(-1)<Return>
  nnoremap <buffer> <silent> <Plug>(ku-older-history)
  \        :<C-u>call <SID>recall_input_history(1)<Return>

  nnoremap <buffer> <Plug>(ku-%-enter-insert-mode)  a
  inoremap <buffer> <Plug>(ku-%-leave-insert-mode)  <Esc>
  inoremap <buffer> <expr> <Plug>(ku-%-accept-completion)
  \        pumvisible() ? '<C-y>' : ''
  inoremap <buffer> <expr> <Plug>(ku-%-cancel-completion)
  \        pumvisible() ? '<C-e>' : ''

  imap <buffer> <silent> <Plug>(ku-cancel)
  \    <Plug>(ku-%-leave-insert-mode)
  \<Plug>(ku-cancel)
  imap <buffer> <silent> <Plug>(ku-do-the-default-action)
  \    <Plug>(ku-%-accept-completion)
  \<Plug>(ku-%-leave-insert-mode)
  \<Plug>(ku-do-the-default-action)
  imap <buffer> <silent> <Plug>(ku-choose-an-action)
  \    <Plug>(ku-%-accept-completion)
  \<Plug>(ku-%-leave-insert-mode)
  \<Plug>(ku-choose-an-action)
  imap <buffer> <silent> <Plug>(ku-next-source)
  \    <Plug>(ku-%-cancel-completion)
  \<Plug>(ku-%-leave-insert-mode)
  \<Plug>(ku-next-source)
  \<Plug>(ku-%-enter-insert-mode)
  imap <buffer> <silent> <Plug>(ku-previous-source)
  \    <Plug>(ku-%-cancel-completion)
  \<Plug>(ku-%-leave-insert-mode)
  \<Plug>(ku-previous-source)
  \<Plug>(ku-%-enter-insert-mode)
  imap <buffer> <silent> <Plug>(ku-newer-history)
  \    <Plug>(ku-%-cancel-completion)
  \<Plug>(ku-%-leave-insert-mode)
  \<Plug>(ku-newer-history)
  \<Plug>(ku-%-enter-insert-mode)
  imap <buffer> <silent> <Plug>(ku-older-history)
  \    <Plug>(ku-%-cancel-completion)
  \<Plug>(ku-%-leave-insert-mode)
  \<Plug>(ku-older-history)
  \<Plug>(ku-%-enter-insert-mode)

  inoremap <buffer> <expr> <BS>  pumvisible() ? '<C-e><BS>' : '<BS>'
  imap <buffer> <C-h>  <BS>
  " <C-n>/<C-p> ... Vim doesn't expand these keys in Insert mode completion.

  " User's initialization.
  setfiletype ku
  if !(exists('#FileType#ku') || exists('b:did_ftplugin'))
    call ku#default_key_mappings(s:FALSE)
  endif

  return
endfunction




function! s:on_CursorMovedI()  "{{{2
  " Calling setline() has a side effect to the cursor.  If the cursor beyond
  " the end of line (i.e. getline('.') < col('.')), the cursor will be move at
  " the last character of the current line after calling setline().
  let c0 = col('.')
  call setline(1, '')
  let c1 = col('.')
  call setline(1, 'Source: ' . s:current_source)

  " The order of these conditions are important.
  let line = getline('.')
  if !s:contains_the_prompt_p(line)
    " Complete the prompt if it doesn't exist for some reasons.
    let keys = repeat("\<Right>", len(s:PROMPT))
    call s:complete_the_prompt()
  elseif col('.') <= len(s:PROMPT)
    " Move the cursor out of the prompt if it is in the prompt.
    let keys = repeat("\<Right>", len(s:PROMPT) - col('.') + 1)
  elseif len(line) < col('.') && col('.') != s:last_col
    " New character is inserted.  Let's complete automatically.
    if (!s:automatic_component_completion_done_p)
    \  && 0 <= stridx(g:ku_component_separators, line[-1:])
    \  && len(s:PROMPT) + 2 <= len(line)
      " (1) The last inserted character is not inserted by automatic component
      "     completion.
      " (2) It is a special character which is one of
      "     g:ku_component_separators.
      " (3) It seems not to be the 1st one in line.
      "
      " The (3) is necessary to input a special character as the 1st character
      " in line.  For example, without this condition, user cannot input the
      " 1st '/' of an absolute path like '/usr/local/bin' if '/' is a special
      " character.
      let text = s:text_by_automatic_component_completion(line)
      if text != ''
        call setline('.', text)
          " The last special character must be inserted in this way to
          " forcedly show the completion menu.
        let keys = "\<End>" . line[-1:]
        let s:automatic_component_completion_done_p = s:TRUE
      else
        let keys = s:KEYS_TO_START_COMPLETION
        let s:automatic_component_completion_done_p = s:FALSE
      endif
    else
      let keys = s:KEYS_TO_START_COMPLETION
      let s:automatic_component_completion_done_p = s:FALSE
    endif
  else
    let keys = ''
  endif

  let s:last_col = col('.')
  let s:last_user_input_raw = line
  return (c0 != c1 ? "\<Right>" : '') . keys
endfunction




function! s:on_InsertEnter()  "{{{2
  let s:last_col = s:INVALID_COL
  let s:last_user_input_raw = ''
  let s:automatic_component_completion_done_p = s:FALSE
  return s:on_CursorMovedI()
endfunction




function! s:recall_input_history(delta)  "{{{2
  let o = s:current_hisotry_index
  let n = o + a:delta
  if n < -1
    let n = -1
  endif
  if len(ku#input_history()) <= n
    let n = len(ku#input_history()) - 1
  endif

  if o == -1
    let s:unsaved_input_pattern = getline('.')
  endif
  if n == -1
    let _ = s:unsaved_input_pattern
  else
    let _ = ku#input_history()[n]
  endif

  let s:current_hisotry_index = n
  call setline('.', _)
  call feedkeys("\<End>", 'n')
  return
endfunction

" s:unsaved_input_pattern = ''




function! s:switch_current_source(_)  "{{{2
  " FIXME: Update the line to indicate the current source even if this
  "        function is called in any mode other than Insert mode.
  let _ = ku#available_sources()
  let o = index(_, s:current_source)
  if type(a:_) == type(0)
    let n = (o + a:_) % len(_)
    if n < 0
      let n += len(_)
    endif
  else  " type(a:_) == type('')
    let n = index(_, a:_)
  endif

  if o == n
    return s:FALSE
  endif

  call s:api(_[o], 'event_handler', 'SourceLeave')
  call s:api(_[n], 'event_handler', 'SourceEnter')

  let s:current_source = _[n]
  return s:TRUE
endfunction








" Misc.  "{{{1
" Autocommands  "{{{2

augroup plugin-ku
  autocmd!
  autocmd VimLeave *  call s:history_save()
augroup END



" Automatic completion  "{{{2
function! s:complete_the_prompt()  "{{{3
  call setline('.', s:PROMPT . getline('.'))
  return
endfunction


function! s:contains_the_prompt_p(s)  "{{{3
  return len(s:PROMPT) <= len(a:s) && a:s[:len(s:PROMPT) - 1] ==# s:PROMPT
endfunction


function! s:remove_prompt(s)  "{{{3
  return s:contains_the_prompt_p(a:s) ? a:s[len(s:PROMPT):] : a:s
endfunction


function! s:text_by_automatic_component_completion(line)  "{{{3
  " Note that a:line always ends with a special character which is one of
  " g:ku_component_separators,  because this function is always called by
  " typing a special character.  So there are at least 2 components in a:line.
  let SEP = a:line[-1:]  " string[-1] is always empty - see :help expr-[]

  let user_input_raw = s:remove_prompt(a:line)
  let [user_input_ped, prefix, text] = s:expand_prefix3(user_input_raw)
  let prefix_expanded_p = user_input_raw !=# user_input_ped
  let line_components = split(user_input_ped, SEP, s:TRUE)

  " Find an item which has the same components but the last 2 ones of
  " line_components.  Because line_components[-1] is always empty and
  " line_components[-2] is almost imperfect name of a component.
  "
  " Note that line_components[-2] is already used to filter the completed
  " items and it is used to select what components should be completed.
  "
  " Example:
  "
  " (a) a:line ==# 'usr/share/m/',
  "     line_components == ['usr', 'share', 'm', '']
  "
  "     The 1st item which is prefixed with 'usr/share/' is selected and it is
  "     used for this automatic component completion.  If
  "     'usr/share/man/man1/' is found in this way, the completed text will be
  "     'usr/share/man'.
  "
  " (b) a:line ==# 'u/'
  "     line_components == ['u', '']
  "
  "     The 1st item is alaways selected for this automatic component
  "     completion.  If 'usr/share/man/man1/' is found in this way, the
  "     completion text will be 'usr'.
  "
  " (c) a:line ==# 'm/'
  "     line_components == ['m', '']
  "
  "     The 1st item is alaways selected for this automatic component
  "     completion.  If 'usr/share/man/man1/' is found in this way, the
  "     completion text will be 'usr/share/man', because user seems to want to
  "     complete till the component which matches to 'm'.
  let items = copy(ku#_omnifunc(s:FALSE, a:line[:-2]))  " without the last SEP
  for item in filter(items, 's:api(s:current_source,"acc_valid_p",v:val,SEP)')
    let item_components = split(item.word, SEP, s:TRUE)

    if len(line_components) < 2
      echoerr 'Assumption is failed in auto component completion'
      throw 'ku:e2'
    elseif len(line_components) == 2
      " OK - the case (b)
    elseif len(line_components) - 2 <= len(item_components)
      for i in range(len(line_components) - 2)
        if line_components[i] != item_components[i]
          break
        endif
      endfor
      if line_components[i] != item_components[i]
        continue
      endif
      " OK - the case (a)
    else
      continue
    endif

      " for the case (c), find the index of a component to be completed.
    let _ = len(line_components) - 2
    for i in range(len(line_components) - 2, len(item_components) - 1)
      if item_components[i] =~? s:make_skip_regexp(line_components[-2])
        let _ = i
        break
      endif
    endfor

    let result = join(item_components[:_], SEP)
    if prefix_expanded_p && stridx(result, text) == 0
      let result = prefix . result[len(text):]
    endif
    return result
  endfor
  return ''
endfunction




" Action-related stuffs  "{{{2
function! s:choose_action(item)  "{{{3
  " Prompt  Item     Source
  "    |     |         |
  "   _^__  _^______  _^__
  "   Item: Makefile (file)
  "   ^C cancel      ^O open        ...
  "   What action?   ~~ ~~~~
  "   ~~~~~~~~~~~~    |   |
  "         |         |   |
  "      Message     Key  Action
  "
  " Here "Prompt" is highlighted with kuChoosePrompt,
  " "Item" is highlighted with kuChooseItem, and so forth.
  let KEY_TABLE = s:composite_key_table(s:current_source)
  call filter(KEY_TABLE, 'v:val !=# "nop"')
  let ACTION_TABLE = s:composite_action_table(s:current_source)
  call filter(KEY_TABLE, 'get(ACTION_TABLE, v:val, "") !=# "nop"')

  " "Item: {item} ({source})"
  echohl NONE
  echo ''
  echohl kuChoosePrompt
  echon 'Item'
  echohl NONE
  echon ': '
  echohl kuChooseItem
  echon a:item.word
  echohl NONE
  echon ' ('
  echohl kuChooseSource
  echon s:current_source
  echohl NONE
  echon ')'

  " List keys and their actions.
  " FIXME: listing like ls - the width of each column is varied.
  let KEYS = map(sort(keys(KEY_TABLE)), 'v:val')
  let KEY_NAMES = map(copy(KEYS), 'strtrans(v:val)')
  let MAX_KEY_WIDTH = max(map(copy(KEY_NAMES), 'len(v:val)'))
  let ACTION_NAMES = map(copy(KEYS), 'KEY_TABLE[v:val]')
  let MAX_ACTION_WIDTH = max(map(copy(ACTION_NAMES), 'len(v:val)'))
  let MAX_LABEL_WIDTH = MAX_KEY_WIDTH + 1 + MAX_ACTION_WIDTH
  let SPACER = '   '
  let C = (&columns + len(SPACER) - 1) / (MAX_LABEL_WIDTH + len(SPACER))
  let C = max([C, 1])
  " let C = min([8, C])  " experimental
  let N = len(KEY_TABLE)
  let R = N / C + (N % C != 0)
  for row in range(R)
    for col in range(C)
      let i = col * R + row
      if !(i < N)
        continue
      endif

      " "{key} {action}"
      echon col == 0 ? "\n" : SPACER
      echohl kuChooseKey
      echon KEY_NAMES[i]
      echohl NONE
      echon repeat(' ', MAX_KEY_WIDTH - len(KEY_NAMES[i]))
      echon ' '
      echohl kuChooseAction
      echon ACTION_NAMES[i]
      echohl NONE
      echon repeat(' ', MAX_ACTION_WIDTH - len(ACTION_NAMES[i]))
    endfor
  endfor

  echohl kuChooseMessage
  echo 'What action?'
  echohl NONE

  " Take user input.
  let k = s:getkey()
  redraw  " clear the menu message lines to avoid hit-enter prompt.

  " Return the action bound to the key k.
  if has_key(KEY_TABLE, k)
    return KEY_TABLE[k]
  else
    " FIXME: loop to rechoose?
    echo 'The key' string(k) 'is not associated with any action'
    \    '-- nothing happened.'
    return 'nop'
  endif
endfunction


function! s:do_action(action, item)  "{{{3
  " Assumption: BeforeAction is already applied for a:item.
  call function(s:get_action_function(a:action))(a:item)
  return s:TRUE
endfunction


function! s:get_action_function(action)  "{{{3
  let ACTION_TABLE = s:composite_action_table(s:current_source)
  if has_key(ACTION_TABLE, a:action)  " exists action?
    if ACTION_TABLE[a:action] !=# 'nop'  " enabled action?
      return ACTION_TABLE[a:action]
    else
      break
    endif
  endif

    " To avoid echoing the location of error,
    " use :echohl ErrorMsg instead of :echoerr.
  echohl ErrorMsg
  echo printf('No such action for source %s: %s',
  \           string(s:current_source),
  \           string(a:action))
  echohl NONE
  return 's:_default_action_nop'
endfunction




" Default actions  "{{{2
" "default" variants with :split "{{{3
function! s:with_split(direction_modifier, item)
  let v:errmsg = ''
  execute a:direction_modifier 'split'
  if v:errmsg == ''
    call s:do_action('default', a:item)
  endif
  return
endfunction

function! s:_default_action_Bottom(item)
  return s:with_split('botright', a:item)
endfunction
function! s:_default_action_Left(item)
  return s:with_split('vertical topleft', a:item)
endfunction
function! s:_default_action_Right(item)
  return s:with_split('vertical botright', a:item)
endfunction
function! s:_default_action_Top(item)
  return s:with_split('topleft', a:item)
endfunction
function! s:_default_action_above(item)
  return s:with_split('aboveleft', a:item)
endfunction
function! s:_default_action_below(item)
  return s:with_split('belowright', a:item)
endfunction
function! s:_default_action_left(item)
  return s:with_split('vertical leftabove', a:item)
endfunction
function! s:_default_action_right(item)
  return s:with_split('vertical rightbelow', a:item)
endfunction
function! s:_default_action_tab_Left(item)
  return s:with_split('0 tab', a:item)
endfunction
function! s:_default_action_tab_Right(item)
  return s:with_split(tabpagenr('$') . ' tab', a:item)
endfunction
function! s:_default_action_tab_left(item)
  return s:with_split((tabpagenr() - 1) . ' tab', a:item)
endfunction
function! s:_default_action_tab_right(item)
  return s:with_split('tab', a:item)
endfunction


function! s:_default_action_cd(item)  "{{{3
  cd `=fnamemodify(a:item.word, ':p:h')`
  return
endfunction


function! s:_default_action_ex(item)  "{{{3
  " Support to execute an Ex command on a:item.word (as path).
  call feedkeys(printf(": %s\<C-b>", fnameescape(a:item.word)), 'n')
  return
endfunction


function! s:_default_action_lcd(item)  "{{{3
  lcd `=fnamemodify(a:item.word, ':p:h')`
  return
endfunction


function! s:_default_action_nop(item)  "{{{3
  " NOP
  return
endfunction




" Action table  "{{{2
function! s:composite_action_table(source)  "{{{3
  let action_table = {}
  for _ in [s:default_action_table(),
  \         s:custom_action_table('common'),
  \         s:api(a:source, 'action_table'),
  \         s:custom_action_table(a:source)]
    call extend(action_table, _)
  endfor
  return action_table
endfunction


function! s:custom_action_table(source)  "{{{3
  return get(s:custom_action_tables, a:source, {})
endfunction


function! s:default_action_table()  "{{{3
  return {
  \   'Bottom': 's:_default_action_Bottom',
  \   'Left': 's:_default_action_Left',
  \   'Right': 's:_default_action_Right',
  \   'Top': 's:_default_action_Top',
  \   'above': 's:_default_action_above',
  \   'below': 's:_default_action_below',
  \   'cancel': 's:_default_action_nop',
  \   'cd': 's:_default_action_cd',
  \   'ex': 's:_default_action_ex',
  \   'lcd': 's:_default_action_lcd',
  \   'left': 's:_default_action_left',
  \   'nop': 's:_default_action_nop',
  \   'right': 's:_default_action_right',
  \   'tab-Left': 's:_default_action_tab_Left',
  \   'tab-Right': 's:_default_action_tab_Right',
  \   'tab-left': 's:_default_action_tab_left',
  \   'tab-right': 's:_default_action_tab_right',
  \ }
endfunction




" Key table  "{{{2
function! s:composite_key_table(source)  "{{{3
  let key_table = {}
  for _ in [s:default_key_table(),
  \         s:custom_key_table('common'),
  \         s:api(a:source, 'key_table'),
  \         s:custom_key_table(a:source)]
    call extend(key_table, _)
  endfor
  return key_table
endfunction


function! s:custom_key_table(source)  "{{{3
  return get(s:custom_key_tables, a:source, {})
endfunction


function! s:default_key_table()  "{{{3
  return {
  \   "\<C-c>": 'cancel',
  \   "\<C-h>": 'left',
  \   "\<C-j>": 'below',
  \   "\<C-k>": 'above',
  \   "\<C-l>": 'right',
  \   "\<C-t>": 'tab-Right',
  \   "\<Esc>": 'cancel',
  \   "\<Return>": 'default',
  \   '/': 'cd',
  \   ':': 'ex',
  \   ';': 'ex',
  \   '?': 'lcd',
  \   'H': 'Left',
  \   'J': 'Bottom',
  \   'K': 'Top',
  \   'L': 'Right',
  \   'h': 'left',
  \   'j': 'below',
  \   'k': 'above',
  \   'l': 'right',
  \   't': 'tab-Right',
  \ }
endfunction




" Prefix table  "{{{2
function! s:prefix_table_for(source)  "{{{3
  let PREFIX_TABLE = {}
  for _ in [s:custom_prefix_table('common'),
  \         s:custom_prefix_table(a:source)]
    call extend(PREFIX_TABLE, _)
  endfor
  return PREFIX_TABLE
endfunction


function! s:custom_prefix_table(source)  "{{{3
  return get(s:custom_prefix_tables, a:source, {})
endfunction


function! s:expand_prefix(user_input_raw)  "{{{3
  return s:expand_prefix3(a:user_input_raw)[0]
endfunction


function! s:expand_prefix3(user_input_raw)  "{{{3
  if s:session_id != s:_session_id_expand_prefix3
  \  || s:current_source != s:_current_source_expand_prefix3
    let _ = s:prefix_table_for(s:current_source)
    let s:cached_prefix_items = map(reverse(sort(keys(_))), '[v:val,_[v:val]]')
  endif

  for [prefix, text] in s:cached_prefix_items
    if a:user_input_raw[:len(prefix) - 1] ==# prefix
      return [text . a:user_input_raw[len(prefix):], prefix, text]
    endif
  endfor

  return [a:user_input_raw, '', '']
endfunction

let s:cached_prefix_items = []
let s:_session_id_expand_prefix3 = 0
let s:_current_source_expand_prefix3 = s:INVALID_SOURCE




" History of inputted patterns  "{{{2
" Variables / Constants  "{{{3

" s:inputted_patterns = []  " the first item is the newest inputted pattern.
let s:HISTORY_SIZE = 100
let s:HISTORY_FILE = 'info/ku/history'


function! s:history_add(new_input_pattern)  "{{{3
  if !{g:ku_history_added_p}(a:new_input_pattern)
    return
  endif
  call insert(s:inputted_patterns, a:new_input_pattern, 0)

  if s:HISTORY_SIZE < len(s:inputted_patterns)
    unlet s:inputted_patterns[(s:HISTORY_SIZE):]
  endif
endfunction

function! ku#_history_added_p(new_input_pattern)
  return a:new_input_pattern !~ '^\s*$'
endfunction


function! s:history_file()  "{{{3
  " FIXME: path separator assumption
  return printf('%s/%s', split(&runtimepath, ',')[0], s:HISTORY_FILE)
endfunction


function! s:history_list()  "{{{3
  return s:inputted_patterns
endfunction


function! s:history_load()  "{{{3
  if filereadable(s:history_file())
    let s:inputted_patterns = readfile(s:history_file(), '', s:HISTORY_SIZE)
  else
    let s:inputted_patterns = []
  endif
endfunction

if !exists('s:inputted_patterns')
  call s:history_load()
endif


function! s:history_save()  "{{{3
  let file = s:history_file()
  let directory = fnamemodify(file, ':h')
  if !isdirectory(directory)
    call mkdir(directory, 'p')
  endif

  call writefile(s:history_list(), file)
endfunction




function! s:api(source_name, api_name, ...)  "{{{2
  let _ = matchstr(a:source_name, '^[a-z]\+\ze-')

  if _ == ''  " normal source
    let func = printf('ku#%s#%s', a:source_name, a:api_name)
    let args = a:000
  else  " special source
    let func = printf('ku#special#%s#%s', _, a:api_name)
    let args = [a:source_name] + a:000
  endif

  if a:api_name ==# 'acc_valid_p' && !exists('*' . func)
    return s:TRUE
  endif
  return call(func, args)
endfunction




function! s:available_source_p(source)  "{{{2
  return 0 <= index(ku#available_sources(), a:source)
endfunction




function! s:getkey()  "{{{2
  " Alternative getchar() to get a logical key such as <F1> and <M-{x}>.
  let k = ''

  let c = getchar()
  while s:TRUE
    let k .= type(c) == type(0) ? nr2char(c) : c
    let c = getchar(0)
    if c is 0
      break
    endif
  endwhile

  return k
endfunction




function! s:ku_active_p()  "{{{2
  return bufexists(s:bufnr) && bufwinnr(s:bufnr) != -1
endfunction




function! s:make_asis_regexp(s)  "{{{2
  return '\V' . escape(a:s, '\')
endfunction




function! s:make_skip_regexp(s)  "{{{2
  let _ = a:s
  let _ = substitute(_, '\s\+', '', 'g')
  let _ = escape(_, '\')
  let _ = substitute(_[:-2], '[^\\]\zs', '\\.\\{-}', 'g') . _[-1:]
  return '\V' . _
endfunction




function! s:make_word_regexp(s)  "{{{2
  " FIXME: path separator assumption
  let p_asis = s:make_asis_regexp(substitute(a:s, '/', ' / ', 'g'))
  return substitute(p_asis, '\s\+', '\\.\\{-}', 'g')
endfunction




function! s:match(s, pattern)  "{{{2
  " Like match(), but return a very big number (POINT_AT_INFINITY) to express
  " that a:s is not matched to a:pattern.  This returning value is very useful
  " to sort with matched positions.
  let POINT_AT_INFINITY = 2147483647  " FIXME: valid value.
  let i = match(a:s, a:pattern)
  return 0 <= i ? i : POINT_AT_INFINITY
endfunction




function! s:matchend(s, pattern)  "{{{2
  " Like s:match(), but the meaning of returning value is same as matchend().
  let POINT_AT_INFINITY = 2147483647  " FIXME: valid value.
  let i = matchend(a:s, a:pattern)
  return 0 <= i ? i : POINT_AT_INFINITY
endfunction




function! s:ni_map(...)  "{{{2
  for _ in ['n', 'i']
    silent! execute _.'map' join(a:000)
  endfor
  return
endfunction




function! s:runtime_files(glob_pattern)  "{{{2
  return split(globpath(&runtimepath, a:glob_pattern), '\n')
endfunction




function! s:sort_sources(_)  "{{{2
  let _ = a:_
  let _ = map(_, 'get(s:priority_table, v:val, s:DEFAULT_PRIORITY) . v:val')
  let _ = sort(_)
  let _ = map(_, 'v:val[3:]')  " Assumption: priority is 3-digit integer.
  return _
endfunction








" __END__  "{{{1
" vim: foldmethod=marker
