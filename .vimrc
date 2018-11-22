syntax on
set background=dark
colorscheme hybrid
set mouse=a

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

" Split navigation
map <C-H> <C-W>h<C-W>
map <C-L> <C-W>l<C-W>
" map <C-J> <C-W>j<C-W>_
" map <C-K> <C-W>k<C-W>_
set wmh=0

" Fuzzy file/buffer search
nnoremap <C-F> :Files<CR>
nnoremap <C-B> :Buffers<CR>
nnoremap <C-A> :Ag<CR>

"Buffer switching
nnoremap “ :bprev<CR>
nnoremap ‘ :bnext<CR>

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

" Plugins - https://github.com/junegunn/vim-plug
call plug#begin('~/.vim/vim-plug')
Plug 'airblade/vim-rooter'
Plug 'avakhov/vim-yaml'
Plug 'christoomey/vim-sort-motion'
Plug 'christoomey/vim-tmux-navigator'
Plug 'digitaltoad/vim-pug'
Plug 'fatih/vim-go'
Plug 'jelera/vim-javascript-syntax'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'mileszs/ack.vim'
Plug 'tpope/vim-abolish'
Plug 'wavded/vim-stylus'
Plug 'evnp/fodlgang'
call plug#end()
