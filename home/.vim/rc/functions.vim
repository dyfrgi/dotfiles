" Source a file only if it exists
function! SourceIfExists(path)
    if filereadable(expand(a:path))
        execute 'source' a:path
    endif
endfunction

" Source all .vim files in directory
function! SourceAllInDirectory(dirpath)
    for s:fpath in split(globpath(a:dirpath, '*.vim'), '\n')
        execute 'source' s:fpath
    endfor
endfunction
