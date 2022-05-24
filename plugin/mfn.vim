" ~~~~~~~~~~~~~~~~~~ General ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" Über-Vim-Config, config for Linux/Gui/Windows, mainly focused on PHP
" development.
" Author: Markus Fischer <markus@fischer.name>

" We want colors and we want them now!
syntax on
" Always start higlighting from start of file. This may be a bit slower at
" start up but gives accurate highlighting (which I think is more important)
syntax sync fromstart
" We generaly work on dark backgrounds
set background=dark
" Show the command in status line
set showcmd
" Show matching starting/ending brackets
set showmatch
" Show position of cursor
set ruler
" Highlighted searched terms
set hlsearch
" Make backspace work over indenting, end of lines and start of lines
set bs=2
" Using the shift commands < and >, shift for four spaces, too
set shiftwidth=4
" Use spaces instead of tabs
set expandtab
" A tab stands for four spaces
set tabstop=4
" Treat spaces like tabs
set softtabstop=4
" Show line numbers on the left
set number
" Set maximum width of text, however don't enfore it globally, only file
" specific
set textwidth=80
set formatoptions-=t
" Use more readable characters when tyring to to space tabs and spaces instead
" of the default ones. Activate view with 'list', turn off with 'nolist'
set listchars=tab:»·,trail:·
if version >= 700
    " Visualize line on which the cursor is 
    " Unfortunately this can be a real performance hog even on small files under
    " certain instances (probably in conjunction with high desktop resolution),
    " see also http://vim.wikia.com/wiki/Highlight_current_line
    " set cursorline
endif
" Always show a status line, even if only one window
set laststatus=2
" Indicate jump out of the screen this number of lines before the screen ends
set scrolloff=5
" Number of columns to scroll left/right
set sidescroll=1
" How many columns before the end of window is reached when starting scrolling
set sidescrolloff=1
" When using vsplit, always split to the right, i.e. new file/content appears
" on the right
set splitright
" Default to unix fileformat. If you open a file with EOL "dos" it should
" switch properly to dos, too.
set fileformat=unix
" Finally, only and always use unix by default. If you want to DOS line
" endigs, think again. If you still want them, manually set it with 'set " ff=dos'
set fileformats=unix,dos
" Autoindent by default
set autoindent
" Remember in which line the cursor was last in a file and re-position it
" there upon opening the file again.
au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")
    \| exe "normal g'\"" | endif 

" Custom mode when matching for wildcard files when opening new files with
" e.g. split/vsplit
set wildmode=longest:full
" Use enhanced enhance completion mode
set wildmenu
" Don't wrap lines
set nowrap
" Enable filetype detection
filetype plugin indent on

" Use CTRL-c when visually selecting allows to comment in/out the block at
" once
vnoremap <C-c> :call HashUnComment()<CR>
" <Tab> in normal mode move to next window
nmap <Tab> <C-W>w
" <Tab> and shift <Tab> in visual mode shift the area right/left with
" shiftwidth spaces
vmap <Tab> >
vmap <S-Tab> <
" When using visual selection, move around even in places there's no
" character. This is possible for all modes, but probably less useful.
set virtualedit=block
" Make control tab behave like control pageup and control shift tab like
" control pagedown => navigate between tabs
nmap <C-Tab> <C-PageDown>
nmap <C-S-Tab> <C-PageUp>
vmap <C-Tab> <C-PageDown>
vmap <C-S-Tab> <C-PageUp>
" Increase history for commands entered
set history=256
" Vim Undo limitation
" Vim has currently a limitation that any change within a single
" insert-operation (be it 10 or 1000 characters) will also be undo'ed after
" leaving insert mode and doing the undo operation. With the workaround from
" http://stackoverflow.com/questions/2895551/how-do-i-get-fine-grained-undo-in-vim/4360415#4360415
" it's possible to start a new undo sequence by mapping it to keys.
" For now we will use Space, Return and Tab to all create new undo sequences.
inoremap <Space> <Space><C-g>u
inoremap <Return> <Return><C-g>u
inoremap <Tab> <Tab><C-g>u


" ~~~~~~~~~~~~~~~~~~ PHP ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" Define a highlight group for lines which I consider too long
hi def PhpLineTooLong ctermbg=1 guibg=#64005d
" Use this 'line too long' highlighting only on PHP files
" autocmd BufRead *.php match PhpLineTooLong /\%>80v.\+/
" Enable automatic line breaking and set default 'make' for PHP
autocmd FileType php setlocal shiftwidth=4 tabstop=4 softtabstop=4 expandtab formatoptions=tqrocb
autocmd BufEnter *.php set makeprg=php\ -l\ % errorformat=%m\ in\ %f\ on\ line\ %l
" Enable PHP specific indenting
let PHP_autoformatcomment=0
let PHP_vintage_case_default_indent=1
" Sync PHP code highlighting from start
let php_sync_method=0
" In PHP, use folding based on PHP code
" Currently doesn't work with PHP_default_indenting. In my view proper
" automatic indenting outweights class/function folding for now.
" let php_folding=1

" When joining lines in a comment, remove the comment character.
autocmd BufRead,BufNewFile *.php nmap <buffer> J :call Mfn_PHP_JoinWithoutCommentChar()<CR>
function! Mfn_PHP_JoinWithoutCommentChar()
    " Only perform our custom join when the current and next line is a comment
    if getline('.') =~ '^\s*\(/\*\+\|\*\|#\|//\)' && getline(line('.')+1) =~ '^\s*\(\*\|#\|//\)'
        " before doing the join, remove trailing whitespaces on first line
        call setline('.', substitute(getline('.'), '\s*$', '', ''))
        if getline('.') =~ '^\s*//'
            normal! J3x
        else
            normal! J2x
        endif
    else
        normal! J
    endif
endfunc

" If doing a diff. Upon writing changes to file, automatically update the
" differences; source
" http://vim.wikia.com/wiki/Update_the_diff_view_automatically
autocmd BufWritePost * if &diff == 1 | diffupdate | endif

" Associate .md by default with Markdown, not Modula2
autocmd BufNewFile,BufReadPost *.md set filetype=markdown

" ~~~~~~~~~~~~~~~~~~ Shell ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
autocmd FileType sh setlocal shiftwidth=2 tabstop=2 softtabstop=2 formatoptions+=t

" ~~~~~~~~~~~~~~~~~~ Ruby ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" Use 2 instead of 4 spaces for tabs; per general Ruby convention; enforce
" textwidth
autocmd FileType ruby setlocal shiftwidth=2 tabstop=2 softtabstop=2 formatoptions+=t list
autocmd BufNewFile,BufRead *.ru set filetype=ruby
autocmd BufEnter *.rb set makeprg=ruby\ -wc\ % errorformat=%f:%l:\ %m
" I prefer ruby syntax to be highlighted this way
let ruby_operators=1
let ruby_minlines=100

" ~~~~~~~~~~~~~~~~~~ Crytsal Language ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" Use 2 instead of 4 spaces for tabs; per general crystal-lang convention; enforce
" textwidth
autocmd FileType crystal setlocal shiftwidth=2 tabstop=2 softtabstop=2 formatoptions+=t list

" ~~~~~~~~~~~~~~~~~~ Misc files ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
" When editing a build.xml file, :make refers to phing
autocmd BufEnter build.xml set makeprg=phing errorformat=%f:%l:%c

" ~~~~~~~~~~~~~~~~~~ Statusline ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
runtime mfn-status.vim

" ~~~~~~~~~~~~~~~~~~ Menu ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
runtime mfn-menu.vim

" ~~~~~~~~~~~~~~~~~~ GUI ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
if has('gui_macvim')
    " prevents loading the macvim colorscheme; loads default instead
    " Otherwise these clashes with the whole gui color initialization and
    " the desire for background=dark
    let macvim_skip_colorscheme=1
endif
if has('gui_running')
    " Explicitely specify default colors for GUI
    highlight normal guifg=#00f900 guibg=#00005d
    " The standard background color for folds is some gray which disturbs my
    " visuals. Use a slighty different color then the current normal guibg
    highlight Folded guibg=#000050
    " Automatically put text select with VISUAL mode into the windows
    " clipboard
    set guioptions+=a
    " Provide bottom/horizontal scrollbar
    set guioptions+=b
    " Don't show GUI toolbar
    set guioptions-=T
    " When using the mksession command, also store the resized window and
    " window position information
    set sessionoptions+=resize,winpos
    " Copy whole file into windows clipboard with CTRL-a
    noremap <C-A> 1GVG"*y
    " Always show that we can have tabs. Posing :)
    set showtabline=2
    " Use a different background color for current CursorLine in GUI
    highlight CursorLine guibg=#0000AA
    " remember window size and (if possible) position
    autocmd! GUIEnter * if filereadable($HOME . "/gvim_win_pos_size.vim") | source $HOME/gvim_win_pos_size.vim | endif
    function! Mfn_SaveSizes()
            let x0 = getwinposx()
            let y0 = getwinposy()
            let x1 = &columns
            let y1 = &lines
            redir! > $HOME/gvim_win_pos_size.vim
            echo 'if exists(":winpos") == 2'
            echo "\t:winpos" x0 y0
            echo "endif"
            echo "set columns=" . x1
            echo "set lines=" . y1
            redir END
    endfunction
    au VimLeave * if has("gui_running") | silent call Mfn_SaveSizes() | endif 
endif
if has('gui_macvim')
    " slightly more blueish background on osx
    highlight normal guibg=#000d62
    " current preferred font/size
    set guifont=Monaco:h15
    set linespace=1
    " Enable for mac; but can be a performance hog
    set cursorline
end
if has('win32')
    " Sets the behavior for mouse and selection
    behave xterm
    " Automatically reload _vimrc when modifying
    autocmd! BufWritePost _vimrc source %
    " Store backup file sin system temp directory, not in the current
    " directory
    set backupdir=$TMP
else
    " Automatically reload .vimrc when modifying
    autocmd! BufWritePost .vimrc source %
endif

" Use CTRL-a on visually selected block to apply formatting of PHP variables
" and arrays. Moved this definition *after* we defined <C-a> in normal mode
" gui, because normal mode overrides it.
vnoremap <C-a> :call PhpAlign()<CR>
