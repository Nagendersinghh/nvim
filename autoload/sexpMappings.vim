function! sexpMappings#CreateMappings()
    if !exists('g:sexp_loaded')
        return
    endif

    nmap <silent><buffer> B           <Plug>(sexp_move_to_prev_element_head)
    xmap <silent><buffer> B           <Plug>(sexp_move_to_prev_element_head)
    omap <silent><buffer> B           <Plug>(sexp_move_to_prev_element_head)
    nmap <silent><buffer> W           <Plug>(sexp_move_to_next_element_head)
    xmap <silent><buffer> W           <Plug>(sexp_move_to_next_element_head)
    omap <silent><buffer> W           <Plug>(sexp_move_to_next_element_head)
    nmap <silent><buffer> gE          <Plug>(sexp_move_to_prev_element_tail)
    xmap <silent><buffer> gE          <Plug>(sexp_move_to_prev_element_tail)
    omap <silent><buffer> gE          <Plug>(sexp_move_to_prev_element_tail)
    nmap <silent><buffer> E           <Plug>(sexp_move_to_next_element_tail)
    xmap <silent><buffer> E           <Plug>(sexp_move_to_next_element_tail)
    omap <silent><buffer> E           <Plug>(sexp_move_to_next_element_tail)
    imap <silent><buffer> <C-h>       <Plug>(sexp_insert_backspace)
endfunction
