let mapleader = ","

" open/close folds with spacebar
nnoremap <space> za
vnoremap <space> zf

" manually create a fold with F9
inoremap <F9> <C-O>za
nnoremap <F9> za
onoremap <F9> <C-C>za
vnoremap <F9> zf

" notional
nnoremap <silent> <c-s> :NV<CR>


" fzf
map <C-P> :GitFiles<CR>
nmap <leader>p :call fzf#vim#files('$VIRTUAL_ENV', fzf#vim#with_preview('down'))<CR>

nmap <leader>t :BTags<CR>
nmap <leader>T :Tags<CR>
nmap <leader>m :Buffers<CR>
nmap <leader>. :History<CR>
nmap <leader>h :Helptags<CR>

vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

function SetLSPShortcuts()
  nnoremap <silent> K :call LanguageClient#textDocument_hover()<CR>
  nnoremap <silent> <F2> :call LanguageClient#textDocument_rename()<CR>
  nmap <leader>gd :call LanguageClient#textDocument_definition()<CR>
  nmap <leader>n :call LanguageClient#textDocument_references()<CR>
endfunction()

augroup LSP
  autocmd!
  autocmd FileType rust,python call SetLSPShortcuts()
augroup END

" deoplete tab-complete
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

function! ToggleLocList()
    for i in range(1, winnr('$'))
        let bnum = winbufnr(i)
        if getbufvar(bnum, '&buftype') == 'quickfix'
            lclose
            return
        endif
    endfor
    lopen
endfunction

nnoremap <F4> :call ToggleLocList()<CR>
nnoremap <F5> :MundoToggle<CR>

map <C-e> :NERDTreeToggle<CR>:NERDTreeMirror<CR>
map <leader>e :NERDTreeFind<CR>
nmap <leader>nt :NERDTreeFind<CR>

nnoremap <silent> <F3> :Vista!!<CR>

" move between tabs with cmd+number
map <D-1> :tabn 1<CR>
map <D-2> :tabn 2<CR>
map <D-3> :tabn 3<CR>
map <D-4> :tabn 4<CR>
map <D-5> :tabn 5<CR>
map <D-6> :tabn 6<CR>
map <D-7> :tabn 7<CR>
map <D-8> :tabn 8<CR>
map <D-9> :tabn 9<CR>

map! <D-1> <C-O>:tabn 1<CR>
map! <D-2> <C-O>:tabn 2<CR>
map! <D-3> <C-O>:tabn 3<CR>
map! <D-4> <C-O>:tabn 4<CR>
map! <D-5> <C-O>:tabn 5<CR>
map! <D-6> <C-O>:tabn 6<CR>
map! <D-7> <C-O>:tabn 7<CR>
map! <D-8> <C-O>:tabn 8<CR>
map! <D-9> <C-O>:tabn 9<CR>

" Move around splits with <c-hjkl>
nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

" Visual shifting (does not exit Visual mode)
vnoremap < <gv
vnoremap > >gv

" type ,p to insert breakpoint. ^[ is at the end.  Insert with ctrl v and then esc
" (the github web gui doesn't display control characters, but it is there)
nnoremap <leader>b oimport pdb;pdb.set_trace()

" common typos .. (W, Wq WQ)
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

" vim: et ts=2 sts=2 sw=2
