setlocal formatoptions=croql
setlocal textwidth=80
setlocal tabstop=4
setlocal softtabstop=4
setlocal shiftwidth=4

ia sl setlocal
ia tw textwidth
ia ts tabstop
ia sts softtabstop
ia sw shiftwidth
ia fo formatoptions
ia im inoremap
ia nm nnoremap
ia vm vnoremap
ia bu <buffer>
ia le <leader<Space><BackSpace>>

nnoremap <buffer> <leader>s     :source ~/.vimrc<CR>

inoremap <buffer> <leader>fn    function! <C-o>mt()<CR>«body»<CR>endfunction
                               \<ESC>`ta
inoremap <buffer> <leader>ac    inoremap <buffer> <leader<Space><BackSpace>>
                               \<C-o>mt<Tab>«result»<Esc<Space><BackSpace>>`ta
                               \<ESC>`ta
