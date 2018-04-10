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
set autochdir

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

" Folding
nnoremap - zm
nnoremap _ zM
nnoremap = zr
nnoremap + zR
nnoremap <silent> <Space> @=(foldlevel('.') ? (foldclosed('.') < 0 ? 'zc' : 'zO' ) : 'l')<CR>

set foldmethod=expr
set foldexpr=GetLineFoldLevel(v:lnum)

function! IndentLevel(lnum)
  return indent(a:lnum) / &shiftwidth
endfunction

function! NextNonBlankLine(lnum)
  let numlines = line('$')
  let current = a:lnum + 1

  while current <= numlines
    if getline(current) =~? '\v\S'
      return current
    endif

    let current += 1
  endwhile

  return -2
endfunction

"modified foldexpr from http://learnvimscriptthehardway.stevelosh.com/chapters/49.html
function! GetLineFoldLevel(lnum)
  let line = getline(a:lnum)

  "set foldlevel 'undefined' for blank lines so they share foldlevel with prev or next line
  if line =~? '\v^\s*$'
    return '-1'
  endif

  let curr_indent = IndentLevel(a:lnum)
  let next_indent = IndentLevel(NextNonBlankLine(a:lnum))

  "fold #regions
  if curr_indent > 0 && line =~? '#region'
    let curr_indent -= 1
  endif

  "fold block comments
  let has_comment_start = line =~? '/\*'
  let has_comment_end = line =~? '\*/'
  "opening comment line /*...
  if has_comment_start && !has_comment_end
    let curr_indent += 1
    return '>' . curr_indent
  endif
  "closing comment line ...*/
  if !has_comment_start && has_comment_end
    let curr_indent += 1
    return '<' . curr_indent
  endif
  "intermediate comment line *...
  if line =~? '^\s*\*'
    return '-1'
  endif

  "include closing bracket lines in the previous fold
  if line =~? '\v^\s*[\}\]\)]'
    let curr_indent += 1
  endif

  "include block opening lines (i.e. function signature, if/for/while declaration) in the following fold
  if next_indent > curr_indent
    return '>' . next_indent
  endif

  return curr_indent
endfunction

" Set a nicer foldtext function
set foldtext=MyFoldText()
function! MyFoldText()
  let line = getline(v:foldstart)
  if match( line, '^[ \t]*\(\/\*\|\/\/\)[*/\\]*[ \t]*$' ) == 0
    let initial = substitute( line, '^\([ \t]\)*\(\/\*\|\/\/\)\(.*\)', '\1\2', '' )
    let n = v:foldend - v:foldstart + 1
    let sub = initial . '...' . n . '...' . '*/'
  else
    let sub = line
    let startbrace = substitute(line, '^.*{[ \t]*$', '{', 'g')
    if startbrace == '{'
      let line = getline(v:foldend)
      let endbrace = substitute(line, '^[ \t]*}\(.*\)$', '}', 'g')
      if endbrace == '}'
        let n = v:foldend - v:foldstart + 1
        let sub = sub.substitute(line, '^[ \t]*}\(.*\)$', '...' . n . '...}\1', 'g')
      endif
    endif
  endif
  " replace trailing ------- with trailing space
  return sub . repeat(' ', 10000)
endfunction

highlight FoldColumn  gui=bold    guifg=grey65     guibg=Grey90
highlight Folded      gui=italic  guifg=Black      guibg=Grey90
highlight LineNr      gui=NONE    guifg=grey60     guibg=Grey90

" Save folds between file close/open
autocmd BufWinLeave *.*  mkview
autocmd BufWinEnter *.* silent loadview

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
Plug 'jelera/vim-javascript-syntax'
Plug 'wavded/vim-stylus'
Plug 'digitaltoad/vim-pug'
Plug 'christoomey/vim-tmux-navigator'
Plug 'christoomey/vim-sort-motion'
Plug 'tpope/vim-abolish'
Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }
Plug 'junegunn/fzf.vim'
Plug 'mileszs/ack.vim'
Plug 'fatih/vim-go'
call plug#end()
