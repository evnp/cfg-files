syntax on
set background=dark
colorscheme hybrid
set mouse=a

set shortmess=a  " use abbrev. messaging to avoid some 'hit enter' prompts
set guifont=Monaco:h11
let g:Powerline_symbols = 'fancy'
set encoding=utf-8
set t_Co=256
set fillchars+=stl:\ ,stlnc:\
set term=xterm-256color
set termencoding=utf-8

" Save automatically on esc from insert mode
" inoremap <Esc> <Esc>:w<CR>

" Hide Toolbar "
set guioptions-=T
set guioptions-=r
set go-=L

" Disable fscking OSX bell
autocmd! GUIEnter * set vb t_vb=

" Auto-load .vimrc on change
autocmd! bufwritepost .vimrc source %

" Strip trailing whitespace from files on save
autocmd BufWritePre * :%s/\s\+$//e

" Flake8 - Python linting
autocmd BufWritePost *.py call Flake8()
let g:flake8_show_in_file=1
let g:flake8_show_in_gutter=0
let g:flake8_show_quickfix=0
nmap 8 <Plug>window:quickfix:toggle

" Disable "safe write" to ensure webpack file watching works
set backupcopy=yes

" Hybrid relative/absolute line-numbering "
set relativenumber
set number

" Tabs
set list
set listchars=tab:>-,trail:.,extends:>,precedes:<
set shiftwidth=2
set sw=2 sts=2 ts=2 et
set autoindent
set expandtab

" Search
set incsearch
set hlsearch
set ignorecase
set smartcase
nnoremap \ :noh<CR>

highlight FoldColumn  gui=bold    guifg=grey65     guibg=Grey90
highlight Folded      gui=italic  guifg=Black      guibg=Grey90
highlight LineNr      gui=NONE    guifg=grey60     guibg=Grey90

" Split resizing
nnoremap <C-G> <C-W>=
nnoremap <C-O> <C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>>
nnoremap <C-Y> <C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><
nnoremap <C-U> <C-W>+<C-W>+<C-W>+<C-W>+<C-W>+<C-W>+<C-W>+<C-W>+<C-W>+<C-W>+<C-W>+<C-W>+
nnoremap <C-I> <C-W>-<C-W>-<C-W>-<C-W>-<C-W>-<C-W>-<C-W>-<C-W>-<C-W>-<C-W>-<C-W>-<C-W>-

set wmh=0

" Fuzzy file/buffer search
nnoremap <C-F> :Files<CR>
nnoremap <C-B> :Buffers<CR>
nnoremap <C-G> :Ag<CR>

" Buffer switching
nnoremap ] :bprev<CR>
nnoremap [ :bnext<CR>

" Tab switching
nnoremap } :tabnext<CR>
nnoremap { :tabprev<CR>

"--------------

inoremap <Tab> <Space><Space>
inoremap <S-Backspace> <Backspace><Backspace>

nnoremap t o<Esc>
nnoremap T O<Esc>
nnoremap H 0w
nnoremap J zj
nnoremap K zk
nnoremap L $
nnoremap <F9> :vsp $MYGVIMRC<CR>

" Autosave
let g:auto_save = 1  " enable AutoSave on Vim startup
let g:auto_save_in_insert_mode = 0  " do not save while in insert mode
let g:auto_save_silent = 1  " do not display the auto-save notification
set noswapfile  " disable swp file creation since we're auto-saving
set nobackup

" Folding
set foldlevelstart=2

" Automatically go into paste mode when pasting (to avoid auto-indent)
let &t_SI .= "\<Esc>[?2004h"
let &t_EI .= "\<Esc>[?2004l"

inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()

function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ""
endfunction

" suppress vim-go version warning
let g:go_version_warning = 0

" superquit
command Q wqa!

" Plugins - https://github.com/junegunn/vim-plug
set rtp+=~/.fzf " required for fzf.vim to work
call plug#begin('~/.vim/vim-plug')
Plug 'Quramy/tsuquyomi'
Plug 'airblade/vim-rooter'
Plug 'avakhov/vim-yaml'
Plug 'christoomey/vim-sort-motion'
Plug 'christoomey/vim-tmux-navigator'
Plug 'digitaltoad/vim-pug'
Plug 'drmingdrmer/vim-toggle-quickfix'
Plug 'evnp/fodlgang'
Plug 'fatih/vim-go'
Plug 'jelera/vim-javascript-syntax'
Plug 'junegunn/fzf.vim'
Plug 'leafgarland/typescript-vim'
Plug 'mileszs/ack.vim'
Plug 'nvie/vim-flake8'
Plug 'tpope/vim-abolish'
Plug 'tpope/vim-unimpaired'
Plug 'vim-scripts/vim-auto-save'
Plug 'wavded/vim-stylus'
call plug#end()
