""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"		XmlPretty 		Todd Freed		todd.freed@gmail.com
"
"		Introduction
" -------------------
"  Provides functionality to format text as Xml such that
"  each tag is on its own line, with child content indented
"  with respect to the parent tag
"
"  	Usage
" -------------------
"  XmlPretty()
"  	The entire buffer is formatted as Xml text
"
"  XmlPretty([])
"  	The entire buffer is formatted as Xml text and returned
"  	as a List of lines
"
"  XmlPretty(start {, end, {[]}})
"  	The section of the buffer starting on line {start} and
"  	continuing to the end of the buffer, or until line {end}
"  	will be formatted as Xml text. If the third parameter is
"  	specified, then this is returned as a List of lines and
"  	the buffer is not modified
"
"  XmlPretty(text)
"  	The {text} parameter is formatted as Xml text and returned
"  	as a List of lines
"
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

" generates whitespace
function! Whitespace(indent)
	let tabstop = 3

	return repeat(' ', a:indent * tabstop)
endfunction

" Trim whitespace from beginning and end of val. optionally include other
" characters to trim from the beginning and end with 2nd and 3rd params
function! Trim(val, ...)
	let startchars = ''
	let endchars = ''
	if(len(a:000) > 0)
		let startchars = a:000[0]
	endif
	if(len(a:000) > 1)
		let endchars = a:000[1]
	endif

	let start = "^[ \t" . startchars . "]*"
	let end = "[ \t" . endchars . "]*$"

	let val = substitute(a:val, start, '', '')
	let val = substitute(val, end, '', '')

	return val
endfunction

function! XmlPretty(...)
	let buf = ''

	if(len(a:000) > 0 && type(a:000[0]) == type(''))
		let buf = a:000[0]
	else
		let bufnum = bufnr("%")

		let firstline = 1
		let lastline = len(getbufline(bufnum, 1, "$"))
		if len(a:000) > 0 && type(a:000[0]) == type(0)
			let firstline = a:000[0]
		endif
		if len(a:000) > 1 && type(a:000[1]) == type(0)
			let lastline = a:000[1]
		endif

		let linearray = getbufline(bufnum, firstline, lastline)

		" Get the buffer into one string
		for index in range(lastline - firstline + 1)
			let o = getline(index +  firstline)
			let buf = buf . o
		endfor
	endif

	" Generate indexes of all of the xml tags in the buffer
	let regex = "<\\(\\/\\)\\?\\([a-zA-Z0-9-._:]*\\)\\(\\( [a-zA-Z_:][a-zA-Z0-9.-_:]*=\\(\\('[^']\\+'\\)\\|\\(\"[^\"]\\+\"\\)\\)\\)*\\)\\? *\\(\\/\\)\\?>"
	let match = {'start': 0, 'end': 0, 'len': 0, 'endnode': 0, 'selfterm': 0}
	let matches = [match]
	while match['start'] > -1
		call add(matches, match)

		let start = match(buf, regex, matches[-1]['end'])
		if start > -1
			let rawmatch = matchlist(buf, regex, matches[-1]['end'])

			let nodename = rawmatch[2]
			let end = start + len(rawmatch[0])
			let endnode = len(rawmatch[1])
			let selfterm = len(rawmatch[8])
		endif

		let match = {'nodename': nodename, 'start': start, 'end': end, 'len': end - start, 'endnode': endnode, 'selfterm': selfterm}
	endwhile

	" remove first entry - it was a dummy
	call remove(matches, 0, 1)

	" Generate array of new lines
	let lines = []
	let indent = 0

	" Copy text before the first tag
	if matches[0]['start'] > firstline
		let text = strpart(buf, firstline-1, matches[0]['start'])
		call add(lines, text)
	endif

	for x in range(len(matches))
		let match = matches[x]
		let part = strpart(buf, match['start'], match['len'])
		if x != 0
			" Copy text between the last tag and this tag
			if (matches[x]['start'] - matches[x-1]['end']) > 1
				let text = strpart(buf, matches[x-1]['end'], matches[x]['start'] - matches[x-1]['end'])
				
				" trim
				let text = substitute(text, "^[ \t]*", '', '')
				let text = substitute(text, "[ \t]*$", '', '')

				if len(text)
					" Treat contents of <style> tag as css and invoke css
					" pretty-print
					if(tolower(match['nodename']) == 'style' && exists("*CssPretty"))
						let csslines = CssPretty(text)
						for x in range(len(csslines))
							call add(lines, Whitespace(indent) . csslines[x])
						endfor
					else
						call add(lines, Whitespace(indent) . text)
					endif
				endif
			endif
		endif

		if match['selfterm']
			call add(lines, Whitespace(indent) . part)
		elseif match['endnode']
			let indent = indent - 1
			call add(lines, Whitespace(indent) . part)
		else
			call add(lines, Whitespace(indent) . part)
			let indent = indent + 1
		endif

	endfor

	" just return the lines if requested
	if len(a:000) > 2 || (len(a:000) > 0 && type(a:000[0]) == type([])) || (len(a:000) > 1 && type(a:000[1]) == type([]))
		return lines
	" or if this function was invoked with a string as its first argument
	elseif len(a:000) > 0 && type(a:000[0]) == type('')
		return lines
	endif

	" Otherwise, rewrite the buffer by first removing all lines from the buffer in the specified range, inclusive
	for x in range(lastline - firstline + 1)
		call setline(x+firstline, '')
	endfor
	call cursor(lastline, 1)
	for x in range(lastline - firstline + 1)
		exe 'normal ' . "a\b\e"	
	endfor

	" and appending into the buffer
	let line = firstline - 1
	for x in range(len(lines))
		call append(line, lines[x])
		let line = line + 1
	endfor

	return

	" Remove any further lines in the buffer
	if(len(linearray) >= line)
		for x in range(len(linearray) - line + 1)
			call setline(x+line, '')
		endfor
		call cursor(len(linearray), 1)
		for x in range(len(linearray) - line + 1)
			exe 'normal ' . "a\b\e"	
		endfor
	endif
endfunction
