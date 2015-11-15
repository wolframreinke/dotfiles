set tw=78

inoremap <buffer> ;---<CR> <ESC>o<ESC>I;<ESC>77a-<ESC>a<ESC>ddkpp:set tw=78<CR>O
inoremap <buffer> ;--<CR> <ESC>o<ESC>I<ESC>8a <ESC>a;<ESC>59a-<ESC>a<ESC>ddkpp:set tw=68<CR>O 

inoremap <buffer> %macro<NUL> %macro<CR>%endmacro<ESC>kA 
inoremap <buffer> :<CR> :<CR><TAB>

vnoremap <buffer> ; :s/^/; /g<CR>
vnoremap <buffer> ;; :s/^; //g<CR>

inoremap <buffer> .text<NUL> <ESC>o<ESC>I;<ESC>77a-<ESC>a<ESC>ddkppO; Section TEXT<ESC>joSECTION .text
inoremap <buffer> .data<NUL> <ESC>o<ESC>I;<ESC>77a-<ESC>a<ESC>ddkppO; Section DATA<ESC>joSECTION .data
inoremap <buffer> .bss<NUL> <ESC>o<ESC>I;<ESC>77a-<ESC>a<ESC>ddkppO; Section BSS<ESC>joSECTION .bss
inoremap <buffer> .rodata<NUL> <ESC>o<ESC>I;<ESC>77a-<ESC>a<ESC>ddkppO; Section RODATA<ESC>joSECTION .rodata

setlocal comments=:;
setlocal fo+=ro
