function! fireplaceHelpers#Reload()
    " HACK: Internal of vim-fireplace, should not depend on it.
    if !exists('g:autoloaded_fireplace')
        finish
    endif

    :Require
endfunction
