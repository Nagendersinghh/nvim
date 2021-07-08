" my filetype file
if exists("did_load_filetypes")
	finish
endif
augroup filetypedetect
	autocmd! BufRead,BufNewFile *.highland setfiletype highland
	autocmd! BufRead,BufNewFile *.fountain setfiletype fountain
	" For some reason vim can't detect the filetype if
	" the extension is nvim.
	autocmd! BufRead,BufNewFile *.nvim setfiletype vim
augroup END

