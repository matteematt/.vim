" Plugin which is used to toggle comments for various filetypes

function comments#CommentCheckVimscript(checkLine)
	let l:matchIndex = match(a:checkLine, '^\s*"')
	return (l:matchIndex == -1) ? 0 : 1
endfunction

function comments#CommentCheckCLike(checkLine)
	let l:matchIndex = match(a:checkLine, '^\s*\/\/')
	return (l:matchIndex == -1) ? 0 : 1
endfunction

let s:commentCommands = {
	\"vim": {"cmd": "comments#CommentCheckVimscript", "add":'0I f"2xhx', "del": 'I" '},
	\"clike": {"cmd": "comments#CommentCheckCLike", "add":'0I f/3xhx', "del": 'I// '}
	\}

let s:filetypesMap = {
	\"vim":"vim",
	\"javascript":"clike",
	\}

function s:ToggleComments() range
	" This is a comment
	let l:fileType = &filetype
	if !has_key(s:filetypesMap, l:fileType)
		echo "Comment toggle not setup for filetype: " . l:fileType
		return
	endif

	let cursorPos = getcurpos()
	let l:checkLine = getline(a:firstline)

	let l:cmdDict = s:commentCommands[s:filetypesMap[l:fileType]]
	let l:CheckCmd = function(l:cmdDict["cmd"])
	let l:cmd = l:CheckCmd(l:checkLine) ? l:cmdDict["add"] : l:cmdDict["del"]
	execute a:firstline . "," . a:lastline  . " normal " . l:cmd

	call setpos('.', cursorPos)
endfunction

nnoremap <leader>cc :call <SID>ToggleComments()<CR>
vnoremap <leader>cc :call <SID>ToggleComments()<CR>
