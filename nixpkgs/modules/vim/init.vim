filetype plugin indent on
syntax on

let mapleader=","

set ts=4
set sw=4
set softtabstop=4
set expandtab

set copyindent
set smartindent

set formatoptions+=t
set hlsearch
set incsearch
set lazyredraw
set nofoldenable
set nu
set showcmd
set splitbelow
set splitright
set wildmenu
set wildmode=longest,list
set noshowmode
set hidden
set ignorecase
set smartcase

" Backup/persistance settings
set undodir=~/.cache/nvim/undo//
set backupdir=~/.cache/nvim/backup//
set directory=~/.cache/nvim/swap//
set backupskip=/tmp/*
set backup
set writebackup
set noswapfile

" Use system clipboard
set clipboard=unnamed

" Persist (g)undo tree between sessions
set undofile
set history=4096
set undolevels=4096

set colorcolumn=100
highlight ColorColumn ctermbg=darkgray

set scrolloff=10

" Keep search results at the center of the screen
nmap n nzz
nmap N Nzz
nmap * *zz
nmap # #zz
nmap g* g*zz
nmap g# g#zz

" show trailing whitespaces
set list
set listchars=tab:▸\ ,trail:¬,nbsp:.,extends:❯,precedes:❮
augroup ListChars2
  au!
  autocmd filetype go set listchars+=tab:\ \ 
  autocmd ColorScheme * hi! link SpecialKey Normal
augroup END

nnoremap j gj
nnoremap k gk

nnoremap <Leader>e :bn<CR>
nnoremap <Leader>q :bp<CR>
nnoremap <Leader>bd :silent! bp<bar>sp<bar>silent! bn<bar>bd<CR>
nnoremap <Leader>w :w<CR>

nnoremap <Leader><space> :nohlsearch<CR>