setlocal tw=80
setlocal tw=80
setlocal shiftwidth=4
setlocal tabstop=4
setlocal softtabstop=4
setlocal expandtab


setlocal formatoptions+=croql

" scoped rename!
nnoremap <buffer> <leader>rR    *NviBVokk:s///g<Left><Left>

" switch between header and C++ file
nnoremap <buffer> <leader>s     :call SwitchSourceHeader()<CR>

" ----------------------------- AUTO COMPLETION ------------------------------ "
inoremap <buffer> <leader>cl    class  <C-o>mt {<CR>«decls»<CR>};<C-o>`t<C-o>x
inoremap <buffer> <leader>tc    template <«template\|typename T»><CR>
                               \class  <C-o>mt {<CR>«decls»<CR>};<C-o>`t<C-o>x
inoremap <buffer> <leader>ts    template <«template\|typename T»><CR>
                               \struct  <C-o>mt {<CR>«decls»<CR>};<C-o>`t<C-o>x


" -------------------------------- FUNCTIONS --------------------------------- "

if exists('*SwitchSourceHeader')
    finish
endif

function! SwitchSourceHeader()
    if expand("%:e") == "cpp"
        find %:t:r.h
    else
        find %:t:r.cpp
    endif
endfunction
