" Callback function for various statusline information
function! Mfn_Status_Encoding()
    return &encoding
endfunction
function! Mfn_Status_Fileformat()
    return &fileformat
endfunction
" from the cream project
function! Mfn_Status_Bufsize()
    let bufsize = line2byte(line("$") + 1) - 1
    " prevent negative numbers (non-existant buffers)
    if bufsize < 0
        let bufsize = 0
    endif
    " add commas
    let remain = bufsize
    let bufsize = ""
    while strlen(remain) > 3
        let bufsize = "," . strpart(remain, strlen(remain) - 3) . bufsize
        let remain = strpart(remain, 0, strlen(remain) - 3)
    endwhile
    let bufsize = remain . bufsize
    " too bad we can't use "¿" (nr2char(1068)) :)
    let char = "b"
    return bufsize . char
endfunction
function! Mfn_Status_Tabstop()
    return &tabstop
endfunction
function! Mfn_Status_Textwidth()
    return &textwidth
endfunction
function! Mfn_Status_Autoindent()
    if &autoindent
        return 'ai'
    else
        return 'noai'
    endif
endfunction
function! Mfn_Status_FoAutowrap()
    if &formatoptions =~# 't'
        return 'awrap '
    endif
    return ' '
endfunction

set statusline=%t\ %m\ %r\ [%{Mfn_Status_Encoding()}]\ [%{Mfn_Status_Fileformat()}]\ %y\ %{Mfn_Status_Bufsize()}%=%{Mfn_Status_Autoindent()}\ ts=%{Mfn_Status_Tabstop()}\ tw=%{Mfn_Status_Textwidth()}\ %{Mfn_Status_FoAutowrap()}%o\ %3b\ 0x%B\ [%l/%L\ :\ %c%V]\ %p%%
