function filetypeSetups#clojure#reformat#breakIntoMulti()
    " Dependent on vim-sexp
    <Plug>(sexp_move_to_next_bracket)
    let formChar = matchstr(getline('.'), '\%' . col('.') . 'c.')
    let formEndPos = getcurpos()
    <Plug>(sexp_move_to_prev_bracket)
    let formStartPos = getcurpos()
    <Plug>(sexp_move_to_next_element_tail)
    " Count the number of elements in form
    let elementCount = 0
    " Move inside the form
    l
    let currentPos = getcurpos()
    let endOfTheForm = currentPos ==# formEndPos
    while !endOfTheForm
        " Move to the tail of the element
        <Plug>(sexp_move_to_next_element_tail)
        let elementCount += 1
        " Move past the current element
        l
        let endOfTheForm = getcurpos() ==# formEndPos
    endwhile
    if formChar ==# ']'
        :call s:GoToNthElement(1)
        let isLastElement = s:IsLastElement()
        while !isLastElement
            <Plug>(sexp_move_to_next_element_tail)
            " Replace the space with 'enter'
            lr
            " Go to the next element
            l
            let isLastElement = s:IsLastElement()
        endwhile
    elseif formChar ==# ')'
    " Get the type of form (function call, dictionary,
    " function arguments/vector)
    " Switch form-type:
    " case function-call:
    "   go to the second element of form.
    "   start indenting:
    "   check if last element
    "     end
    "   indent the next element
    "   go to start indenting
    " case function-arguments/vector:
    "   go to first element of form.
    "   start indenting:
    "   check if last element
    "     end
    "   indent the next element
    "   go to start indenting
    " case dictionary:
    "   go to the second element of the form.
    "   start indenting:
    "   check if the last element
    "     end
    "   indent the next element
    "   go to the next element
    "   go to start indenting
endfunction
