let mapleader = ","

" turn off search highlight
nnoremap <leader><space> :nohlsearch<CR>

" Y should be yank until the end of the line
" see :help Y
map Y y$


" open/close folds with spacebar
nnoremap <space> za
vnoremap <space> zf

" fold/unfold all with shift-F3
" nnoremap <expr> <F3> &foldlevel ? 'zM' :'zR'
" fold to see classes and methods
" noremap <S-F3> :set foldlevel=1<CR>
nnoremap  <S-F3> &foldlevel ? 'zM' :'zR'

" notional
nnoremap <silent> <c-s> :NV<CR>

" don't count {} as jumps for the jumplist
" see https://superuser.com/a/836924/1124707
nnoremap <silent> } :<C-u>execute "keepjumps norm! " . v:count1 . "}"<CR>
nnoremap <silent> { :<C-u>execute "keepjumps norm! " . v:count1 . "{"<CR>

" copy to system clipboard separately
" xnoremap <C-c> "+y
" nnoremap <silent> cp "+y
" nnoremap <silent> cpp "+yy

" fzf
map <C-P> :GitFiles<CR>
nmap <leader>p :call fzf#vim#files('$VIRTUAL_ENV', fzf#vim#with_preview('right'))<CR>

nmap <leader>f :BTags<CR>
nmap <leader>F :Tags<CR>
nmap <leader>m :Buffers<CR>
nmap <leader>h :Helptags<CR>

nmap <silent> <leader>d <Plug>DashSearch

" run Rg with word under cursor or selection
nmap <leader>ag "zyiW:exe "Rg ".@z.""<CR>
vnoremap <leader>ag "zy:exe "Rg ".@z.""<CR>


vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

" deoplete tab-complete
inoremap <expr><tab> pumvisible() ? "\<c-n>" : "\<tab>"

function! GetBufferList()
  redir =>buflist
  silent! ls!
  redir END
  return buflist
endfunction

function! ToggleList(bufname, pfx)
  let buflist = GetBufferList()
  for bufnum in map(filter(split(buflist, '\n'), 'v:val =~ "'.a:bufname.'"'), 'str2nr(matchstr(v:val, "\\d\\+"))')
    if bufwinnr(bufnum) != -1
      exec(a:pfx.'close')
      return
    endif
  endfor
  if a:pfx == 'l' && len(getloclist(0)) == 0
      echohl ErrorMsg
      echo "Location List is Empty."
      return
  endif
  let winnr = winnr()
  exec(a:pfx.'open 30')
  if winnr() != winnr
    wincmd p
  endif
endfunction

nnoremap <F3> :Vista!!<CR>
nnoremap <F4> :call ToggleList("Location List", 'l')<CR>
nnoremap <F5> :call ToggleList("Quickfix List", 'c')<CR>
nnoremap <F9> :cprevious<CR>
nnoremap <F10> :cnext<CR>


" move between tabs with cmd+number. Not used in tmux, only when running a gui
" vim
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

" Visual shifting (does not exit Visual mode)
vnoremap < <gv
vnoremap > >gv

" common typos .. (W, Wq WQ)
cnoreabbrev E e
cnoreabbrev W w
cnoreabbrev WQ wq
cnoreabbrev Wq wq
cnoreabbrev Wa wa
cnoreabbrev WA wa
cnoreabbrev Q q
cnoreabbrev QA qa
cnoreabbrev Qa qa
cnoreabbrev Vsp vsp

" vim: et ts=2 sts=2 sw=2
