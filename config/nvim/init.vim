syntax on
filetype on

"enable clipboard
set clipboard+=unnamedplus

"disable mouse
set mouse=""

"enable modeline
set modeline
set modelines=5

"tab handling
set expandtab
set shiftwidth=4
set tabstop=4
set softtabstop=4

"look and feel
set number
set numberwidth=4
set bg=dark
set relativenumber
set smartindent
set showmatch

"resize splits when the window is resized
au VimResized * exe "normal! \<c-w>="

"toggle paste and go in insert mode
if maparg('<C-i>', 'n') ==# ''
  nnoremap <silent> <C-i> :set paste<CR>:startinsert<CR>
endif

" Disable paste mode when leaving Insert mode
au InsertLeave * set nopaste

"unmap F1
noremap <F1> <Esc>

"Toggle between tabs and spaces
if maparg('<C-p>', 'n') ==# ''
    nnoremap <silent> <C-p> :set expandtab!<CR>
endif

"Use tab for auto completion
function! SuperTab()
  if (strpart(getline('.'),col('.')-2,1)=~'^\W\?$')
    return "\<Tab>"
  else
    return "\<C-n>"
  endif
endfunction
imap <Tab> <C-R>=SuperTab()<CR>

"switch between relative- and normal number
if maparg('<C-n>', 'n') ==# ''
    nnoremap <silent> <C-n> :set relativenumber!<CR>
endif

"search highlight and stuff
set incsearch
set hlsearch

" Use <C-l> to clear the highlighting of :set hlsearch.
if maparg('<C-l>', 'n') ==# ''
    nnoremap <silent> <C-l> :nohlsearch<CR><C-l>
endif

" Allow color schemes to do bright colors without forcing bold.
if &t_Co == 8 && $TERM !~# '^linux'
    set t_Co=16
endif

"change colorsheme to fancy landscape
let g:landscape_highlight_url = 0
let g:landscape_highlight_url_filetype = 1
let g:landscape_highlight_todo = 1
let g:landscape_highlight_full_space = 1
colorscheme landscape

"show whitespace
set list
set listchars=tab:>.,trail:.,extends:#,nbsp:.

"save undo history to files for persistent even if vim was closed inbetween
set undodir=~/.config/nvim/nvimundo
set undofile
set undolevels=1000 "maximum number of changes that can be undone
set undoreload=1000 "maximum number lines to save for undo on a buffer reload

" show the tabline when multiple tabs are open
set showtabline=1

" vim:set ft=vim et sw=2 sts=2:
