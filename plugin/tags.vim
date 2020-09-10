if executable("ctags")

	if executable("fzf")
		" Jump to tag under cursor, but if there is more than one use fzf to preview
		function! s:FuzzyTagPicker()
			let l:tag = expand("<cword>")
			let l:fileName = expand("%")
			let l:tags = taglist(l:tag, l:fileName)
			if empty(l:tags)
				echo "Tag '" . l:tag . "' not in tag file"
			elseif len(l:tags) == 1
				execute "edit " . l:tags[0]["filename"]
				execute "normal " . l:tags[0]["cmd"]
			else
				" TODO: See what the fastest way of doing this is
				let l:tagFileLoc="$TMPDIR/vimtagfile"
				execute "silent !rm " . l:tagFileLoc
				let i = 0
				let writeList = []
				for tagMatch in l:tags
					call add(writeList, i . " " . tagMatch["cmd"] . " " . tagMatch["filename"])
					let i += 1
				endfor
				call writefile(writeList, expand(l:tagFileLoc))
			endif
		endfunction

		nnoremap <leader>] :call <SID>FuzzyTagPicker()<CR>
	endif

	" Run an async job to generate tag files using universal ctags
	function! tags#runAsyncTagsCallback(channel)
		let l:initJob = ch_getjob(a:channel)
		let l:initJobInfo = job_info(l:initJob)
		let l:jobExitCode = str2nr(l:initJobInfo["exitval"])
		let l:msg = (l:jobExitCode != 0) ? "Error generating tags file" : "Generated tags file"
		echo l:msg
	endfunction

	function! s:runAsyncTagsGeneration()
		call job_start("ctags -R .", {"close_cb":"tags#runAsyncTagsCallback"})
	endfunction

	nnoremap <leader>t :call <SID>runAsyncTagsGeneration()<CR>
endif
