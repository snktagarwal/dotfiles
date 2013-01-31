source /usr/share/vim/google/google.vim
inoremap jj <esc>
set incsearch
set hlsearch
set number

" perforce commands
command! -nargs=* -complete=file PEdit :!g4 edit %
command! -nargs=* -complete=file PRevert :!g4 revert %
command! -nargs=* -complete=file PDiff :!g4 diff %

function! s:CheckOutFile()
 if filereadable(expand("%")) && ! filewritable(expand("%"))
   let s:pos = getpos('.')
   let option = confirm("Readonly file, do you want to checkout from p4?"
         \, "&Yes\n&No", 1, "Question")
   if option == 1
     PEdit
   endif
   edit!
   call cursor(s:pos[1:3])
 endif
endfunction
au FileChangedRO * nested :call <SID>CheckOutFile()

" Enable pathogen
call pathogen#infect()
syntax on
filetype plugin indent on
set colorcolumn=80
set clipboard^=unnamed

" Set window control prefix to tmux prefix
map <C-A> <C-W>

" Install NERDTree

" Display the name of the file always.
set modeline
set ls=2
