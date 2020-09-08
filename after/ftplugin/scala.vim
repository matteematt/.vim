" In the after directory so it can override options from vim-polyglot

setlocal include=^\\s*import

if executable("rg")
	" TODO: Maybe have a maximum amount of .scala files before we say it's too slow?
	" TODO: This does not account for nested packages using multiple blocks
	function scala#Includeexpr(fname)
		" echo "a:fname : " . a:fname
		" let l:split = split(a:fname, "\\.")
		" if match(l:split[0], "\(scala)") != -1
			" echo l:split[0] . " matches"
			" return
		" endif
		" echo l:split
		" let l:pkgIndex = 0
		" for token in l:split
			" if match(token, "^\\u") != -1
				" break
			" endif
			" let l:pkgIndex += 1
		" endfor
		" echo l:pkgIndex
		echo "Running scala#Includeexpr"
	endfunction
	setlocal includeexpr=scala#Includeexpr(v:fname)
	" setlocal define
else
	" The issue with this is that it assumes that the project structure is strict like Java
	setlocal includeexpr=substitute(v:fname,'\\.','/','g')
endif
