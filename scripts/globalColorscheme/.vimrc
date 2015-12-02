execute pathogen#infect()

" \---------------------------------------------------------------------------/
"  +============================== BEHAVIOUR ================================+
" /---------------------------------------------------------------------------\

" Who uses , anyway?
let mapleader = ","

set autoindent    " use automatic indentation
set expandtab     " convert tabs to spaces
set hidden        " switch between unsaved buffers
set hlsearch      " highlight search results.  Temporarily disabled with :noh
set incsearch     " inremental search
set lazyredraw    " no redrawing while executing macros (speed++)
set list          " show spaces, tabs and continuations
set nocompatible  " more powerful options
set nostartofline " Cursor column is constant when moving up and down
set nowrap        " do not wrap lines
set showcmd       " partial commands in the last line of the screen
set smarttab      " i dunno, but it's good
set title         " sets the title of the terminal
set ttyfast       " assumes a fast terminal and sends more chars for redrawing
set wildmenu      " insert best guess for Tab-completion
set exrc          " Source local .vimrc files
set secure        " Only source .vimrc files owned by me

" [TAB]-Completion in ex-command line.  Completes the longest common part of
" all matches and displays all potential matches.  Pressing [TAB] again
" cycles through this list.
set wildmode=list:longest,full

" I've enabled the mouse in tmux, so I can just as well enable it here...
set mouse=a

set scrolloff=8
set sidescrolloff=8
set sidescroll=1

set listchars=tab:»·,trail:·,extends:#,nbsp:·

set backspace=indent,eol,start

" Custom thesaurus and dictionary
set thesaurus+=~/.vim/thesaurus.txt
set dictionary+=/usr/share/dict/words

" Makes the undo history persistent
set undodir=~/.vim/undo
set undofile
set undolevels=1000
set undoreload=10000

function! SetTabstop( n )
    let &l:tabstop     = a:n
    let &l:softtabstop = a:n
    let &l:shiftwidth  = a:n
endfunction

autocmd BufRead,BufNewFile *.hsi set filetype=haskell
autocmd BufRead,BufNewFile *.bf set filetype=brainfuck

" \---------------------------------------------------------------------------/
"  +============================= APPEARENCE ================================+
" /---------------------------------------------------------------------------\

syntax on


" Doesn't work either
" highlight OverLength ctermfg=darkred guibg=#FF0000
" match     OverLength /\%81v.\+/

if system('echo -n $TERM') != 'linux'

    " Cursor line and column in insert mode
    set nocursorcolumn
    autocmd InsertEnter * set cursorline
    autocmd InsertEnter * set cursorcolumn
    autocmd InsertLeave * set nocursorline
    autocmd InsertLeave * set nocursorcolumn

    set background=dark
    colorscheme solarized

    let &colorcolumn=join(range(81,300),",")

    " Highlights jumpmarks to make them more visible
    " Doesn't work for obsucure reasons...
    highlight JumpMarks guibg=lightgreen ctermfg=grey
    match     JumpMarks /«[^»]*»/

else
    set background=dark
    colorscheme desert
endif



" Nice statusline, stolen from the internet.
set statusline=
set statusline+=\ #%n\      "buffer number
set statusline+=%{&ff}      "file format
set statusline+=%y          "file type
set statusline+=\ %<%F      "full path
set statusline+=%m          "modified flag
set statusline+=%=%5l       "current line
set statusline+=/%L         "total lines
set statusline+=%4v\        "virtual column number
set statusline+=0x%04B\     "character under cursor
set laststatus=2

" enable relative line numbering
set number
set relativenumber


" \---------------------------------------------------------------------------/
"  +=================== KEY MAPPINGS AND ABBREVIATIONS ======================+
" /---------------------------------------------------------------------------\

nnoremap <SPACE>        i_<ESC>r
nnoremap <C-s>          :w<CR>
nnoremap <C-q>          <ESC>
nnoremap S              :w<CR>
nnoremap 
nnoremap <leader>bn     :bnext<CR>
nnoremap <leader>bp     :bprevious<CR>
nnoremap <F8>           :!make<CR>
nnoremap n              nzz
nnoremap N              Nzz
nnoremap <leader>rr     #:%s///g<Left><Left>
nnoremap <leader>t      :Tabularize /=<CR>

" Makes working with soft wraps easier
nnoremap j              gj
nnoremap k              gk
vnoremap j              gj
vnoremap k              gk

inoremap <C-s>          <ESC>:w<CR>
inoremap <F8>           :!make<CR>i

" Here we have a glimmer of EMACS mindset
inoremap <C-n>          <Down>
inoremap <C-p>          <Up>
inoremap <C-f>          <Right>
inoremap <C-b>          <Left>
inoremap <C-h>          <C-o>x
inoremap <C-a>          <ESC>I
inoremap <C-e>          <ESC>A

" SWAP COMMANDS
" gss swaps two characters
" gsw swaps two w words
" gsW swaps two W words
" gsd swaps two w words separated by some non-word delimiter
" gsp swaps (short) function arguments --> f(a, b) => f(b, a)
nnoremap gss            xph
nnoremap gsw            wdwbP
nnoremap gsW            WdWBP
nnoremap gsd            i <ESC>ldwpldeBPbX
nnoremap gsp            i <ESC>ldwlplde2BPbX

" creates a column of increasing numbers
" Implemented as a macro to make it repeatable
let @i = 'yiwjviwp'

" overriding text with contents of the " register does not change it.
vnoremap p              pgvy

" Limited, but useful form of general-purpose auto-completion.
" Filetype-specific scripts can define mappings that insert words, enclosed in «
" and » to declare jump marks.  By pressing <leader>mn and <leader>mp in input
" or normal mode, the user can navigate to them quickly.  Pressing <leader>md
" replaces all jump marks with their respective default values.
inoremap <leader>mn     <C-]><ESC>/«[^»]*»<CR>cf»
inoremap <leader>mp     <C-]><ESC>?«[^»]*»<CR>cf»
inoremap <leader>md     <C-]><ESC>mt:%s/«[^\|]*\|\([^»]*\)»/\1/g<CR>`ti
inoremap <leader>mm     <C-]>«tmp»
nnoremap <leader>mn     /«[^»]*»<CR>cf»
nnoremap <leader>mp     ?«[^»]*»<CR>cf»
nnoremap <leader>md     mt:%s/«[^\|]*\|\([^»]*\)»/\1/g<CR>`ti
nnoremap <leader>mm     i«tmp»<ESC>

" Inserts a todo message with the text
" Wolfram (08-03-15): <cursor>
inoremap <leader>todo   TODO Wolfram (<ESC>:r!date +\%m-\%d-\%y<CR>kJxA):<Space>
inoremap <leader>xxx    XXX Wolfram (<ESC>:r!date +\%m-\%d-\%y<CR>kJxA):<Space>
inoremap <leader>fixme  FIXME Wolfram (<ESC>:r!date +\%m-\%d-\%y<CR>kJxA):<Space>

" Ctrl-C == Escape
inoremap <C-C> <ESC>

" Spelling corrections. More to come...
iab teh the
iab Teh The

" accepts typical typos
cnoreabbrev W w
cnoreabbrev Wq wq
cnoreabbrev Q q
cnoreabbrev Qa qa
cnoreabbrev Wqa wqa

" Echos the <message> and prompts for user input.  The response is written to
" register @x
function! ReadToX(message, default)
    let @x = input(a:message, a:default)
endfunction

" \---------------------------------------------------------------------------/
"  +============================== PLUG-INS =================================+
" /---------------------------------------------------------------------------\

" Loads plugins for vim
filetype plugin on
filetype indent on

au BufRead,BufNewFile *.asm set filetype=nasm

" ------------------------------- SYNTASTIC ---------------------------------- "
" Syntastic slows down vim considerably.  It avoid this, its disabled by default
" here.
let g:syntastic_mode_map = { 'mode': 'passive'
                         \ , 'active_filetypes': []
                         \ ,'passive_filetypes': [] }
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list            = 0
let g:syntastic_check_on_open            = 1
let g:syntastic_check_on_wq              = 0
let g:syntastic_asm_checkers             = ['nasm']
let g:syntastic_cpp_compiler             = 'g++'
let g:syntastic_cpp_compiler_options     = ' -std=c++11 -stdlib=libc++'
let g:syntastic_disabled_filetypes       = ['haskell']
nnoremap <C-w>E :SyntasticCheck<CR> :SyntasticToggleMode<CR>

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

" ------------------------------- NERD TREE ---------------------------------- "
" ASCII only
let g:NERDTreeDirArrows = 0

" -------------------------------- TAGBAR ------------------------------------ "
nnoremap <leader>=       :TagbarToggle<CR>
let g:tagbar_autoclose    = 1

" --------------------------------- SLIME ------------------------------------ "
let g:slime_target = "tmux"

" ----------------------------- MULTIPLE CURSORS ----------------------------- "
let g:multi_cursor_next_key = '<C-n>'
let g:multi_cursor_prev_key = '<C-p>'
let g:multi_cursor_skip_key = '<C-x>'
let g:multi_cursor_quit_key = '<ESC>'
let g:multi_cursor_exit_from_insert_mode = 1


" ---------------------------- VIM-TMUX-NAVIGATOR ---------------------------- "
let g:tmux_navigator_no_mappings = 1

nnoremap <silent> <C-q>h :TmuxNavigateLeft<CR>
nnoremap <silent> <C-q>j :TmuxNavigateDown<CR>
nnoremap <silent> <C-q>k :TmuxNavigateUp<CR>
nnoremap <silent> <C-q>l :TmuxNavigateRight<CR>
"nnoremap <silent> <C-q>\ :TmuxNavigatePrevious<CR>

" --------------------------------- RAINBOW ---------------------------------- "
let g:rainbow_active = 0