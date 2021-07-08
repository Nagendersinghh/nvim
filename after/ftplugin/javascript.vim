" Split a long destructuring into multiple lines
nnoremap <buffer> gob :<c-u>s;\(\({\\|,\)\zs *\\| \ze}\);\r;g<cr><Bar>:'[,']normal ==<cr><Bar>:noh<cr>$

setlocal tabstop=4 shiftwidth=4 softtabstop=0 expandtab foldmethod=syntax
iabbrev <buffer> iff if ()<left>
" Mark the render method in react files
call markUtils#MarkRender()
