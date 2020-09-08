function s:GenerateTags()
	silent !ctags -R . --exclude=target --exclude=vendor
	redraw!
endfunction
nnoremap <buffer>		<leader>t :call <SID>GenerateTags()<CR>
