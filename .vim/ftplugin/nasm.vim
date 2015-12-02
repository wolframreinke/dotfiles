set tw=78

call SetTabstop(4)

setlocal commentstring=;\ %s

inoremap <buffer> ;---<CR> <ESC>o<ESC>I;<ESC>77a-<ESC>a<ESC>ddkpp:set tw=78<CR>O
inoremap <buffer> ;--<CR> <ESC>o<ESC>I<ESC>8a <ESC>a;<ESC>59a-<ESC>a<ESC>ddkpp:set tw=68<CR>O 

inoremap <buffer> %macro  %macro<CR>%endmacro<ESC>kA 
inoremap <buffer> :<CR> :<CR><TAB>

inoremap <buffer> .text    <ESC>o<ESC>I;<ESC>77a-<ESC>a<ESC>ddkppO Section
                          \ TEXT<ESC>jo<BACKSPACE>SECTION .text
inoremap <buffer> .data    <ESC>o<ESC>I;<ESC>77a-<ESC>a<ESC>ddkppO Section
                          \ DATA<ESC>jo<BACKSPACE>SECTION .data
inoremap <buffer> .bss     <ESC>o<ESC>I;<ESC>77a-<ESC>a<ESC>ddkppO Section
                          \ BSS<ESC>jo<BACKSPACE>SECTION .bss
inoremap <buffer> .rodata  <ESC>o<ESC>I;<ESC>77a-<ESC>a<ESC>ddkppO Section
                          \ RODATA<ESC>jo<BACKSPACE>SECTION .rodata

setlocal comments=:;
setlocal fo+=ro
