setlocal tw=80
setlocal shiftwidth=4
setlocal tabstop=4
setlocal softtabstop=4
setlocal expandtab

inoremap <buffer> %--<CR> <ESC>o<ESC>cc% <ESC>77a-<ESC>yyp<CR>O

nnoremap <buffer> <C-%> :s/^/% /g<CR>

setlocal keywordprg=matlabman
setlocal formatoptions+=croql
setlocal comments=:%>,:%

" Autocompletion!!!
" class definitions
inoremap <buffer> <leader>cl 
                \classdef <C-R>=expand("%:t:r")<CR><CR><CR><C-o>mt<CR>end<ESC>
                \`ta<Tab>

" a methods block inside a class definition
inoremap <buffer> <leader>ms 
                \methods (<C-o>mt)<CR><CR><Tab>«methods»<CR>end<ESC>`ta

" a properties block inside a class definition
inoremap <buffer> <leader>pr 
                \properties (<C-o>mt)<CR><CR><Tab>«properties»<CR>end
                \<ESC>`ta

" a method, that is, a function within a methods block of a class
inoremap <buffer> <leader>me 
                \function [«results»] = <C-o>mt( self, «parameters» )
                \<CR><CR><Tab>«body»<CR>end<ESC>`ta

" a constructor -- a special method that returns self
inoremap <buffer> <leader>co 
                \function self = <C-R>=expand("%:t:r")<CR>( <C-o>mt )<CR><CR>
                \<Tab>«body»<CR>end<ESC>`ta

" a stand-alone function outside a class
inoremap <buffer> <leader>fn 
                \function [«results»] = <C-o>mt( «parameters» )<CR><CR>
                \<Tab>«body»<CR>end<ESC>`ta

" a for loop
inoremap <buffer> <leader>fo 
                \for <C-o>mt = «range»<CR><CR>«body»<CR>end<ESC>`ta

" a while loop
inoremap <buffer> <leader>wh 
                \while <C-o>mt<CR><CR>«body»<CR>end<ESC>`ta

" an if condition
inoremap <buffer> <leader>if 
                \if <C-o>mt<CR>«body»<CR>end<ESC>`ta

" another if conition, but with else branch
inoremap <buffer> <leader>ie 
                \if <C-o>mt<CR>«when_true»<CR>else<CR>«when_false»<CR>  
                \end<ESC>`ta

ia pub public
ia pri private
ia pro protected
ia fn function
ia wh while
ia cl classdef
ia ab Abstract
ia acc Access =
ia gacc GetAccess =
ia sacc SetAccess =


nnoremap <leader>re viW:call MatlabExtractVar()<CR>
vnoremap <leader>re :call MatlabExtractVar()<CR>
function! MatlabExtractVar()
    normal gv"yy
    normal mt
    let @x = input( 'Variable name: ' )
    "normal "xP
    execute 'silent :%s/' . @y . '/' . @x . '/g'
    call feedkeys("'tOx = y;", 'n')
endfunction

nnoremap <leader>ri :call MatlabInlineVar()<CR>
function! MatlabInlineVar()
    normal _viw"xxdt=dw"ydt;dd
    execute 'silent :g!/' . @x . '\s\+=[^=]/s/[^a-zA-Z0-9_]'
                        \ . @x . '[^a-zA-Z0-9_]/'
                        \ . @y . '/g'
endfunction


if exists("b:did_ftplugin")
  finish
endif
let b:did_ftplugin = 1

let s:save_cpo = &cpo
set cpo-=C


if exists("loaded_matchit")
  let s:conditionalEnd = '\([-+{\*\:(\/]\s*\)\@<!\<end\>\(\s*[-+}\:\*\/)]\)\@!'
  let b:match_words = '\<classdef\>\|\<methods\>\|\<events\>\|\<properties\>\|\<if\>\|\<while\>\|\<for\>\|\<switch\>\|\<try\>\|\<function\>:' . s:conditionalEnd
endif

setlocal suffixesadd=.m
setlocal suffixes+=.asv

let b:undo_ftplugin = "setlocal suffixesadd< suffixes< "
      \ . "| unlet! b:browsefilter"
      \ . "| unlet! b:match_words"

let &cpo = s:save_cpo
