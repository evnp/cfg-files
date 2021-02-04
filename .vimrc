syntax on
set background=dark
colorscheme alduin
set mouse=a

set backspace=indent,eol,start
if getline(1) =~ '^{'
set ft=json
endif

" Treat hyphen and dot -separated words as "text objects" for movements like iw
set iskeyword+=-
set iskeyword+=.

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
inoremap uu <ESC>u
inoremap ww <ESC>:w<CR>
inoremap qq <ESC>:w<CR>:Q<CR>
inoremap ;; <ESC>:

" CTRL Hotkeys
nnoremap <C-W> :w<CR>
nnoremap <C-E> :w<CR>:Q<CR>
nnoremap <C-G> :GG<CR>
inoremap <C-W> <ESC>:w<CR>
inoremap <C-E> <ESC>:w<CR>:Q<CR>
inoremap <C-G> <ESC>:GG<CR>
" also: ctrl+a -> ESC (remap key binding in iterm preferences: 'Send Hex Codes: 0x1B')

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

" Folding
set foldlevelstart=8

" superquit
command! Q wqa!

" delete without yanking
nnoremap <leader>d "_d
vnoremap <leader>d "_d

" replace currently selected text with default register
" without yanking it
vnoremap <leader>p "_dP

" Save on esc:
inoremap <Esc> <Esc>:w<CR>
set noswapfile  " disable swp file creation since we're auto-saving
set nobackup
set hidden

" Focus Mode
let g:goyo_width=160
function! Focus()
  Goyo
  highlight StatusLineNC ctermfg=white
  set linebreak
  autocmd TextChangedI <buffer> update
  set spell spelllang=en_us
endfunction
function! MaybeFocus()
  try
    if &filetype ==# 'text' || &filetype ==# 'markdown' || &filetype ==# 'asciidoc'
      call Focus()
    endif
  catch
    " pass
  endtry
endfunction
command! Focus :call Focus()
autocmd VimEnter * :call MaybeFocus()

" Typewriter Mode (cursor fixed to middle of screen, document scrolls automatically)
function! Typewriter()
  if &scrolloff == 0
    set scrolloff=999
  else
    set scrolloff=0
  endif
endfunction
command! Typewriter :call Typewriter()

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

function! BuildYouCompleteMe(info)
  " info is a dictionary with 3 fields
  " - name:   name of the plugin
  " - status: 'installed', 'updated', or 'unchanged'
  " - force:  set on PlugInstall! or PlugUpdate!
  if a:info.status == 'installed' || a:info.force
    !./install.py
  endif
endfunction

" Plugins - https://github.com/junegunn/vim-plug
set rtp+=~/.fzf " required for fzf.vim to work
call plug#begin('~/.vim/vim-plug')

Plug 'airblade/vim-rooter'              " auto-set cwd to root of project (via heuristic, e.g. where is .git dir) useful for FZF
Plug 'christoomey/vim-sort-motion'      " sort within a single line
Plug 'christoomey/vim-tmux-navigator'   " navigate between tmux panes and vim splits using consistent hotkeys
Plug 'evnp/fodlgang'                    " better folding
Plug '/usr/local/opt/fzf'
Plug 'junegunn/fzf.vim'                 " fzf integration
Plug 'junegunn/goyo.vim'                " focus-mode
Plug 'mileszs/ack.vim'                  " ack integration
Plug 'tpope/vim-abolish'                " case-intelligent search/replace
Plug 'tpope/vim-surround'
Plug 'vim-airline/vim-airline'
Plug 'vim-airline/vim-airline-themes'
Plug 'edkolev/tmuxline.vim'
Plug 'rhysd/vim-grammarous'
Plug 'xolox/vim-misc'
Plug 'xolox/vim-colorscheme-switcher'
Plug 'gko/vim-coloresque'

" syntax highlighting & language integration:
Plug 'posva/vim-vue'
Plug 'Quramy/tsuquyomi'
Plug 'Quramy/tsuquyomi-vue'
Plug 'avakhov/vim-yaml'
Plug 'cespare/vim-toml'
Plug 'dagwieers/asciidoc-vim'
Plug 'dearrrfish/vim-applescript'
Plug 'dense-analysis/ale'
Plug 'digitaltoad/vim-pug'
Plug 'elzr/vim-json'
Plug 'fatih/vim-go'
Plug 'jelera/vim-javascript-syntax' " better javascript syntax highligting
Plug 'leafgarland/typescript-vim'   " better typescript syntax highligting
Plug 'mustache/vim-mustache-handlebars'
Plug 'rust-lang/rust.vim'
Plug 'wavded/vim-stylus'
Plug 'Valloric/YouCompleteMe'
", { 'do': function('BuildYouCompleteMe') }

call plug#end()

" spelling & grammar check
function! ToggleSpelling()
  if &spell ==# 'nospell'
    set spell spelllang=en_us
  else
    set nospell
  endif
endfunction
nmap <leader>q :copen<CR>
nmap <leader>s :call ToggleSpelling()<CR>
nmap <leader>g :GrammarousCheck<CR>
nmap <leader>c :ccl<CR> :set nospell<CR>

" Ale syntax linting & autofixing
let g:ale_linter_aliases = {'vue': 'typescript'}
let g:ale_linters = {
\   'rust': ['rust-analyzer'],
\   'python': [],
\   'javascript': ['prettier', 'eslint'],
\   'typescript': ['tsserver', 'prettier', 'eslint'],
\   'vue': ['tsserver', 'prettier', 'eslint']
\ }
let g:ale_fixers = {
\   'python': ['black'],
\   'javascript': ['prettier', 'eslint'],
\   'typescript': ['prettier', 'eslint'],
\   'vue': ['prettier', 'eslint'],
\ }
" let g:ale_rust_rls_config = {
"   \ 'rust': {
"     \ 'all_targets': 1,
"     \ 'build_on_save': 1,
"     \ 'clippy_preference': 'on',
"   \ },
" \ }
" let g:ale_rust_rls_toolchain = ''
" let g:ale_rust_rls_executable = 'rust-analyzer'
let g:ale_rust_analyzer_config = {
      \ 'diagnostics': { 'disabled': ['unresolved-import'] },
      \ 'cargo': { 'loadOutDirsFromCheck': v:true },
      \ 'procMacro': { 'enable': v:true },
      \ 'checkOnSave': { 'command': 'clippy', 'enable': v:true },
\ }
let g:rustfmt_autosave = 1

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

let g:fzf_colors = {
  \ 'bg': ['bg', 'Normal'],
  \ 'bg+': ['bg', 'Normal'],
  \ }


let g:ycm_language_server =
\ [
\   {
\     'name': 'rust',
\     'cmdline': ['rust-analyzer'],
\     'filetypes': ['rust'],
\     'project_root_files': ['Cargo.toml']
\   }
\ ]

" Homerow
so ~/homerow-bash/vim/fzf.vim
