syntax on
set background=dark
colorscheme adventurous
set mouse=a

inoremap jj <ESC>
set backspace=indent,eol,start
if getline(1) =~ '^{'
	set ft=json
endif

set shortmess=a  " use abbrev. messaging to avoid some 'hit enter' prompts
set guifont=Monaco:h11
let g:Powerline_symbols = 'fancy'
set encoding=utf-8
set t_Co=256
set fillchars+=stl:\ ,stlnc:\
set term=xterm-256color
set termencoding=utf-8

" Hide Toolbar "
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

" TODO set Tabs on file open if file contains tabs
function! Tabs()
	set noexpandtab
	%retab!
endfunction
command! Tabs :call Tabs()

" Search
set incsearch
set hlsearch
set ignorecase
set smartcase
nnoremap \ :noh<CR>

highlight FoldColumn	gui=bold		guifg=grey65		 guibg=Grey90
highlight Folded			gui=italic	guifg=Black			 guibg=Grey90
highlight LineNr			gui=NONE		guifg=grey60		 guibg=Grey90

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

inoremap <S-Backspace> <Backspace><Backspace>

nnoremap t o<Esc>
nnoremap T O<Esc>
nnoremap H 0w
nnoremap J zj
nnoremap K zk
nnoremap L $
nnoremap <F9> :vsp $MYGVIMRC<CR>

" Autosave
" let g:auto_save = 1  " enable AutoSave on Vim startup
" let g:auto_save_in_insert_mode = 0	" do not save while in insert mode
" let g:auto_save_silent = 1	" do not display the auto-save notification
inoremap <Esc> <Esc>:w<CR>
set noswapfile	" disable swp file creation since we're auto-saving
set nobackup

" Folding
set foldlevelstart=2

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
Plug 'Quramy/tsuquyomi'									" typescript integration
Plug 'airblade/vim-rooter'							" auto-set cwd to root of project (via heuristic, e.g. where is .git dir) useful for FZF
Plug 'elzr/vim-json'										" json syntax highlighting
Plug 'avakhov/vim-yaml'									" yaml syntax highlighting
Plug 'christoomey/vim-sort-motion'			" sort within a single line
Plug 'christoomey/vim-tmux-navigator'		" navigate between tmux panes and vim splits using consistent hotkeys
Plug 'dearrrfish/vim-applescript'
Plug 'digitaltoad/vim-pug'							" pug/jade syntax highlighting
Plug 'drmingdrmer/vim-toggle-quickfix'	" hotkey for quickfix window toggle
Plug 'evnp/fodlgang'										" better folding
Plug 'fatih/vim-go'											" go syntax highlighting
Plug 'jelera/vim-javascript-syntax'			" better javascript syntax highligting
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'									" fzf integration
Plug 'junegunn/goyo.vim'								" focus-mode
Plug 'junegunn/seoul256.vim'						" color scheme
Plug 'leafgarland/typescript-vim'				" typescript syntax highlighting
Plug 'mileszs/ack.vim'									" ack integration
Plug 'tpope/vim-abolish'								" case-intelligent search/replace
" Plug 'vim-scripts/vim-auto-save'				" write to disk immediately when a buffer is modified
Plug 'wavded/vim-stylus'								" stylus syntax highlighting
Plug 'xolox/vim-misc'
Plug 'xolox/vim-colorscheme-switcher'
Plug 'dense-analysis/ale'
call plug#end()

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
nnoremap <C-A> :ALEFix<CR>

" lint and write
nnoremap w :ALEFix<CR> :sleep 1<CR> :w<CR>

" code linting
nmap <leader>q :call ToggleQuickFix()<CR> :call plug#load('tsuquyomi')<CR> <Plug>window:quickfix:toggle<CR>
let g:tsuquyomi_disable_quickfix = 0
function! ToggleQuickFix()
  let g:tsuquyomi_disable_quickfix = 1
  "WIP tsuquyomi disable quickfix: why doesn't this work?
  "unlet g:loaded_tsuquyomi
  "if (g:tsuquyomi_disable_quickfix == 1)
  "  let g:tsuquyomi_disable_quickfix = 0
  "else
  "  let g:tsuquyomi_disable_quickfix = 1
  "endif
endfunction
