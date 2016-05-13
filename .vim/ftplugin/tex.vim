setlocal tw=80

call SetTabstop(2)

setlocal indentexpr=
setlocal cole=0
setlocal spell
setlocal spelllang=de
setlocal iskeyword+=:
setlocal formatoptions+=tcroqn

inoremap <buffer> <leader>"     ``'' «rest»<C-o>T`
inoremap <buffer> <leader>sec   \section{}<C-o>T{
inoremap <buffer> <leader>ssec  \subsection{}<C-o>T{
inoremap <buffer> <leader>sssec \subsubsection{}<C-o>T{
inoremap <buffer> <leader>para  \paragraph{}<C-o>T{
inoremap <buffer> <leader>emp   \emph{} «rest»<C-o>T{
inoremap <buffer> <leader><     \<> «rest»<C-o>2T<
inoremap <buffer> <leader>begin \begin{}<CR>\end{«rest»}<Up><C-o>T{

nnoremap <buffer> <leader>c     mtI% <ESC>`t
vnoremap <buffer> <leader>c     <C-V>0I% <ESC>

let NERDTreeIgnore = [ '\.acn$' , '\.acr$' , '\.alg$' , '\.aux$' , '\.glg$'
                   \ , '\.glo$' , '\.gls$' , '\.ist$' , '\.lof$' , '\.log$'
                   \ , '\.lol$' , '\.lot$' , '\.out$' , '\.toc$' , '\.blg$'
                   \ , '\.bbl$' ]
