" {{{ (Un-)comment
" by Tobias Schlitt
" See
" http://schlitt.info/applications/blog/index.php?/archives/543-Comfortable-PHP-editing-with-VIM-6.html
" and
" http://svn.toby.phpugdo.de/horde/chora/co.php?f=.vim%2Fftplugin%2Fphp.vim
"
" mfischer, 2008.01.04: replaced // with # comments, it's more portable for
" any kind of scripts (bash, apache, etc.)

func! HashUnComment() range
    let l:paste = &g:paste
    let &g:paste = 0

    let l:line        = a:firstline
    let l:endline     = a:lastline

    while l:line <= l:endline
        if getline (l:line) =~ '^\s*#.*$'
            let l:newline = substitute (getline (l:line), '^\(\s*\)# \(.*\).*$', '\1\2', '')
        else
            let l:newline = substitute (getline (l:line), '^\(\s*\)\(.*\)$', '\1# \2', '')
        endif
        call setline (l:line, l:newline)
        let l:line = l:line + 1
    endwhile

    let &g:paste = l:paste
endfunc

" }}}
