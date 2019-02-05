" Source a file only if it exists
function! SourceIfExists(path)
    if FileExists(a:path)
        execute 'source' a:path
    endif
endfunction

function! FileExists(path)
    if filereadable(expand(a:path))
        return 1
    else
        return 0
    endif
endfunction

" Source all .vim files in directory
function! SourceAllInDirectory(dirpath)
    for s:fpath in split(globpath(a:dirpath, '*.vim'), '\n')
        execute 'source' s:fpath
    endfor
endfunction
