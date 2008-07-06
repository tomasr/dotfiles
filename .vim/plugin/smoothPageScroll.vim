"------------------------------------------------------------------------------
" File: smoothPageScroll.vim
" vimscript #2183
" URL on VIM: http://www.vim.org/scripts/script.php?script_id=2183
"------------------------------------------------------------------------------
" Smooth Page Scroll
"
" Yet another smooth page scroll implementation.
" I found scrolling the number of winheight() is not always correct, because 
" the file could have wrapped lines. Let's say if your window height is 40,
" but you only see 35 actual lines because you have 5 wrapped lines. Then
" by scrolling the number of winheight(), 5 lines would be over-scrolled.
" This script won't skip the extra lines for having wrapped lines.
"
" This script also emualtes one of VIM's normal <PageDown> or <PageUp> 
" behaviors: which is to display first or last 2 lines from the previous screen
" after scrolling, unless it reaches first or last line, or the current window 
" is showing 3 lines or less. 
"
" See other implementation - vimscript #1601, :help scroll-smooth
"------------------------------------------------------------------------------
" Author: Hosup Chung <hosup.chung@gmail.com>
"
" Created:      2008 March 6
" Last Updated: 2008 March 6
"
" Version: 0.10
" 0.10: initial upload
" 0.11: add silent to exe command
"------------------------------------------------------------------------------
" Install:
" Copy this script in your plugin directory
"------------------------------------------------------------------------------
" Usage:
" 1) call them directly
" 	:call SmoothPageScrollDown() to scroll page down 
" 	:call SmoothPageScrollUp() to scroll page up
"
" 2) or remap <PageDown> and <PageUp>
" 	map <PageDown> :call SmoothPageScrollDown()<CR>
" 	map <PageUp>   :call SmoothPageScrollUp()<CR>
"
" Personally, I remapped <Space> and <S-Space> keys, since <Space> in non-insert 
" mode is not that useful (just move the cursor one position right). And many 
" programs such as web browsers or acrobat reader use space key to scroll page. 
" 	map <Space>   :call SmoothPageScrollDown()<CR>
" 	map <S-Space> :call SmoothPageScrollUp()<CR>
"
" But remapping <S-Space> may not work on certain console or platform. So you 
" might have to find another candidate, such as <M-Space>, <C-Space> or 
" something else.
"------------------------------------------------------------------------------

if exists("g:smooth_page_scroll")
	finish
endif

let g:smooth_page_scroll="0.10"

" save 'cpoptions'
if 1
	let s:save_cpo = &cpoptions
endif
set cpo&vim

let s:scrolldown = "\<C-E>"
let s:scrollup   = "\<C-Y>"

function! SmoothPageScrollDown()
	if line("$") > line("w0") 
		" newTopLine is the top row's line number of the window after scroll.
		
		if line("w$") == line("$")
			let newTopLine = line("$")
		elseif (line("w$") - line("w0")) < 3
			let newTopLine = line("w$")
		else
			let newTopLine = line("w$") - 1
		endif

		while newTopLine > line("w0")
			silent! exe "norm! " . s:scrolldown
			redraw
		endwhile

		" move the cursor to the proper line
		silent! exe "norm! H"
	endif
endfunction

" scrolling up is messy, because the current window doesn't necessarily show 
" how many lines we have to scroll up.
function! SmoothPageScrollUp()
	if line("w0") > 1
		" newLastLine is the last row's line number of the window after scroll.
		" but it's only a guesstimate value.
		if line("w0") == line("$") || (line("w$") - line("w0")) < 3
			let newLastLine = line("w0")
		else
			let newLastLine = line("w0") + 1
		endif

		while line("w0") > 1 && newLastLine <= line("w$")
			silent! exe "norm! " . s:scrollup

			if newLastLine <= line("w$")
				redraw
			else
				" we scrolled too much. reverse one line
				silent! exe "norm! " . s:scrolldown
				break
			endif
		endwhile

		" move the cursor to the proper line
		silent! exe "norm! L"
	endif
endfunction

" restore 'cpoptions'
set cpo&
if 1
	let &cpoptions = s:save_cpo
	unlet s:save_cpo
endif
