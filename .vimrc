if has("clipboard")
    set clipboard=unnamed
endif

call plug#begin('~/.vim/plugged')
Plug 'w0rp/ale'                                                         " Asynchronous Linter Engine
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }       " acts like ctrlp, but even better
Plug 'junegunn/fzf.vim'                                                 " 
Plug 'flazz/vim-colorschemes'                                           " vim color scheme plugin
Plug 'airblade/vim-gitgutter'                                           " git gutter
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'davidhalter/jedi-vim'                                             " vim auto completion
Plug 'Shougo/neocomplete.vim'
Plug 'cohama/lexima.vim'
Plug 'ervandew/supertab'
Plug 'scrooloose/nerdtree'
Plug 'jistr/vim-nerdtree-tabs'
Plug 'ryanoasis/vim-devicons'
Plug 'terryma/vim-multiple-cursors'                                     " multi-selection for vim
Plug 'farmergreg/vim-lastplace'
Plug 'alvan/vim-closetag'
Plug 'hdima/python-syntax'
Plug 'Vimjas/vim-python-pep8-indent'
Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
call plug#end()

" ALE
let g:ale_sign_column_always = 1
let g:ale_lint_delay = 600

" vim-airline
set autoread
set laststatus=2                                        " let airline appear all the time
let g:airline_powerline_fonts = 1                       " use poewrline-fonts
let g:airline_theme = 'cool'
let g:airline#extensions#tabline#enabled = 1            " Smarter tab line (https://github.com/vim-airline/vim-airline#smarter-tab-line)
let g:airline#extensions#whitespace#enabled = 1

" vim-devicons
set guifont=Droid\ Sans\ Mono\ for\ Powerline\ Nerd\ Font\ Complete\ 12

set encoding=utf-8                                      " The encoding displayed
set fileencoding=utf-8                                  " The encoding written to file

" NERDTree
" let NERDTreeWinSize=20

" NERDTree-tabs
let g:nerdtree_tabs_open_on_console_startup=2
let g:nerdtree_tabs_smart_startup_focus=2
let g:nerdtree_tabs_focus_on_files=1

" jedi-vim
autocmd FileType python setlocal completeopt-=preview

" lexima.vim causes <CR> to insert newline when insert completion popup menu
" https://github.com/cohama/lexima.vim/issues/65#issuecomment-258680294
let g:lexima_no_default_rules = 1
silent! call lexima#set_default_rules()
silent! call lexima#insmode#map_hook('before', '<CR>', '')

" neocomplete
let g:neocomplete#enable_at_startup = 1
let g:neocomplete#enable_smart_case = 1
let g:neocomplete#sources#syntax#min_keyword_length = 3
let g:neocomplete#enable_auto_select = 1
inoremap <expr><CR> pumvisible()? "\<C-y>" : "\<CR>"

" better backup, swap and undos storage (taken from fisa-vim-config)
set directory=~/.vim/dirs/tmp     " directory to place swap files in
set backup                        " make backup files
set backupdir=~/.vim/dirs/backups " where to put backup files
set undofile                      " persistent undos - undo after you re-open the file
set undodir=~/.vim/dirs/undos
set viminfo+=n~/.vim/dirs/viminfo

syntax on

set nocompatible
set number
set hlsearch
set incsearch                                           " incremental search
set backspace=indent,eol,start
set mouse+=a
set t_Co=256                                            " enable 256 colors in vim (if not set, vim-airline-theme might not show correctly)
au BufNewFile,BufRead *.py,*.go,*.proto set tabstop=4 softtabstop=4 shiftwidth=4 expandtab smarttab autoindent
au BufNewFile,BufRead *.html,*.js,*.json,*.yml,*yaml,*.toml,*.conf set tabstop=2 softtabstop=2 shiftwidth=2 expandtab smarttab autoindent
set cursorline                                          " highlight the whole current line

set background=dark
silent! colorscheme scheakur  

highlight ColorColumn ctermbg=235 guibg=#2c2d27
highlight CursorLine cterm=NONE ctermbg=darkblue ctermfg=white guibg=darkblue ctermfg=white

augroup python
    autocmd FileType python let &colorcolumn="80,".join(range(81,999),",")
augroup END

nmap <silent> <leader>t :NERDTreeTabsToggle<CR>
nnoremap <c-p> :FZF<cr>

let python_highlight_all = 1

" let g:ale_echo_msg_error_str = 'E'
" let g:ale_echo_msg_warning_str = 'W'
" let g:ale_echo_msg_format = '[%linter%] %s [%severity%]'
" let g:ale_set_loclist = 0
" let g:ale_set_quickfix = 1
let g:ale_open_list = 1
let g:ale_list_window_size = 5
" let g:ale_keep_list_window_open = 1

" resolve conflict between neocomplete and multi-cusor-select
" https://github.com/terryma/vim-multiple-cursors/issues/51#issuecomment-32344711
function! Multiple_cursors_before()
    exe 'NeoCompleteLock'
    echo 'Disabled autocomplete'
endfunction

function! Multiple_cursors_after()
    exe 'NeoCompleteUnlock'
    echo 'Enabled autocomplete'
endfunction

" navigate between errors quickly
nmap <silent> <C-k> <Plug>(ale_previous_wrap)
nmap <silent> <C-j> <Plug>(ale_next_wrap)
