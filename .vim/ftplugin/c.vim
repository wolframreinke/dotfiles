setlocal tw=80
setlocal tw=80
setlocal shiftwidth=4
setlocal tabstop=4
setlocal softtabstop=4
setlocal expandtab


setlocal formatoptions=tcroqalnMj

" Scoped rename
nnoremap <buffer> <leader>rR    *NviBVokk:s///g<Left><Left>

" Autocompletion!!!
inoremap <buffer> <leader>in    #include <<C-o>mt><C-o>`t<right>
inoremap <buffer> <leader>fn    «type\|int» (<C-o>mt«params»)<CR>{<CR>
                               \«body»<CR>}<C-o>`t
inoremap <buffer> <leader>fd    «type\|int» (<C-o>mt«params»);<C-o>`t
inoremap <buffer> <leader>st    struct  <C-o>mt{<CR>«decls»<CR>};<C-o>`t<C-o>x
inoremap <buffer> <leader>un    union  <C-o>mt{<CR>«decls»<CR>};<C-o>`t<C-o>x
inoremap <buffer> <leader>en    enum  <C-o>mt{<CR>«decls»<CR>};<C-o>`t<C-o>x
inoremap <buffer> <leader>sd    typedef struct {<CR>«decls»<CR>} ;<Left>
inoremap <buffer> <leader>ud    typedef union {<CR>«decls»<CR>} ;<Left>
inoremap <buffer> <leader>ed    typedef enum {<CR>«decls»<CR>} ;<Left>
inoremap <buffer> <leader>td    typedef «original_type» ;<Left>
inoremap <buffer> <leader>ma    int main(int argc, char *argv[])<CR>{<CR><
                               \C-o>mt<CR>}<C-o>'t
inoremap <buffer> <leader>if    if ()<C-o>mt {<CR><CR>«body»<CR>}<C-o>`t
inoremap <buffer> <leader>ie    if ()<C-o>mt {<CR><CR>«when-true»<CR>} else {
                               \<CR><CR>«when-false»<CR>}<C-o>`t
inoremap <buffer> <leader>wh    while ()<C-o>mt {<CR><CR>«body»<CR>}<C-o>`t
inoremap <buffer> <leader>for   <C-o>:call CForLoop()<CR>
inoremap <buffer> <leader>fod   <C-o>:call CForLoopDown()<CR>
inoremap <buffer> <leader>do    do {<CR>«body»<CR>} while ()<C-o>mt;<C-o>`t
inoremap <buffer> <leader>sw    switch ()<C-o>mt {<CR>«choice»<CR>}<C-o>`t
inoremap <buffer> <leader>ca    case :<C-o>mt<CR>«body»;<CR>break;<C-o>`t

nnoremap <buffer> <leader>re viW:call CExtractVar()<CR>
vnoremap <buffer> <leader>re :call CExtractVar()<CR>

vnoremap <buffer> <leader>wh    <ESC>:call CEmbed( 'while («») {', '}' )<CR>
vnoremap <buffer> <leader>do    <ESC>:call CEmbed( 'do {', '} while («»);' )<CR>
vnoremap <buffer> <leader>if    <ESC>:call CEmbed( 'if («») {', '}' )<CR>
vnoremap <buffer> <leader>ie    <ESC>:call CEmbed( 'if («») {',
                               \'} else {«else»}' )<CR>


function! CForLoop()
    let @x = input( 'Iterator: ', 'i' )
    call feedkeys('for (int x = 0; x < ;mt x++) {«body»}`t', 'i')
endfunction

function! CForLoopDown()
    let @x = input( 'Iterator: ', 'i' )
    call feedkeys('for (int x = ;mt x >= 0; x--) {«body»}`t', 'i')
endfunction

function! CExtractVar()
    normal gv"yy
    normal mt
    let @x = input( 'Variable name: ' )
    call feedkeys("viBVokk:s/" . @y ."/" . @x . "/g't" ,'n')
    call feedkeys("O«type\|int» x = y;", 'n')
endfunction

function! CEmbed( before, after )
    let @x = a:before
    let @y = a:after
    call feedkeys( ":'>oy:'<OxhviB=", 'n' )
    call feedkeys( '/«»cf»', 'N' )
endfunction
