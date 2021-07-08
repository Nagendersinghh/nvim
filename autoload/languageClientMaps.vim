function! languageClientMaps#CreateMappings()
    if has_key(g:LanguageClient_serverCommands, &filetype)
        " Open all available actions for a word under the cursor.
        nnoremap <buffer> <silent> <leader>m :call LanguageClient_contextMenu()<cr>
        " Open document hover for a word under the cursor.
        nnoremap <buffer> <silent> K :call LanguageClient#textDocument_hover()<cr>
        " Goto the definition of the word under the cursor.
        nnoremap <buffer> <silent> gd :call LanguageClient#textDocument_definition()<cr>
        " Goto type definition under cursor.
        nnoremap <buffer> <silent> gt :call LanguageClient#textDocument_typeDefinition()<cr>
        " Goto implementation under cursor.
        nnoremap <buffer> <silent> gi :call LanguageClient#textDocument_implementation()<cr>
        " List the current buffers symbols.
        nnoremap <buffer> <silent> <C-s> :call LanguageClient#textDocument_documentSymbol()<cr>
        " List all references of the identifier under the cursor.
        nnoremap <buffer> <silent> <leader>U :call LanguageClient#textDocument_references()<cr>
        " Rename identifier under cursor.
        noremap <buffer> <leader>rn :call LanguageClient#textDocument_rename()<cr>
        " Highlight usages of the symbol under the cursor.
        nnoremap <buffer> <silent> <leader>u :call LanguageClient#textDocument_documentHighlight()<cr>
        " Clear usage highlights
        nnoremap <buffer> <silent> <leader>cl :call LanguageClient#clearDocumentHighlight()<cr>
        " Mnemonic p -> patch up
        nnoremap <buffer> <silent> <leader>p :call LanguageClient_textDocument_codeAction()<cr>

        " Use the language server with Vim's formatting operator gq
        setlocal formatexpr=LanguageClient#textDocument_rangeFormatting_sync()
    endif
endfunction
