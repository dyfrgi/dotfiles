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

function! SynStack()
    if !exists("*synstack")
        return
    endif
    echo map(synstack(line('.'), col('.')), 'synIDattr(v:val, "name")')
    echo "hi<" . synIDattr(synID(line("."),col("."),1),"name") . '> trans<'
          \ . synIDattr(synID(line("."),col("."),0),"name") . "> lo<"
          \ . synIDattr(synIDtrans(synID(line("."),col("."),1)),"name") . ">"
endfunc
