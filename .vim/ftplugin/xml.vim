setlocal tabstop=4
setlocal shiftwidth=4
setlocal softtabstop=4
setlocal smarttab
setlocal expandtab

augroup XMLGroup
    autocmd!
    autocmd BufWritePost *.xml :call TMUXRefresh_Refresh()
    autocmd BufWritePost *.xsl :call TMUXRefresh_Refresh()
    autocmd BufWritePost *.xsd :call TMUXRefresh_Refresh()
augroup END

let b:TMUXRefreshActivated = 0

nnoremap <buffer> <leader>gr    :call TMUXRefresh_Cycle()<CR>
nnoremap <buffer> <leader>gss   :call AskForSchema()<CR>
nnoremap <buffer> <leader>gsx   :call AskForXSLTStylesheet()<CR>


function! SetSchema(schemafile)
    let l:cmd = 'xmllint --noout --schema ' . a:schemafile . ' ' . expand('%')
    let l:entry = [l:cmd, 'Schema validation']

    if index(b:TMUXRefreshCycle, l:entry) == -1
        call add(b:TMUXRefreshCycle, l:entry)
    endif

    if b:TMUXRefreshActivated == 0
        call TMUXRefresh_Activate()
    endif

    if b:TMUXRefreshCycleIndex == -1
        call TMUXRefresh_Cycle()
    endif
endfunction

function! SetXSLTStylesheet(xsltfile)
    let l:cmd = 'xsltproc ' . a:xsltfile . ' ' . expand('%:p')
    let l:entry = [l:cmd, 'XSLT processing']

    if index(b:TMUXRefreshCycle, l:entry) == -1
        call add(b:TMUXRefreshCycle, l:entry)
    endif

    if b:TMUXRefreshActivated == 0
        call TMUXRefresh_Activate()
    endif

    if b:TMUXRefreshCycleIndex == -1
        call TMUXRefresh_Cycle()
    endif
endfunction

function! AskForSchema()
    let l:response = input('XML Schema: ', expand('%:t:r') . '.xsd')
    call SetSchema(l:response)
endfunction

function! AskForXSLTStylesheet()
    let l:response = input('XSLT Stylesheet: ', expand('%:t:r') . '.xsl')
    call SetXSLTStylesheet(l:response)
endfunction
