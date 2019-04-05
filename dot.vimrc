" (n)vim Configuration
"==============================================================================
"## Installation & Usage
"```
"    mkdir -p ~/.config/nvim/ && cp dot.nvim ~/.config/nvim/init.vim && rm
"    ~/.vimrc && ln -s ~/.config/nvim/init.vim ~/.vimrc
"```
" NEOVIM: ~/.local/share/nvim/plugged
call plug#begin()
  "============================================================================
  " General Vim Settings
  """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  Plug 'tpope/vim-sensible'
  
  " Theme
  Plug 'tyrannicaltoucan/vim-deep-space'

  " Autocompletion
  Plug 'prabirshrestha/asyncomplete-file.vim'
  Plug 'prabirshrestha/async.vim'
  Plug 'prabirshrestha/asyncomplete.vim'
  Plug 'prabirshrestha/asyncomplete-buffer.vim'
  Plug 'prabirshrestha/asyncomplete-gocode.vim'

  " Snippets
  Plug 'honza/vim-snippets'

  " Alignment
  Plug 'junegunn/vim-easy-align'

  " File Manager
  Plug 'scrooloose/nerdtree', { 'on':  'NERDTreeToggle' }

  " Fuzzy
  Plug 'junegunn/fzf', { 'dir': '~/.fzf', 'do': './install --all' }


  "============================================================================
  " Parens
  """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  Plug 'andymass/vim-matchup' 


  "============================================================================
  " Specific Programming Language Plugins
  """""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
  "== Markdown Plugins
  Plug 'junegunn/goyo.vim', { 'for': 'markdown' }

  "== C++
  Plug 'octol/vim-cpp-enhanced-highlight', { 'for': 'cpp' }

  "== Go Related Plugins
  Plug 'fatih/vim-go', { 'do': ':GoUpdateBinaries' }
  Plug 'nsf/gocode', { 'tag': 'v.20150303', 'rtp': 'vim' }


call plug#end()
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"==============================================================================
" Convert tabs to spaces, use 2 spaces for tabs
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set expandtab
set tabstop=2
set shiftwidth=2


"==============================================================================
" Jump to the last position when reopening a file
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has("autocmd")
  au BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
endif


"==============================================================================
" Nerdtree Settings - Key Assignment
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
nnoremap <C-a> :tabprevious<CR>
nnoremap <C-d> :tabnext<CR>
nnoremap <C-s> :tabnew<CR>:NERDTree<CR>


"==============================================================================
" Theme
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
set background=dark
set termguicolors
colorscheme deep-space


"==============================================================================
" Disable matching parens 
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"" PROBLEM: I can't see the highlighting with the space color theme, and
"" essentially I have the problem with every color scheme, so I turn it off

"function! g:FuckThatMatchParen ()
"    if exists(":NoMatchParen")
"        :NoMatchParen
"    endif
"endfunction
"
"augroup plugin_initialize
"    autocmd!
"    autocmd VimEnter * call FuckThatMatchParen()
"augroup END

"" ALTERNATIVE SOLUTION: use `vim-matchup` plugin and below settings to make it
"" easier to see


let g:matchup_surround_enabled = 1
let g:matchup_transmute_enabled = 1
let g:matchup_delim_stopline = 60


:hi MatchParenCur cterm=underline gui=underline
:hi MatchWordCur cterm=underline gui=underline

:hi MatchParen ctermbg=blue guibg=lightblue cterm=italic gui=italic

"augroup matchup_matchparen_highlight
"  autocmd!
"  autocmd ColorScheme * hi MatchParen guifg=red
"augroup END

""deferred highlighting
""Deferred highlighting improves cursor movement performance (for example, when
""using hjkl) by delaying highlighting for a short time and waiting to see if the
""cursor continues moving;
"let g:matchup_matchparen_deferred = 1


"" Can disable per filetype
""A common usage of these options is to automatically disable matchparen for particular file types;
""
""augroup matchup_matchparen_disable_ft
""  autocmd!
""  autocmd FileType tex let [b:matchup_matchparen_fallback,
""      \ b:matchup_matchparen_enabled] = [0, 0]
""augroup END

"==============================================================================
" Aliasing
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
command Q q
command Qw wq
command W w 
command Wq wq
"cmap q qa

imap <c-space> <Plug>(asyncomplete_force_refresh)
set completeopt-=preview

let g:asyncomplete_smart_completion = 1
let g:asyncomplete_auto_popup = 1
let g:asyncomplete_remove_duplicates = 1

autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

call asyncomplete#register_source(asyncomplete#sources#gocode#get_source_options({
    \ 'name': 'gocode',
    \ 'whitelist': ['go'],
    \ 'completor': function('asyncomplete#sources#gocode#completor'),
    \ 'config': {
    \    'gocode_path': expand('~/Development/bin/gocode')
    \  },
    \ }))

au User asyncomplete_setup call asyncomplete#register_source(asyncomplete#sources#file#get_source_options({
    \ 'name': 'file',
    \ 'whitelist': ['*'],
    \ 'priority': 10,
    \ 'completor': function('asyncomplete#sources#file#completor')
    \ }))

call asyncomplete#register_source(asyncomplete#sources#buffer#get_source_options({
    \ 'name': 'buffer',
    \ 'whitelist': ['*'],
    \ 'blacklist': ['go'],
    \ 'completor': function('asyncomplete#sources#buffer#completor'),
    \ }))


"==============================================================================
" Use `tab` key to select completions.  Default is arrow keys.
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
"inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"


"==============================================================================
" Use tab to trigger auto completion; Default makes suggestions as you type
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
"let g:completor_auto_trigger = 0

let g:completor_gocode_binary = '/usr/bin/gocode'
set number


set textwidth=80
au BufRead,BufNewFile *.md setlocal textwidth=80


"==============================================================================
" Return to previous line if file previously opened
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
if has("autocmd")
  au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal! g'\"" | endif
endif

set undofile
set undodir=~/.config/nvim/undo/
set backupdir=~/.config/nvim/backup/
set directory=~/.config/nvim/tmp

tnoremap <Esc> <C-\><C-n>


"==============================================================================
" Some early experimentation with auto IDE-esque layout when opening nvim
"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""

"10sp also works
"split | Explore | resize 50 
