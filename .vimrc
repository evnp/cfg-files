syntax on
set background=dark
colorscheme alduin
set mouse=a

set backspace=indent,eol,start
if getline(1) =~ '^{'
set ft=json
endif

let g:airline_powerline_fonts=1
set shortmess=a  " use abbrev. messaging to avoid some 'hit enter' prompts
set guifont=Monaco:h11
set encoding=utf-8
set t_Co=256
set fillchars+=stl:\ ,stlnc:\
set term=xterm-256color
set termencoding=utf-8

" Homerow Escape
inoremap jj <ESC>
" also: ctrl+a (remap key binding in iterm preferences: 'Send Hex Codes: 0x1B')

" Hotkeys
nnoremap <C-W> :w<CR>
nnoremap <C-E> :w<CR>:Q<CR>
nnoremap <C-G> :GG<CR>
inoremap <C-W> <ESC>:w<CR>
inoremap <C-E> <ESC>:w<CR>:Q<CR>
inoremap <C-G> <ESC>:GG<CR>

" Hide Toolbar
set guioptions-=T
set guioptions-=r
set go-=L

" Disable fscking OSX bell
autocmd! GUIEnter * set vb t_vb=

" Strip trailing whitespace from files on save
autocmd BufWritePre * :%s/\s\+$//e

" Disable "safe write" to ensure webpack file watching works
set backupcopy=yes

" Hybrid relative/absolute line-numbering "
set relativenumber
set number

" function for entering 'display' mode with no line numbers, status bar, etc.
" good for recording/screenshotting demos
let s:hidden_all = 0
function! ToggleHiddenAll()
  if s:hidden_all  == 0
    let s:hidden_all = 1
    set noshowmode
    set noruler
    set laststatus=0
    set noshowcmd
    set norelativenumber
    set nonumber
  else
    let s:hidden_all = 0
    set showmode
    set ruler
    set laststatus=2
    set showcmd
    set relativenumber
    set number
  endif
endfunction

set list
set listchars=tab:·\ ,trail:·,extends:>,precedes:<
set shiftwidth=2
set tabstop=2
set softtabstop=2
set autoindent
set expandtab

function! Spaces()
  set expandtab
  %retab!
endfunction
command! Spaces :call Spaces()

function! Tabs()
  set noexpandtab
  %retab!
endfunction
command! Tabs :call Tabs()

function! MaybeTabs()
  try
    if match(readfile(expand("%:p")), "\t") != -1
      set noexpandtab
    endif
  catch
    " pass
  endtry
endfunction
autocmd VimEnter * :call MaybeTabs()

" Search
set incsearch
set hlsearch
set ignorecase
set smartcase
nnoremap \ :noh<CR>

" Split resizing
nnoremap <C-O> <C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>><C-W>>
nnoremap <C-Y> <C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><<C-W><
nnoremap <C-U> <C-W>+<C-W>+<C-W>+<C-W>+<C-W>+<C-W>+<C-W>+<C-W>+<C-W>+<C-W>+<C-W>+<C-W>+
" nnoremap <C-I> <C-W>-<C-W>-<C-W>-<C-W>-<C-W>-<C-W>-<C-W>-<C-W>-<C-W>-<C-W>-<C-W>-<C-W>-

set wmh=0

" Fuzzy file/buffer search
nnoremap <C-F> :Files<CR>
nnoremap <C-B> :Buffers<CR>
nnoremap <C-G> :Ag<CR>

" Buffer switching
nnoremap } :bprev<CR>
nnoremap { :bnext<CR>

"--------------

inoremap <S-Backspace> <Backspace><Backspace>

nnoremap t o<Esc>
nnoremap T O<Esc>
nnoremap H 0w
nnoremap J zj
nnoremap K zk
nnoremap L $
nnoremap <F9> :vsp $MYGVIMRC<CR>

" Autosave
"let g:auto_save = 1  " enable AutoSave on Vim startup
"let g:auto_save_in_insert_mode = 0  " do not save while in insert mode
"let g:auto_save_silent = 1  " do not display the auto-save notification
inoremap <Esc> <Esc>:w<CR>
set noswapfile  " disable swp file creation since we're auto-saving
set nobackup
set hidden

" Folding
set foldlevelstart=8

" suppress vim-go version warning
let g:go_version_warning = 0

" superquit
command! Q wqa!

" delete without yanking
nnoremap <leader>d "_d
vnoremap <leader>d "_d

" replace currently selected text with default register
" without yanking it
vnoremap <leader>p "_dP

" Focus
function! Focus()
  Goyo
  highlight StatusLineNC ctermfg=white
  set scrolloff=999
endfunction
command! Focus :call Focus()

" PDB
nnoremap <leader>pdb oimport pdb;pdb.set_trace()<esc>
nnoremap <leader>PDB :g/import pdb;pdb.set_trace()/d<cr>

" Automatically go into paste mode when pasting (to avoid auto-indent)
let &t_SI .= "\<Esc>[?2004h"
let &t_EI .= "\<Esc>[?2004l"

inoremap <special> <expr> <Esc>[200~ XTermPasteBegin()

function! XTermPasteBegin()
  set pastetoggle=<Esc>[201~
  set paste
  return ""
endfunction

" Plugins - https://github.com/junegunn/vim-plug
set rtp+=~/.fzf " required for fzf.vim to work
call plug#begin('~/.vim/vim-plug')
Plug 'Quramy/tsuquyomi'                 " typescript integration
Plug 'airblade/vim-rooter'              " auto-set cwd to root of project (via heuristic, e.g. where is .git dir) useful for FZF
Plug 'elzr/vim-json'                    " json syntax highlighting
Plug 'avakhov/vim-yaml'                 " yaml syntax highlighting
Plug 'christoomey/vim-sort-motion'      " sort within a single line
Plug 'christoomey/vim-tmux-navigator'   " navigate between tmux panes and vim splits using consistent hotkeys
Plug 'dearrrfish/vim-applescript'
Plug 'digitaltoad/vim-pug'              " pug/jade syntax highlighting
Plug 'evnp/fodlgang'                    " better folding
Plug 'fatih/vim-go'                     " go syntax highlighting
Plug 'jelera/vim-javascript-syntax'     " better javascript syntax highligting
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'                 " fzf integration
Plug 'junegunn/goyo.vim'                " focus-mode
Plug 'junegunn/seoul256.vim'            " color scheme
Plug 'leafgarland/typescript-vim'       " typescript syntax highlighting
Plug 'mileszs/ack.vim'                  " ack integration
Plug 'tpope/vim-abolish'                " case-intelligent search/replace
"Plug 'vim-scripts/vim-auto-save'        " write to disk immediately when a buffer is modified
Plug 'wavded/vim-stylus'                " stylus syntax highlighting
Plug 'dense-analysis/ale'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'edkolev/tmuxline.vim'
Plug 'rhysd/vim-grammarous'
Plug 'xolox/vim-misc'
Plug 'xolox/vim-colorscheme-switcher'
call plug#end()

" spelling & grammar check
nmap <leader>q :copen<CR>
nmap <leader>s :set spell spelllang=en_us<CR>
nmap <leader>g :GrammarousCheck<CR>
nmap <leader>c :ccl<CR> :set nospell<CR>

" Ale syntax linting & autofixing
let g:ale_linters = {
\   'python': [],
\   'javascript': ['prettier', 'eslint'],
\   'typescript': ['prettier', 'eslint'],
\}
let g:ale_fixers = {
\   'python': ['black'],
\   'javascript': ['prettier', 'eslint'],
\   'typescript': ['prettier', 'eslint'],
\}
nnoremap <leader>af :ALEFix<CR>
nnoremap <leader>at :ALEToggle<CR>
nnoremap <leader>aw :ALEFix<CR> :sleep 1<CR> :w<CR>
set scl=no  " no warnings in gutter (use status line)

" Airline (status line)
let g:airline#extensions#ale#enabled = 1
let g:airline_theme='dark'
let g:airline_section_y = ''
let g:airline_mode_map = {
    \ '__'     : '-',
    \ 'c'      : 'C',
    \ 'i'      : 'I',
    \ 'ic'     : 'I',
    \ 'ix'     : 'I',
    \ 'n'      : 'N',
    \ 'multi'  : 'M',
    \ 'ni'     : 'N',
    \ 'no'     : 'N',
    \ 'R'      : 'R',
    \ 'Rv'     : 'R',
    \ 's'      : 'S',
    \ 'S'      : 'S',
    \ ''     : 'S',
    \ 't'      : 'T',
    \ 'v'      : 'V',
    \ 'V'      : 'V',
    \ ''     : 'V',
    \ }
