if has("syntax") && has("virtualedit")
  " Loop through each row and tries to find a column to jump to
  function! s:FindJumpRow()
    " won't find anything if already on first line
    if getcurpos()[1] == 1 | return 0 | endif
    " keep searching until found candidate or top of file
    while 1
      norm k
      let findLine = search("\\s\\ze\\S", 'nz', line('.'))
      if findLine | return findLine | endif
      if getcurpos()[1] == 1 | return 0 | endif
    endwhile
  endfunction

  " Move the cursor to x,y position in the current buffer
  function! s:MoveCursorTo(x, y)
    let cursorPos = getcurpos()
    let cursorPos[1] = a:y
    let cursorPos[2] = a:x
    call setpos('.', cursorPos)
  endfunction

  " Main function
  function! s:ColJumper(callback)
    let initialPosition = getcurpos()
		let initialVE = &virtualedit
    set virtualedit=all
    let candidateRow = s:FindJumpRow()
    call setpos('.', initialPosition)
    if candidateRow != 0
      call s:MoveCursorTo(initialPosition[2], candidateRow)
      call search("\\s\\ze\\S", 'z', line('.'))
      let col = getcurpos()[2]
      call a:callback(col, initialPosition[1])
    endif
    let &virtualedit=initialVE
  endfunction

  " For jumping the cursor out onto RHS whitespace
  function! s:JumpCursorCallback(x, y)
      call s:MoveCursorTo(a:x, a:y)
      exec "norm i "
  endfunction
  let JumpcursorCallback = function("s:JumpCursorCallback")

  inoremap <C-j> :call <SID>ColJumper(JumpcursorCallback)<CR>a
endif
