" SetSaneWrapOptions {{{
function! wrapOptions#SetSaneWrapOptions()
	if !exists('b:hasSaneWrapOptions')
		let b:hasSaneWrapOptions = 1
		" Wrap lines longer than screen width, breaking only at
		" word boundaries.
		setlocal wrap
		setlocal linebreak
	endif
endfunction
" }}}
