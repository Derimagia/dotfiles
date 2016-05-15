" Load vim-plug
if empty(glob("~/.vim/autoload/plug.vim"))
    execute 'mkdir -p ~/.vim/plugged'
    execute 'mkdir -p ~/.vim/autoload'
    execute '!curl -fLo ~/.vim/autoload/plug.vim https://raw.github.com/junegunn/vim-plug/master/plug.vim'
endif

" Plugins -------------------------------------------------------------

call plug#begin('~/.vim/plugged')


Plug 'mhartington/oceanic-next'
Plug 'bling/vim-airline'
Plug 'scrooloose/nerdtree'
Plug 'junegunn/fzf.vim'
Plugin 'othree/yajs.vim'

call plug#end()

syntax on

let base16colorspace=256
set background=dark
set t_Co=256
colorscheme OceanicNext

set nobackup            " don't create pointless backup files; Use VCS instead
set cursorline          " highlight the current line
set autoread            " watch or file changes
set number              " line numbers
set showcmd             " selection metadata
set showmode            " show INSERT, VISUAL, etc. mode
set showmatch           " show matching brackets
set autoindent smartindent  " auto/smart indent
set smarttab            " better backspace and tab functionality
set scrolloff=5         " show at least 5 lines above/below
filetype on             " enable filetype detection
filetype indent on      " enable filetype-specific indenting
filetype plugin on      " enable filetype-specific plugins

" FZF
set rtp+=/usr/local/opt/fzf/

" bells
set noerrorbells
set visualbell

" search
set hlsearch            " highlighted search results
set showmatch           " show matching bracket

" mouse with iterm2
set ttyfast
set mouse=a
set ttymouse=xterm2


" clipboard
set clipboard=unnamed   " allow yy, etc. to interact with OS X clipboard

" Keys
map <C-n> :NERDTreeToggle<CR>
command! -nargs=1 Locate call fzf#run(
      \ {'source': 'locate <q-args>', 'sink': 'e', 'options': '-m'})

noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

if filereadable(glob("~/.vimrc.local"))
    source ~/.vimrc.local
endif
