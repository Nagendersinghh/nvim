function! markUtils#MarkRender()
	if !exists('b:renderMarked')
		let b:renderMarked = 1
		if search('render \?() \?{', 'swc') > 0
			" Mark the render function with r
			normal! mr
			" Move to the original position
			normal! ''
		endif
	endif
endfunction

