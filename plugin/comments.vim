" Plugin which is used to toggle comments for various filetypes

function comments#CommentCheckVimscript(checkLine)
	let l:matchIndex = match(a:checkLine, '^\s*"')
	return (l:matchIndex == -1) ? 0 : 1
endfunction

function s:ToggleComments() range
	" This is a comment
	let cursorPos = getcurpos()
	let l:checkLine = getline(a:firstline)
	if comments#CommentCheckVimscript(l:checkLine)
		let l:addComment = '0I f"2xhx'
		execute a:firstline . "," . a:lastline  . " normal " . l:addComment
	else
		let l:removeComment = 'I" '
		execute a:firstline . "," . a:lastline  . " normal " . l:removeComment
	endif
	call setpos('.', cursorPos)
endfunction

nnoremap <leader>cc :call <SID>ToggleComments()<CR>
vnoremap <leader>cc :call <SID>ToggleComments()<CR>
