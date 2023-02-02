""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" => Language
""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Language options
" language messages en

" if (has('win32') || has('win64')) && has('gui_running')
"  set encoding=cp1251 nobomb
"  set termencoding=cp1251
"  set guifont=Consolas:h12
" else
scriptencoding utf-8
set encoding=utf-8 nobomb
set termencoding=utf-8
" endif

set fileencoding=utf-8

set langmenu=en_US
let $LANG = 'en_US'
source $VIMRUNTIME/delmenu.vim
source $VIMRUNTIME/menu.vim
