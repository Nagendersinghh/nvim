echom "what"

setlocal foldmethod=expr
" Note the `v` in the parameter. Find out what
" it does.
setlocal foldexpr=GetFold(v:lnum)

" TODO: Use script local functions instead of global
" ones.

function! IndentLevel(lnum)
    return indent(a:lnum) / &shiftwidth
endfunction

function! NextNonBlankLine(lnum)
    let numlines = line('$')
    let current = a:lnum + 1

    while (current <= numlines)
        if getline(current) =~? '\v\S'
            return current
        endif
        let current += 1
    endwhile

    return -2
endfunction

function! IsListItem(lnum)
    " TODO: Add support for further lists
    if getline(a:lnum) =~? '\v\s*- \[.\] .*'
        return 1
    endif
    return 0
endfunction

function! ContainsListItem(lnum)
    " Until you find a line with the
    " same indent level which is not
    " the continuation of the current
    " list, check if a line is a list
endfunction

function! GetFold(lnum)
    let thisIndent = IndentLevel(a:lnum)
    let nextIndent = IndentLevel(NextNonBlankLine(a:lnum))

    if IsListItem(a:lnum)
        if ContainsListItem(a:lnum)
            return '>' . thisIndent + 1
        else
            return thisIndent
        endif
    endif


    if nextIndent == thisIndent
        return thisIndent
    elseif nextIndent < thisIndent
        return thisIndent
    elseif nextIndent > thisIndent
        " Find out more about the .
        return '>' . nextIndent
    endif
endfunction

