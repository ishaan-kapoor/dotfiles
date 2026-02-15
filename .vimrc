set number
set relativenumber
set nowrap

syntax enable
filetype plugin on
set showcmd
set nocompatible
set foldenable
set foldmethod=syntax

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

nnoremap <leader>y "+y
vnoremap <leader>y "+y
nnoremap <leader>p "+p
nnoremap <leader>P "+P
vnoremap <leader>p "+p
vnoremap <leader>P "+P
nnoremap <leader>d "+d
nnoremap <leader>D "+D
vnoremap <leader>d "+d
vnoremap <leader>D "+D

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
set undofile
set undodir=~/.local/share/vim/undodir

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


" Maps <C-h/j/k/l> to switch vim splits in the given direction. If there are no more windows in that direction, forwards the operation to tmux.
" Additionally, <C-\> toggles between last active vim splits/tmux panes.

if exists("g:loaded_tmux_navigator") || &cp || v:version < 700
  finish
endif
let g:loaded_tmux_navigator = 1

function! s:VimNavigate(direction)
  try
    execute 'wincmd ' . a:direction
  catch
    echohl ErrorMsg | echo 'E11: Invalid in command-line window; <CR> executes, CTRL-C quits: wincmd k' | echohl None
  endtry
endfunction

if !get(g:, 'tmux_navigator_no_mappings', 0)
  nnoremap <silent> <c-h> :<C-U>TmuxNavigateLeft<cr>
  nnoremap <silent> <c-j> :<C-U>TmuxNavigateDown<cr>
  nnoremap <silent> <c-k> :<C-U>TmuxNavigateUp<cr>
  nnoremap <silent> <c-l> :<C-U>TmuxNavigateRight<cr>
  nnoremap <silent> <c-\> :<C-U>TmuxNavigatePrevious<cr>

  if !empty($TMUX)
    function! IsFZF()
      return &ft == 'fzf'
    endfunction
    tnoremap <expr> <silent> <C-h> IsFZF() ? "\<C-h>" : "\<C-w>:\<C-U> TmuxNavigateLeft\<cr>"
    tnoremap <expr> <silent> <C-j> IsFZF() ? "\<C-j>" : "\<C-w>:\<C-U> TmuxNavigateDown\<cr>"
    tnoremap <expr> <silent> <C-k> IsFZF() ? "\<C-k>" : "\<C-w>:\<C-U> TmuxNavigateUp\<cr>"
    tnoremap <expr> <silent> <C-l> IsFZF() ? "\<C-l>" : "\<C-w>:\<C-U> TmuxNavigateRight\<cr>"
  endif

  if !get(g:, 'tmux_navigator_disable_netrw_workaround', 0)
    if !exists('g:Netrw_UserMaps')
      let g:Netrw_UserMaps = [['<C-l>', '<C-U>TmuxNavigateRight<cr>']]
    else
      echohl ErrorMsg | echo 'vim-tmux-navigator conflicts with netrw <C-l> mapping. See https://github.com/christoomey/vim-tmux-navigator#netrw or add `let g:tmux_navigator_disable_netrw_workaround = 1` to suppress this warning.' | echohl None
    endif
  endif
endif

if empty($TMUX)
  command! TmuxNavigateLeft call s:VimNavigate('h')
  command! TmuxNavigateDown call s:VimNavigate('j')
  command! TmuxNavigateUp call s:VimNavigate('k')
  command! TmuxNavigateRight call s:VimNavigate('l')
  command! TmuxNavigatePrevious call s:VimNavigate('p')
  finish
endif

command! TmuxNavigateLeft call s:TmuxAwareNavigate('h')
command! TmuxNavigateDown call s:TmuxAwareNavigate('j')
command! TmuxNavigateUp call s:TmuxAwareNavigate('k')
command! TmuxNavigateRight call s:TmuxAwareNavigate('l')
command! TmuxNavigatePrevious call s:TmuxAwareNavigate('p')

if !exists("g:tmux_navigator_save_on_switch")
  let g:tmux_navigator_save_on_switch = 0
endif

if !exists("g:tmux_navigator_disable_when_zoomed")
  let g:tmux_navigator_disable_when_zoomed = 0
endif

if !exists("g:tmux_navigator_preserve_zoom")
  let g:tmux_navigator_preserve_zoom = 0
endif

if !exists("g:tmux_navigator_no_wrap")
  let g:tmux_navigator_no_wrap = 0
endif

let s:pane_position_from_direction = {'h': 'left', 'j': 'bottom', 'k': 'top', 'l': 'right'}

function! s:TmuxOrTmateExecutable()
  return (match($TMUX, 'tmate') != -1 ? 'tmate' : 'tmux')
endfunction

function! s:TmuxVimPaneIsZoomed()
  return s:TmuxCommand("display-message -p '#{window_zoomed_flag}'") == 1
endfunction

function! s:TmuxSocket()
  " The socket path is the first value in the comma-separated list of $TMUX.
  return split($TMUX, ',')[0]
endfunction

function! s:TmuxCommand(args)
  let cmd = s:TmuxOrTmateExecutable() . ' -S ' . s:TmuxSocket() . ' ' . a:args
  let l:x=&shellcmdflag
  let &shellcmdflag='-c'
  let retval=system(cmd)
  let &shellcmdflag=l:x
  return retval
endfunction

function! s:TmuxNavigatorProcessList()
  echo s:TmuxCommand("run-shell 'ps -o state= -o comm= -t ''''#{pane_tty}'''''")
endfunction
command! TmuxNavigatorProcessList call s:TmuxNavigatorProcessList()

let s:tmux_is_last_pane = 0
augroup tmux_navigator
  au!
  autocmd WinEnter * let s:tmux_is_last_pane = 0
augroup END

function! s:NeedsVitalityRedraw()
  return exists('g:loaded_vitality') && v:version < 704 && !has("patch481")
endfunction

function! s:ShouldForwardNavigationBackToTmux(tmux_last_pane, at_tab_page_edge)
  if g:tmux_navigator_disable_when_zoomed && s:TmuxVimPaneIsZoomed()
    return 0
  endif
  return a:tmux_last_pane || a:at_tab_page_edge
endfunction


function! s:TmuxAwareNavigate(direction)
  let nr = winnr()
  let tmux_last_pane = (a:direction == 'p' && s:tmux_is_last_pane)
  if !tmux_last_pane
    call s:VimNavigate(a:direction)
  endif
  let at_tab_page_edge = (nr == winnr())
  " Forward the switch panes command to tmux if:
  " a) we're toggling between the last tmux pane;
  " b) we tried switching windows in vim but it didn't have effect.
  if s:ShouldForwardNavigationBackToTmux(tmux_last_pane, at_tab_page_edge)
    if g:tmux_navigator_save_on_switch == 1
      try
        update " save the active buffer. See :help update
      catch /^Vim\%((\a\+)\)\=:E32/ " catches the no file name error
      endtry
    elseif g:tmux_navigator_save_on_switch == 2
      try
        wall " save all the buffers. See :help wall
      catch /^Vim\%((\a\+)\)\=:E141/ " catches the no file name error
      endtry
    endif
    let args = 'select-pane -t ' . shellescape($TMUX_PANE) . ' -' . tr(a:direction, 'phjkl', 'lLDUR')
    if g:tmux_navigator_preserve_zoom == 1
      let l:args .= ' -Z'
    endif
    if g:tmux_navigator_no_wrap == 1 && a:direction != 'p'
      let args = 'if -F "#{pane_at_' . s:pane_position_from_direction[a:direction] . '}" "" "' . args . '"'
    endif
    silent call s:TmuxCommand(args)
    if s:NeedsVitalityRedraw()
      redraw!
    endif
    let s:tmux_is_last_pane = 1
  else
    let s:tmux_is_last_pane = 0
  endif
endfunction

