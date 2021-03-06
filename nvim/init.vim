set t_Co=256
set background=dark
set encoding=utf8
set rnu                   " relative numbers on by default"
set showmatch
set scrolloff=5
set mouse=a
set grepprg="rg --vimgrep"
set magic                 " Use 'magic' patterns (extended regular expressions).
set gdefault              " Use 'g' flag by default with :s/foo/bar/.
set smartcase
set noerrorbells
set nojoinspaces
set expandtab
set tabstop=2

call plug#begin("$XDG_DATA_HOME/nvim/plugged")
" --- Library
Plug 'Shougo/vimproc.vim', {'do' : 'make'} " unite
Plug 'MarcWeber/vim-addon-mw-utils' " vim-snipmate
Plug 'tomtom/tlib_vim' " vim-snipmate

" --- Productivity, Files
Plug 'mhinz/vim-startify'
Plug 'scrooloose/nerdtree'
Plug 'ctrlpvim/ctrlp.vim'
Plug 'tpope/vim-sleuth'
Plug 'dahu/SearchParty'
Plug 'terryma/vim-multiple-cursors'

" --- Status Line
Plug 'bling/vim-airline'
Plug 'bling/vim-bufferline'
Plug 'vim-airline/vim-airline-themes'

" --- General Theme / Coloring
Plug 'mhartington/oceanic-next'
Plug 'ryanoasis/vim-devicons' " Needs to be after nerdtree
Plug 'ap/vim-css-color'

" --- Git
Plug 'airblade/vim-gitgutter'
Plug 'tpope/vim-fugitive'
Plug 'Xuyuanp/nerdtree-git-plugin'

" --- Autocomplete
Plug 'Shougo/unite.vim'
Plug 'Shougo/deoplete.nvim'

" --- Languages
Plug 'w0rp/ale'
Plug 'sheerun/vim-polyglot'
call plug#end()

" Keys
let mapleader = "\<Space>"
nnoremap <leader>ev :edit $MYVIMRC<cr>
nnoremap <leader>sv :source $MYVIMRC<cr>
nnoremap <Tab> :bnext<CR>
nnoremap <S-Tab> :bprevious<CR>
nnoremap <Leader>c :set hlsearch!<CR>
nnoremap <Leader>w :w<CR>

" Search and Replace
nmap <Leader>s :%s//g<Left><Left>

" Relative numbering
function! NumberToggle()
  if(&relativenumber == 1)
	set nornu
	set number
  else
	set rnu
  endif
endfunc

" Toggle between normal and relative numbering.
nnoremap <leader>r :call NumberToggle()<cr>

" Mapping - Clipboard
set clipboard+=unnamedplus
vmap <C-c> "+yi
colorscheme OceanicNext

" CtrlP Settings
let g:ctrlp_show_hidden = 1
let g:ctrlp_custom_ignore = '\v[\/]\.(git|hg|svn|idea|DS_Store)$'

nnoremap <Leader>o :CtrlP<CR>
nnoremap <Leader>b :CtrlPBuffer<CR>
nnoremap <Leader>f :CtrlPMRUFiles<CR>

" AirLine
let g:airline_powerline_fonts = 1
let g:airline_theme = 'base16'

" Startify
let g:startify_session_dir="$XDG_CONFIG_HOME/nvim/sessions"

" Deoplete.
let g:deoplete#enable_at_startup = 1

" NerdTree
nmap <silent> <F3> :NERDTreeToggle<CR>
let g:NERDTreeShowHidden = 0
let g:NERDTreeIgnore = ['\.pyc$', '\.DS_Store$']

" ale settings
let g:ale_lint_on_save = 1
let g:ale_lint_on_text_changed = 0
let g:ale_lint_on_enter = 0
" fix cursor on exit
if has("autocmd")
	au VimLeave * set guicursor=a:ver25-blinkon1-blinkoff1
endif
