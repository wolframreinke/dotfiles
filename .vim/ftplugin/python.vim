"    ____
"   |  _ \      _   _
"   | | \ \    | | | |
"   | |_/ /   _| |_| |___  ___  _,___
"   |  __/\  / |  _/  _  |/ _ \|  _  |
"   | |  \ \/ /| |_| | | | (_) | | | |
"   |_|___\  /_|___/_|_|_|\___/|_|_|_|_
"  /______/ /_________________________/
"        /_/
"
setlocal textwidth=80
setlocal tabstop=4
setlocal shiftwidth=4
setlocal softtabstop=4
setlocal smarttab
setlocal expandtab
setlocal autoindent
setlocal fileformat=unix
setlocal foldmethod=indent
setlocal foldlevel=99

setlocal formatoptions=tcroqlnMj

nnoremap <buffer> <leader>gr    :call PyTogglePythonReload()<CR>
function! PyTogglePythonReload()
    if exists('b:python_send_reload')
        if b:python_send_reload == 1
            let b:python_send_reload=0
            echo 'interpreter-reloading deactivated.'
        else
            let b:python_send_reload=1
            echo 'interpreter-reloading activated.'
        endif
    else
        let b:python_send_reload=1
        echo 'interpreter-reloading activated.'
        call PythonReload()
    endif
endfunction

augroup PythonGroup
    autocmd!
    autocmd BufWritePost *.py  :call PythonReload()
augroup END
function! PythonReload()
    if exists('b:python_send_reload')
        if b:python_send_reload == 1
            call feedkeys(':SlimeSend1 reload(' . expand("%:t:r") . ')', 'n')
        endif
    endif
endfunction

nnoremap <buffer> <leader>im    :split +/import<CR>

" interaction with the python interpreter
nnoremap <buffer> <F7> :!python %<CR>
nnoremap <buffer> <F9> :!python -i %<CR>

" Autocompletion!!!
inoremap <buffer> <leader>cl    class <C-o>mt:<CR>«body\|pass»<Esc>`ta
inoremap <buffer> <leader>fn    def <C-o>mt(«params»):<CR>«body\|pass»<Esc>`ta
inoremap <buffer> <leader>me    def <C-o>mt(self«params»):<CR>«body\|pass»
                               \<Esc>`ta
inoremap <buffer> <leader>co    def __init__(self<C-o>mt):<CR>«body\|pass»
                               \<Esc>`ta
inoremap <buffer> <leader>if    if <C-o>mt:<CR>«then\|pass»<Esc>`ta
inoremap <buffer> <leader>ie    if <C-o>mt:<CR>«then\|pass»<CR>else:<CR>
                               \«else\|pass»<Esc>`ta
inoremap <buffer> <leader>wh    while <C-o>mt:<CR>«body\|pass»<Esc>`ta
inoremap <buffer> <leader>fo    for <C-o>mt in «range»:<CR>«body\|pass»<Esc>`ta
inoremap <buffer> <leader>fe    for <C-o>mt in «range»:<CR>«body\|pass»<CR>
                               \«else\|pass»<Esc>`ta
inoremap <buffer> <leader>tr    try:<CR><C-o>mt<CR>except «error»:<C-D><CR>
                               \«on-fail\|pass»<Esc>`ta
inoremap <buffer> <leader>ma    if __name__ == "__main__":<CR>

vnoremap <buffer> <leader>if    >:'<<CR>Oif :<Left>
vnoremap <buffer> <leader>fo    >:'<<CR>Ofor <C-D><C-o>mt in «range»:<ESC>`tela
vnoremap <buffer> <leader>wh    >:'<<CR>Owhile :<Left>
vnoremap <buffer> <leader>tr    >:'><CR>oexcept <C-o>mt:<C-D><CR>«on-fail\|pass»
                               \<ESC>:'<<CR>Otry:<ESC>`ti
vnoremap <buffer> <leader>fn    >:'<<CR>Odef (<C-o>mt«params»):<ESC>`ti
