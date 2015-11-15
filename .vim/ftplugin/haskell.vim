" +--------------------------------------------------------------------------+ "
" |                          ENVIRONMENT VARIABLES                           | "
" +--------------------------------------------------------------------------+ "

setlocal tabstop=2
setlocal shiftwidth=2
setlocal softtabstop=2
setlocal smarttab
setlocal expandtab

setlocal omnifunc=necoghc#omnifunc
setlocal keywordprg=hoogle\ --info

augroup HaskellGroup
    autocmd!
    autocmd BufWritePost *.hs*  :call HaskellGHCIReload()
augroup END



" +--------------------------------------------------------------------------+ "
" |                               KEYBINDINGS                                | "
" +--------------------------------------------------------------------------+ "

" Commenting out stuff
nnoremap <buffer> <leader>c     mtI-- <ESC>`t
vnoremap <buffer> <leader>c     <C-V>0I-- <ESC>
nnoremap <buffer> <leader>cc    vip<C-V>0I-- <ESC>
nnoremap <buffer> <leader>C     mtI{- <ESC>A -}<ESC>`t
vnoremap <buffer> <leader>C     <ESC>a -}<ESC>gvo<ESC>i{- <ESC>


" Hdevtools commands
nnoremap <buffer> <F1>          :HdevtoolsType<CR>
nnoremap <buffer> <F2>          :HdevtoolsClear<CR>
nnoremap <buffer> <F3>          :HdevtoolsInfo<CR>

" Keysnippets command
inoremap <buffer> <leader>fn    <Space>:: «type\|Integer»<ESC>o= undefined<ESC>
                               \_h<C-v>kI
inoremap <buffer> <leader>im    import <C-o>mt («imports»)<ESC>`ta
inoremap <buffer> <leader>ia    import
inoremap <buffer> <leader>mo    module where<ESC>bbea<Space>
inoremap <buffer> <leader>da    data <C-o>mt = «data-decl»<ESC>`ta
inoremap <buffer> <leader>ty    type <C-o>mt = «type-decl»<Esc>`ta
inoremap <buffer> <leader>ri    <ESC>kyt<Space>jpA = undefined<ESC>b
inoremap <buffer> <leader>l     {-# LANGUAGE <C-o>mt #-}<ESC>`ta

inoremap <buffer> <leader>iq    <Esc>:call HaskellImportQualified()<CR>
nnoremap <buffer> <leader>gr    :call HaskellToggleGHCIReload()<CR>

" GHCi control
nnoremap <buffer> <leader>gt    :call HaskellGHCIDo('(GHCi Type) Function: ',':t')<CR>
nnoremap <buffer> <leader>gi    :call HaskellGHCIDo('(GHCi Info) Function: ',':info')<CR>
nnoremap <buffer> <leader>gh    :call HaskellGHCIDo('(GHCi Hoogle) Search: ',':hoogle')<CR>
nnoremap <buffer> <leader>gd    :call HaskellGHCIDo('(GHCi Hoogle) Doc: ',':doc')<CR>

" Cabal control
nnoremap <buffer> <leader>gcc   :call HaskellGHCIDo('cabal ',':!cabal')<CR>
nnoremap <buffer> <leader>gct   :call HaskellGHCIExec(':!cabal test')<CR>
nnoremap <buffer> <leader>gcr   :call HaskellGHCIExec(':!cabal run')<CR>
nnoremap <buffer> <leader>gcb   :call HaskellGHCIExec(':!cabal build')<CR>
nnoremap <buffer> <leader>gch   :call HaskellGHCIExec(':!cabal haddock')<CR>

nnoremap <buffer> <leader>re    viW:call HaskellExtractVar()<CR>
vnoremap <buffer> <leader>re    :call HaskellExtractVar()<CR>



" +--------------------------------------------------------------------------+ "
" |                                FUNCTIONS                                 | "
" +--------------------------------------------------------------------------+ "

" Execute a command in GHCi after asking the user for a parameter.  The first
" argument of this function is the text that is displayed to the user.
function! HaskellGHCIDo(text, cmd)
    let l:fun = input(a:text)
    call feedkeys(':SlimeSend1 ' . a:cmd . ' ' . l:fun . '', 'n')
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

" Import a haskell module qualified, automatically generating an abbreviation
" for it.
function! HaskellImportQualified()
    let @x = input( 'Module: ', '' )
    let l:mlen = strlen(@x)
    let l:i = l:mlen - 1
    while (l:i >= 0) && (@x[l:i] != '.')
        let l:i -= 1
    endwhile
    let @y = @x[l:i + 1]
    call feedkeys('iimport qualified x as y', 'n')
endfunction

" Replaces the selected text with a new local variable and puts it to the
" enclosing functions "where" clause.
function! HaskellExtractVar()
    normal gv"yy
    normal mt
    let @x = input( 'Variable name: ' )
    call feedkeys( 'vip:s/y/x/g', 'n' )
    call feedkeys( "'>occ  where  x = y`t:noh", 'n' )
endfunction
