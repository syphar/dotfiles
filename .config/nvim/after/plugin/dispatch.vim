" If you need more control, *g:dispatch_compilers* can
" be set to a dictionary with commands for keys and
" compiler plugins for values.  Use an empty value to
" skip the matched string and try again with the rest of
" the command.
" FIXME : prefix removal ( with poetry run) doesn't work?
let g:dispatch_compilers = { 
    \ 'poetry' : 'pytest',
    \ 'python' : 'pytest'
\ }
