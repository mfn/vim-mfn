if version >= 700
    function! Mfn_Buffer_Recode(from, to)
        if &encoding != a:from
            echoerr "Current file is encoded in " . &encoding . ", can't convert from " . a:from . " to " . a:to . " here"
            return
        endif
        let i = 1
        for line in getline(1, '$')
            call setline(i, iconv(line, a:from, a:to))
            let i = i + 1
        endfor
        exec 'set encoding=' . a:to
    endfunction
    menu &Mfn.&latin1\ to\ utf-8 : call Mfn_Buffer_Recode('latin1', 'utf-8')<CR>
    menu &Mfn.&utf-8\ to\ latin1 : call Mfn_Buffer_Recode('utf-8', 'latin1')<CR>
endif
