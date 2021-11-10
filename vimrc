set nocompatible

" Pathogen
call pathogen#infect()
call pathogen#helptags()

set statusline=%<\ %n:%f\ %m%r%y%=%-35.(line:\ %l\ of\ %L,\ col:\ %c%V\ (%P)%)
filetype plugin indent on
 
syntax on
set number
set mouse=a
set mousehide

set spell
set hlsearch
set showmatch
set incsearch
set ignorecase
set nowrap
set autoindent
set history=1000
set cursorline
set expandtab
set shiftwidth=4
set tabstop=4
set softtabstop=4
"set lines=60
"set columns=80
"don't wrap while typing
set formatoptions-=t

" Nerdtree
"autocmd vimenter * NERDTree
autocmd VimEnter * wincmd p

map <C-e> :NERDTreeToggle<CR>:NERDTreeMirror<CR>
map <leader>e :NERDTreeFind<CR>
nmap <leader>nt :NERDTreeFind<CR>
let NERDTreeShowBookmarks=1
let NERDTreeChDirMode=0
let NERDTreeQuitOnOpen=0
let NERDTreeMouseMode=2
let NERDTreeShowHidden=0
let NERDTreeIgnore=['\.pyc','\~$','\.swo$','\.swp$','\.git','\.hg','\.svn','\.bzr']
let NERDTreeKeepTreeInNewTab=1
"let g:nerdtree_tabs_open_on_gui_startup=1


"colors - brilliant :D dont you touch this.
"
set background=dark
colorscheme peaksea
"open code folds by default
"
set foldlevel=20

"remove highlighting on previous search results
nnoremap <F3> :noh<return><esc>

"javascript - better with these options with inside html
let g:html_indent_inctags = "html,body,head,tbody"
let g:html_indent_script1 = "inc"
let g:html_indent_style1 = "inc"

"Compile a single file
nmap <F9> :SCCompile<cr>
nmap <F10> :SCCompileRun<cr>

"change the leader.
let mapleader = ','

"better clipboard - combined for OS + editor
"if has ('x') && has ('gui')
set clipboard=unnamedplus
"endif 

"Fugitive - it should be banned, it's illegal :D !!!
nnoremap <silent> <leader>gs :Gstatus<CR>
nnoremap <silent> <leader>gd :Gdiff<CR>
nnoremap <silent> <leader>gc :Gcommit<CR>
nnoremap <silent> <leader>gb :Gblame<CR>
nnoremap <silent> <leader>gl :Glog<CR>
nnoremap <silent> <leader>gp :Git push<CR>

"correct automatically my silly mistakes, machine.
if has("user_commands")
    command! -bang -nargs=* -complete=file E e<bang> <args>
    command! -bang -nargs=* -complete=file W w<bang> <args>
    command! -bang -nargs=* -complete=file Wq wq<bang> <args>
    command! -bang -nargs=* -complete=file WQ wq<bang> <args>
    command! -bang Wa wa<bang>
    command! -bang WA wa<bang>
    command! -bang Q q<bang>
    command! -bang QA qa<bang>
    command! -bang Qa qa<bang>
endif

"backup 
"set backup                  " Backups are nice ...

" persistent undo
if has('persistent_undo')
    set undofile                " So is persistent undo ...
    set undolevels=1000         " Maximum number of changes that can be undone
    set undoreload=10000        " Maximum number lines to save for undo on a buffer reload
endif

"close nerdtree if it's the only remaining window
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

"open nerdtree if no file was opened in vim
"autocmd vimenter * if !argc() | NERDTree | endif

"need to comment this if you don't want vim to wrap while typing
"autocmd FileType markdown set tw=80
map <Leader>n <plug>NERDTreeTabsToggle<CR>
let g:nerdtree_tabs_open_on_console_startup=1

:au Filetype html,xml,xsl,xsd source ~/.vim/bundle/closetag.vim/plugin/closetag.vim 
autocmd BufEnter * silent! lcd %:p:h
autocmd BufEnter *.m compiler mlint
autocmd BufEnter *.m setlocal nospell
let g:sparkupExecuteMapping='<c-h>'
set encoding=utf-8
set guifont=Inconsolata-dz\ for\ Powerline\ Medium\ 10
let g:airline_powerline_fonts = 1

"If you are in a commit or a blob, pressing C will take you to the commit.
autocmd User fugitive
  \ if fugitive#buffer().type() =~# '^\%(tree\|blob\)$' |
  \   nnoremap <buffer> .. :edit %:h<CR> |
  \ endif
"clean up all fugitive buffers as you leave them.
autocmd BufReadPost fugitive://* set bufhidden=delete
set t_Co=256
set nospell
set backupdir=~/.vim/backups,.,/tmp
set directory=~/.vim/backups,.,/tmp

"force airline to not be lazy
set laststatus=2 

"tabline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#left_sep = ' '
let g:airline#extensions#tabline#left_alt_sep = '|'

set tags=~/.mytags
let g:ctrlp_extensions = ['tag', 'buffertag', ]

set tw=80
set wm=0
:set colorcolumn=+1        " highlight column after 'textwidth'
:set colorcolumn=-1,-2,-3  " highlight three columns after 'textwidth'
:highlight ColorColumn ctermbg=lightgrey guibg=#592929
"augroup vimrc_autocmds
  autocmd BufEnter * highlight OverLength ctermbg=darkgrey guibg=#592929
  autocmd BufEnter * match OverLength /\%80v.*/
"augroup END



syn sync fromstart

let s:sessions_dir = "~/.vim/sessions/"

function! GetCurrentGitBranch()
    return system("git branch 2> /dev/null | sed -e '/^[^*]/d' -e 's/* //'")
endfunction

function! GetWorkingDirectory()
    redir => current_dir
    silent pwd
    redir END
    return current_dir
endfunction

function! GetSessionFile()
    let branch = GetCurrentGitBranch()
    if branch == ""
        echo "No git repository at " . GetWorkingDirectory()
    else
        return s:sessions_dir . GetCurrentGitBranch()
    endif
    return ""
endfunction

function! GitSessionSave()
    let session_file = GetSessionFile()
    if session_file != ""
        execute "mksession! " . session_file
        echo "Saved session to " . session_file
    endif
endfunction

function! GitSessionRestore()
    let session_file = GetSessionFile()
    if session_file != ""
        execute "tabo"
        execute "source " . session_file
        echo "Restored session " . session_file
    endif
endfunction

command! Gss call GitSessionSave()
command! Gsr call GitSessionRestore()

"need to put this in the end so it doesn't get overwritten
"this is needed for dark schemes so that visual mode is still visible!
highlight Visual cterm=reverse ctermbg=NONE

"Use 24-bit (true-color) mode in Vim/Neovim when outside tmux.
"If you're using tmux version 2.2 or later, you can remove the outermost $TMUX check and use tmux's 24-bit color support
"(see < http://sunaku.github.io/tmux-24bit-color.html#usage > for more information.)
if (empty($TMUX))
  if (has("nvim"))
    "For Neovim 0.1.3 and 0.1.4 < https://github.com/neovim/neovim/pull/2198 >
    let $NVIM_TUI_ENABLE_TRUE_COLOR=1
  endif
  "For Neovim > 0.1.5 and Vim > patch 7.4.1799 < https://github.com/vim/vim/commit/61be73bb0f965a895bfb064ea3e55476ac175162 >
  "Based on Vim patch 7.4.1770 (`guicolors` option) < https://github.com/vim/vim/commit/8a633e3427b47286869aa4b96f2bfc1fe65b25cd >
  " < https://github.com/neovim/neovim/wiki/Following-HEAD#20160511 >
  if (has("termguicolors"))
    set termguicolors
  endif
endif
