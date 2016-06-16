call SetTabstop(3)


setlocal formatoptions=tcroqlnMj

nnoremap <buffer> <F5> :!make<CR>

" Switching between spec and body
nnoremap <buffer> <leader>bs    :call AdaGotoSpec()<CR>
nnoremap <buffer> <leader>bb    :call AdaGotoBody()<CR>

if !exists("g:ada_switch_spec_and_body")
    let g:ada_switch_spec_and_body = 1

    function! AdaGotoSpec()
        let l:module = expand('%:r')
        execute "edit " . l:module . '.ads'
    endfunction

    function! AdaGotoBody()
        let l:module = expand('%:r')
        execute "edit " . l:module . '.adb'
    endfunction
endif


