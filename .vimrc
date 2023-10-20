set number
set relativenumber

syntax enable
filetype plugin on
set showcmd
set nocompatible

set path+=**
set wildmenu

let mapleader = "\<Space>"
inoremap kj <Esc>
cnoremap kj <Esc><Esc>
vnoremap kj <Esc><Esc>

vnoremap > >gv
vnoremap < <gv
vnoremap <TAB> >gv
vnoremap <S-TAB> <gv

" by default gt => :tabnext and gT => :tabprev
nnoremap <leader>tn :tabnew<Space>
nnoremap <leader>tk :tabnext<CR>
nnoremap <leader>tj :tabprev<CR>
nnoremap <leader>th :tabfirst<CR>
nnoremap <leader>tl :tablast<CR>

" Configuring file browsing plugin (it comes built in)
let g:netrw_dirhistmax = 3
let g:netrw_banner  = 0
let g:netrw_browse_split  = 4
let g:netrw_altv  = 1
let g:netrw_liststyle  = 3

set expandtab
set shiftwidth=4
set autoindent
set smartindent

set ignorecase
set incsearch
set smartcase

set nobackup
set nowritebackup
set noswapfile
set noundofile

set scrolloff=8
set signcolumn=yes
set colorcolumn=80
set cmdheight=2

set visualbell
set t_vb=

hi Normal guibg=NONE ctermbg=NONE
autocmd vimenter * hi Normal guibg=NONE ctermbg=NONE
autocmd vimenter * hi EndOfBuffer guibg=NONE ctermbg=NONE

