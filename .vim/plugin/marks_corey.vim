" Vim plugin for showing marks using number array.
" Maintainer: Hongli Gao <left.slipper at gmail dot com>
" Last Change: 2008 April 12
"
" USAGE:
" Copy this file to your vim's plugin folder.
" ####  You can set marks only less 100.  ####
"
" make a mark, or delete it: 
"                            ctrl + F2
"                            mm
" move to ahead mark:          
"                            shift + F2
"                            mv
" move to next mark:                           
"                            F2
"                            mb
" moving a mark:
"                            m.
"  (press m. to mark a mark, and move the cursor to new line, 
"   press the m. again, you can moving a mark.)
"
" delete all marks:
"                            F4
" If you want to save the marks to a file. Do it like below:
" Put the one line
" let g:Signs_file_path_corey='c:\\'
" into your gvimrc, change it to your path.
"
" :call Save_signs_to_file()   # Save marks.
" :call Load_signs_from_file() # Do this, after opening all your marked files
"
" copyright (c) 2008 Hongli Gao; 
" Distributed under the GNU General Public License.
" ---------------------------------------------------------------------

if !has("signs")
  echoerr "Sorry, your vim does not support signs!"
  finish
endif

if has("win32")
  let s:win32Flag = 1
else
  let s:win32Flag = 0
endif

"[ sign id, line number, file name]
let s:mylist = [["00","0","DO NOT CHANGE ANYTHING ABOUT THE FILE, THIS USE FOR VIM PLUGIN. BY HONGLI GAO @2008/03"]]
let s:myIndex = 1
let s:tmplist = ["00","0","corey"]
let s:deleteFlag = 0
let s:outputFileName = "DO_NOT_DELETE_IT"
let s:remarkItem = ["REMARK","SEARCH","FLAG"]

" ---------------------------------------------------------------------
" put on one sign
fun! Place_sign()

  if !exists("s:Cs_sign_number")
    let s:Cs_sign_number = 1
  endif

  if s:Cs_sign_number > 99
    echo "Sorry, you only can use these marks less 100!"
    return -1
  else
    let s:Cs_sign_number = (s:mylist[len(s:mylist) - 1][0] * 1) + 1
  endif

  let vLn = "".line(".")
  let vFileName = expand("%:p")

  let vFlagNum = (s:Cs_sign_number < 10 ? "0" . s:Cs_sign_number : s:Cs_sign_number)
  let newItem = [vFlagNum,vLn,vFileName]
  let vIndex = s:Check_list(newItem)

  if vIndex > -1
    call s:Remove_sign(vIndex)
  else
    silent! exe 'sign define CS' . vFlagNum . ' text='. vFlagNum .' texthl=ErrorMsg'
    silent! exe 'sign place ' . vFlagNum . ' line=' . vLn . ' name=CS'. vFlagNum . ' file=' . vFileName

    "let s:Cs_sign_number = s:Cs_sign_number + 1
    let s:mylist = s:mylist + [newItem]
    " record the last index.
    let s:myIndex = len(s:mylist) - 1
    let s:deleteFlag = 0
  endif
  "echo s:mylist
endfun

" ---------------------------------------------------------------------
" Remove all signs
fun! Remove_all_signs()

  silent! exe 'sign unplace *'
  if len(s:mylist) > 1
    let i = remove(s:mylist, 1, -1)
    let s:Cs_sign_number = 1
  endif
  "echo s:mylist
endfun

" ---------------------------------------------------------------------
" Goto prev sign:
fun! Goto_prev_sign()

  if len(s:mylist) > 1
    if s:deleteFlag == 0
      let s:myIndex = s:myIndex - 1
    endif
    let s:deleteFlag = 0

    if s:myIndex <= 0
      let s:myIndex = len(s:mylist) - 1
    endif
    call s:Sign_jump(s:mylist[s:myIndex])
  endif
endfun

" ---------------------------------------------------------------------
" Goto next sign:
fun! Goto_next_sign()

  let s:deleteFlag = 0
  if len(s:mylist) > 1
    let s:myIndex = s:myIndex + 1
    if ((s:myIndex >= len(s:mylist)) || (s:myIndex == 1))
      let s:myIndex = 1
    endif
    call s:Sign_jump(s:mylist[s:myIndex])
  endif
endfun
" ---------------------------------------------------------------------
" Save_signs_to_file
fun! Save_signs_to_file()

  call s:Get_signs_file_name()
  let tempList = []
  for item in s:mylist
    let tempList = tempList + [item[0] . "#" . item[1]. "#" . item[2]]
  endfor
  let writeFlag = writefile(tempList, s:outputFileName)

endfun
" ---------------------------------------------------------------------
" Load_signs_from_file
fun! Load_signs_from_file()

  call s:Get_signs_file_name()
  if filereadable(s:outputFileName)
    let tempList = [[]]
    let iflag = 0
    for line in readfile(s:outputFileName)
      let first = stridx(line, "#", 0)
      let second = stridx(line, "#", first + 1)
      if iflag != 0
        let tempList = tempList + [[strpart(line, 0, first), strpart(line, first + 1, second - first - 1), strpart(line, second + 1)]]
      else
        let tempList = [[strpart(line, 0, first), strpart(line, first + 1, second - first - 1), strpart(line, second + 1)]]
      endif
      let iflag = 1
    endfor
    let s:mylist = tempList
  endif

  call s:Flash_signs()

  "echo s:mylist
endfun

" ---------------------------------------------------------------------
fun! s:Get_signs_file_name()

  if exists("g:Signs_file_path_corey")
    let s:outputFileName = g:Signs_file_path_corey . "_DO_NOT_DELETE_IT"
  endif
endfun

" ---------------------------------------------------------------------
" Remove one sign
fun! s:Remove_sign(aIndex)

  if len(s:mylist) > 1
    silent! exe 'sign unplace ' .s:mylist[a:aIndex][0] . ' file=' . s:mylist[a:aIndex][2]

    " record the before item
    let s:tmplist = s:mylist[a:aIndex - 1]

    let i = remove(s:mylist, a:aIndex)

    " record the current index.
    let s:myIndex = s:Check_list(s:tmplist)
    let s:deleteFlag = 1
    "echo s:mylist
  endif
endfun

" ---------------------------------------------------------------------
fun! s:Flash_signs()

  silent! exe 'sign unplace *'
  if len(s:mylist) > 1
    for item in s:mylist
      silent! exe 'sign define CS' . item[0] . ' text='. item[0] .' texthl=ErrorMsg'
      silent! exe 'sign place ' . item[0] . ' line=' . item[1] . ' name=CS'. item[0] . ' file=' . item[2]
    endfor
  endif
  let s:Cs_sign_number = s:mylist[len(s:mylist) - 1][0] * 1 + 1
  "let s:myIndex = 1 ##you don't need reset the pointer
endfun

" ---------------------------------------------------------------------
" if line number and file name both same, return the aitem's index of s:mylist
" else return -1
" index 0 of s:mylist is the output message in the record file.
fun! s:Check_list(aItem)

  let vResult = -1
  let index = 0

  for item in s:mylist
    if ((s:Compare(item[1], a:aItem[1]) == 1) && (s:Compare(item[2],a:aItem[2]) == 1))
      return index
    endif
    let index = index + 1
  endfor

  return vResult
endfun

" ---------------------------------------------------------------------
" Move_sign
fun! Move_sign()

  let s:tempItem = ["","",""]
  let vRLn = "".line(".")
  let vRFileName = expand("%:p")

  let s:tempItem[1] = vRLn
  let s:tempItem[2] = vRFileName
  "echo s:tempItem
  let vRIndex = s:Check_list(s:tempItem)

  if (s:remarkItem[0] ==# "REMARK" )
    if vRIndex > 0
      silent! exe 'sign define CS' . s:mylist[vRIndex][0] . ' text='. s:mylist[vRIndex][0] .' texthl=Search'
      silent! exe 'sign place ' . s:mylist[vRIndex][0] . ' line=' . vRLn . ' name=CS'. s:mylist[vRIndex][0] . ' file=' . vRFileName
      let s:remarkItem = s:mylist[vRIndex]
      let s:myIndex = vRIndex
      "echo s:remarkItem
    endif
  else
    let pionter = s:Check_list(s:remarkItem)
    "echo vRIndex ."|" .pionter
    if ((vRIndex < 0) && (pionter > 0))
      silent! exe 'sign unplace ' .s:remarkItem[0] . ' file=' . s:remarkItem[2]
      "silent! exe 'sign undefine' .s:remarkItem[0]
      silent! exe 'sign define CS' . s:remarkItem[0] . ' text='. s:remarkItem[0] .' texthl=ErrorMsg'
      silent! exe 'sign place ' . s:remarkItem[0] . ' line=' . vRLn . ' name=CS' . s:remarkItem[0] . ' file=' . vRFileName
      let s:mylist[pionter][1] = vRLn
      let s:mylist[pionter][2] = vRFileName
      "echo s:mylist[pionter]
      let s:myIndex = pionter
      let s:remarkItem = ["REMARK","SEARCH","FLAG"]
    endif
  endif
endfun

" -*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*-*
" all of them used for the jump.
fun! s:Sign_jump(aSignItem)
  let bufferExits = s:GetTabpage(a:aSignItem)

  if bufferExits > 0
    silent! exe 'tabn ' . bufferExits
    silent! exe 'sign jump '. a:aSignItem[0] . ' file='. a:aSignItem[2]
  else
    call s:Open_file(a:aSignItem[2])
    silent! exe 'sign place ' . a:aSignItem[0] . ' line=' . a:aSignItem[1] . ' name=CS'. a:aSignItem[0] . ' file=' . a:aSignItem[2]
    silent! exe 'sign jump '. a:aSignItem[0] . ' file='. a:aSignItem[2]
  endif

endfun

" ---------------------------------------------------------------------
" GetTabpage
fun! s:GetTabpage(aSignItem)

  let bufname = expand("%:p")
  if s:Compare(bufname,a:aSignItem[2]) == 1
    return tabpagenr()
  endif

  let i = 0

  while i < tabpagenr('$')

    if i == 0
      silent! exe 'tabfirst'
    else
      silent! exe 'tabnext'
    endif
    let bufname = expand("%:p")

    if s:Compare(bufname,a:aSignItem[2]) == 1
      return i + 1
    endif

    let i = i + 1
  endwhile

  return -1
endfun
" ---------------------------------------------------------------------
" compare
fun! s:Compare(a1,a2)
  if s:win32Flag == 1
    if a:a1 ==? a:a2
      return 1
    endif
  else
    if a:a1 ==# a:a2
      return 1
    endif
  endif
  return 0
endfun

" ---------------------------------------------------------------------
" open file
fun! s:Open_file(aFileName)
  if filereadable(a:aFileName)
    "call s:Flash_signs()
    if tabpagenr('$') > 1
      silent! exe 'tabnew '. a:aFileName
      silent! exe 'tabn ' . tabpagenr('$')
    else
      silent! exe 'e '. a:aFileName
    endif
  endif
endfun
" ---------------------------------------------------------------------
" search file
" find the file, return the position; else return -1
fun! s:Seach_file(aFileName, aBufferList)

  let vResult = -1

  if len(a:aBufferList) > 1
    if s:win32Flag == 1
      for item in a:aBufferList
        " file name is ignoring case
        if (item[1] ==? a:aFileName)
          return item[0]
        endif
      endfor
    else
      for item in a:aBufferList
        " file name is matching case
        if (item[1] ==# a:aFileName)
          return item[0]
        endif
      endfor
    endif
  endif
  return vResult
endfun

" ---------------------------------------------------------------------
if !hasmapto('<Plug>Place_sign')
  map <unique> <c-F2> <Plug>Place_sign
  map <silent> <unique> mm <Plug>Place_sign
endif
nnoremap <silent> <script> <Plug>Place_sign :call Place_sign()<cr>

if !hasmapto('<Plug>Goto_next_sign') 
  map <unique> <F2> <Plug>Goto_next_sign
  map <silent> <unique> mb <Plug>Goto_next_sign
endif
nnoremap <silent> <script> <Plug>Goto_next_sign :call Goto_next_sign()<cr>

if !hasmapto('<Plug>Goto_prev_sign') 
  map <unique> <s-F2> <Plug>Goto_prev_sign
  map <silent> <unique> mv <Plug>Goto_prev_sign
endif
nnoremap <silent> <script> <Plug>Goto_prev_sign :call Goto_prev_sign()<cr>

if !hasmapto('<Plug>Remove_all_signs') 
  map <unique> <F4> <Plug>Remove_all_signs
endif
nnoremap <silent> <script> <Plug>Remove_all_signs :call Remove_all_signs()<cr>

if !hasmapto('<Plug>Move_sign') 
  map <silent> <unique> m. <Plug>Move_sign
endif
nnoremap <silent> <script> <Plug>Move_sign :call Move_sign()<cr>

" ---------------------------------------------------------------------

