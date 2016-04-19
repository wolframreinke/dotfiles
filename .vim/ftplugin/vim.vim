setlocal formatoptions=croql
setlocal textwidth=80
setlocal tabstop=4
setlocal softtabstop=4
setlocal shiftwidth=4

ia <buffer> sl setlocal
ia <buffer> tw textwidth
ia <buffer> ts tabstop
ia <buffer> sts softtabstop
ia <buffer> sw shiftwidth
ia <buffer> fo formatoptions
ia <buffer> im inoremap
ia <buffer> nm nnoremap
ia <buffer> vm vnoremap
ia <buffer> bu <buffer>
ia <buffer> le <leader<Space><BackSpace>>

nnoremap <buffer> <leader>s     :source ~/.vimrc<CR>

inoremap <buffer> <leader>fn    function! <C-o>mt()<CR>«body»<CR>endfunction
                               \<ESC>`ta
inoremap <buffer> <leader>ac    inoremap <buffer> <leader<Space><BackSpace>>
                               \<C-o>mt<Tab>«result»<Esc<Space><BackSpace>>`ta
                               \<ESC>`ta
