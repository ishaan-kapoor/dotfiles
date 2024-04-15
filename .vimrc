set number
set relativenumber
set nowrap

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

nnoremap <leader>o o<Esc>
nnoremap <leader>O O<Esc>
vnoremap <leader>srt :sort<CR>

nnoremap gh 0
nnoremap gl $
nnoremap gH g0
nnoremap gL g$
vnoremap gh 0
vnoremap gl $
vnoremap gH g0
vnoremap gL g$

vnoremap > >gv
vnoremap < <gv
vnoremap <TAB> >gv
vnoremap <S-TAB> <gv

" Move lines up and down
vnoremap J :m '>+1<CR>gv=gv 
vnoremap K :m '<-2<CR>gv=gv 

" Page UP/Down and center page
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz
" Go to prev/next match and center page
nnoremap n nzzzv
nnoremap N Nzzzv

" Copy to clipboard
vnoremap <leader>y :w !clip.exe<CR><CR>
nnoremap <leader>yy V:w !clip.exe<CR><CR>

" Delete single char without yanking
nnoremap x "_x
" Paste over selected text
xnoremap p "_dP
" Delete to void
nnoremap ;d "_d
vnoremap ;d "_d
" Paste last yanked thing, not deleted
nnoremap ;p "0p
vnoremap ;p "0p
nnoremap ;P "0P
vnoremap ;P "0P

" Increment/Decrement Number Under Cursor
nnoremap <leader>+ <C-a>
nnoremap <leader>- <C-x>

" Windows/Splits
" Close window
nnoremap <leader>wx <Cmd>close <CR>
" Close Other Windows
nnoremap <leader>wo <Cmd>only <CR>
" Close window
nnoremap <leader>wd <Cmd>close <CR>
" Split Vertically
nnoremap <leader>wv <C-w>v
" Split Horizontally
nnoremap <leader>wh <C-w>s
" Balance Splits
nnoremap <leader>we <C-w>=
" Split Vertically
nnoremap <leader>w\| <C-w>v
" Split Horizontally
nnoremap <leader>w- <C-w>s
" Balance Splits
nnoremap <leader>w= <C-w>=
" Open window in a new tab
nnoremap <leader>wt <C-w>T

" Tabs
" Go to previous tab
nnoremap <F1> <Cmd>tabprev<CR>
" Close Other Tabs
nnoremap <leader>to :tabonly <CR>
" Open New Tab
nnoremap <leader>tt :tabnew <CR>
" Open New Tab
nnoremap <leader>tn :tabnew <CR>
" Close Tab
nnoremap <leader>tx :tabclose <CR>
" Close Tab
nnoremap <leader>td :tabclose <CR>
" Next Tab
nnoremap <leader>tk :tabnext <CR>
" Previous Tab
nnoremap <leader>tj :tabprevious <CR>
" First Tab
nnoremap <leader>th :tabfirst <CR>
" Last Tab
nnoremap <leader>tl :tablast <CR>
" Tab Split Buffer
nnoremap <leader>ts :tab split <CR>

" Buffers
" Move to next buffer
nnoremap <TAB> <cmd>bn<CR>
" Move to previous buffer
nnoremap <S-TAB> <cmd>bp<CR>
" New Buffer
nnoremap <leader>bn <Cmd>enew <CR>
" New Buffer
nnoremap <leader>bb <Cmd>enew <CR>
" Next Buffer
nnoremap <leader>bk <Cmd>bn <CR>
" Previous Buffer
nnoremap <leader>bj <Cmd>bp <CR>
" Delete Buffer
nnoremap <leader>bd <Cmd>bd <CR>
" Delete Buffer
nnoremap <leader>bx <Cmd>bd <CR>
" Reload Buffer
nnoremap <leader>br <Cmd>e <CR>

" Toggle Word wrap
nnoremap <leader>ww <Cmd>set wrap! <CR>

" Configuring file browsing plugin (it comes built in)
let g:netrw_dirhistmax = 3
let g:netrw_banner  = 0
let g:netrw_browse_split  = 4
let g:netrw_altv  = 1
let g:netrw_liststyle  = 3

set expandtab
set smarttab
set shiftwidth=2
set tabstop=8
set softtabstop=2
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
set ruler

set visualbell
set mouse=a
set t_vb=

hi Normal guibg=NONE ctermbg=NONE
autocmd vimenter * hi Normal guibg=NONE ctermbg=NONE
autocmd vimenter * hi EndOfBuffer guibg=NONE ctermbg=NONE

" Change cursor with modes
if &term =~ "xterm\\|rxvt"
  let &t_SI = "\1\<Esc>[5 q\<Esc>]12;green\x7"
  let &t_EI = "\1\<Esc>[1 q\<Esc>]12;orange\x7"
  silent !echo -ne "\033[1 q\033]12;orange\x7"
endif


"Clipboard configuration

" set clipboard+=unnamedplus
" let g:clipboard = {
"         \   'name': 'WslClipboard',
"         \   'copy': {
"         \     '+': 'clip.exe',
"         \     '*': 'clip.exe',
"         \   },
"         \   'paste': {
"         \     '+': 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
"         \     '*': 'powershell.exe -c [Console]::Out.Write($(Get-Clipboard -Raw).tostring().replace("`r", ""))',
"         \   },
"         \   'cache_enabled': 0,
"         \ }

