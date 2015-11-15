setlocal shiftwidth=4
setlocal tabstop=4
setlocal softtabstop=4

inoremap <buffer> <leader>if if [ <C-o>mt ]; then<CR>«body»<CR>fi<ESC>`ta
inoremap <buffer> <leader>fo for <C-o>mt in «list»; do<CR>«body»<CR>done<ESC>`ta
inoremap <buffer> <leader>wh while <C-o>mt; do<CR>«body»<CR>done<ESC>`ta
inoremap <buffer> <leader>fn function <C-o>mt<CR>{<CR>«body»<CR>}<ESC>`ta
inoremap <buffer> <leader>ca case <C-o>mt; in<CR>*) «body»;;<CR>esac
                             \<ESC>`ta
inoremap <buffer> <leader>er echo "<C-o>mt" 2>&1<ESC>`ta

setlocal comments=:# 
setlocal formatoptions+=jcroq
