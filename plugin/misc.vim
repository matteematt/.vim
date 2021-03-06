" strips trailing whitespace at the end of files. this
" This is called on BufWritePre *
function! StripTrailingWhitespaces()
    " save last search & cursor position
    let _s=@/
    let l = line(".")
    let c = col(".")
    %s/\s\+$//e
    let @/=_s
    call cursor(l, c)
endfunction

augroup setStripWhitespace
  autocmd!
  autocmd BufWritePre * :call StripTrailingWhitespaces()
augroup END
