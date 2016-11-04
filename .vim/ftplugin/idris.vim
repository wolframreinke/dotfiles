" +--------------------------------------------------------------------------+ "
" |                          ENVIRONMENT VARIABLES                           | "
" +--------------------------------------------------------------------------+ "

let maplocalleader = ","

setlocal tabstop=2
setlocal shiftwidth=2
setlocal softtabstop=2
setlocal smarttab
setlocal expandtab

setlocal omnifunc=necoghc#omnifunc
setlocal keywordprg=hooglepager

augroup HaskellGroup
    autocmd!
    autocmd BufWritePost *.idr*  :call HaskellGHCIReload()
augroup END

" +--------------------------------------------------------------------------+ "
" |                              UNICODE STUFF                               | "
" +--------------------------------------------------------------------------+ "
inoremap <buffer> \> →
inoremap <buffer> \l λ
inoremap <buffer> \L Λ

" +--------------------------------------------------------------------------+ "
" |                               KEYBINDINGS                                | "
" +--------------------------------------------------------------------------+ "

nnoremap <buffer> <leader>im    :split +/import<CR>

nnoremap <buffer> <leader>gr    :call HaskellToggleGHCIReload()<CR>

" GHCi control
nnoremap <buffer> <leader>ggt   :call HaskellGHCIDo('(GHCi Type) Function: ',':t')<CR>
nnoremap <buffer> <leader>ggi   :call HaskellGHCIDo('(GHCi Info) Function: ',':info')<CR>

nnoremap <buffer> <leader>gt    viw:call HaskellGHCIQuery(':t', 1)<CR>
vnoremap <buffer> <leader>gt       :call HaskellGHCIQuery(':t', 1)<CR>
nnoremap <buffer> <leader>gin   viw:call HaskellGHCIQuery(':i', 0)<CR>
vnoremap <buffer> <leader>gin      :call HaskellGHCIQuery(':i', 0)<CR>
nnoremap <buffer> <leader>gd    viw:call HaskellGHCIQuery(':doc', 0)<CR>
vnoremap <buffer> <leader>gd       :call HaskellGHCIQuery(':doc', 0)<CR>

nnoremap <buffer> <leader>git   viw:call HaskellGHCIInsertType()<CR>
vnoremap <buffer> <leader>git      :call HaskellGHCIInsertType()<CR>

nnoremap <buffer> gf            viW:call HaskellOpenModule()<CR>
vnoremap <buffer> gf            :call HaskellOpenModule()<CR>


" +--------------------------------------------------------------------------+ "
" |                                FUNCTIONS                                 | "
" +--------------------------------------------------------------------------+ "
if !exists("*HaskellOpenModule")
    function HaskellOpenModule()
        normal gv"yy
        let l:path = substitute(@y, '\.', '/', 'g') . '.hs'
        if filereadable(l:path)
            edit l:path
        elseif filereadable('src/' . l:path)
            let l:path = 'src/' . l:path
            execute 'edit ' . l:path
        else
            echo "Could not find module " . @y
        endif
    endfunction
endif

" Execute a command in GHCi after asking the user for a parameter.  The first
" argument of this function is the text that is displayed to the user.
function! HaskellGHCIDo(text, cmd)
    let l:fun = input(a:text)
    call feedkeys(':SlimeSend1 ' . a:cmd . ' ' . l:fun . '', 'n')
endfunction

function! HaskellGHCIQuery(cmd, addparens)
    normal gv"yy
    if a:addparens
        let @y = '(' . @y . ')'
    endif
    call feedkeys(':SlimeSend1 ' . a:cmd . ' ' . @y . '', 'n')
endfunction

function! HaskellGHCIInsertType()
    normal gv"yy
    if !exists('b:slime_config')
        SlimeConfig
    endif
    let l:pane = b:slime_config['target_pane']
    call feedkeys('k:r!newoutput ' . l:pane . ' ":t ' . @y . '" | head -n -1', 'n')
endfunction

" Executes a command in GHCi without asking for user input.
function! HaskellGHCIExec(cmd)
    call feedkeys(':SlimeSend1 ' . a:cmd . '', 'n')
endfunction

" Toggles the GHCi-reloading mode.  Available modes are:
"   RELOADING   reload the source in GHCi, i.e. execute :r
"   TESTING     rerun the tests, i.e. execute :!test
"   NONE        do nothing
"
" The action associated with the current GHCi-reloading mode is executed when
" the buffer is saved.
function! HaskellToggleGHCIReload()
    if exists('b:haskell_send_reload')
        if b:haskell_send_reload == 'r'
            let b:haskell_send_reload = 't'
            echo 'GHCi-reloading: TESTING.'
        elseif b:haskell_send_reload == 't'
            let b:haskell_send_reload = '-'
            echo 'GHCi-reloading: DEACTIVATED.'
        else
            let b:haskell_send_reload = 'r'
            echo 'GHCi-reloading: RELOADING.'
        endif
    else
        let b:haskell_send_reload = 'r'
        echo 'GHCi-reloading: RELOADING'
        call HaskellGHCIReload()
    endif
endfunction

" Executes the action associated with the currently active GHCi-reloading mode.
" (see above)
function! HaskellGHCIReload()
    if exists('b:haskell_send_reload')
        if b:haskell_send_reload == 'r'
            call feedkeys(':SlimeSend1 :r', 'n')
        elseif b:haskell_send_reload == 't'
            call feedkeys(':SlimeSend1 :test', 'n')
        endif
    endif
endfunction
