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
nnoremap  <expr> <S-F3> &foldlevel ? 'zM' :'zR'

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

" telescope
nnoremap <C-P> <cmd>lua require('telescope-config').project_files()<cr>
nnoremap <leader>p <cmd>lua require('telescope.builtin').find_files(require('telescope.themes').get_dropdown({find_command={"fd", "--type", "f", "--hidden", "--no-ignore", ".", vim.env.VIRTUAL_ENV}}))<cr>

" ctags_file
nnoremap <leader>f <cmd>Telescope treesitter theme=get_dropdown<cr>
nnoremap <leader>F <cmd>Telescope tags theme=get_dropdown<cr>
nnoremap <leader>m <cmd>Telescope buffers theme=get_dropdown<cr>
nnoremap <leader>h <cmd>Telescope help_tags theme=get_dropdown<cr>
nnoremap <leader>a <cmd>Telescope lsp_code_actions<cr>
" nnoremap <leader>a <cmd>CodeActionMenu<cr>
" vnoremap <leader>a <cmd>CodeActionMenu<cr>

" Limelight for a selected range
nmap <Leader>l <Plug>(Limelight)
xmap <Leader>l <Plug>(Limelight)

nmap <silent> <leader>d <Plug>DashSearch

nmap <leader>rg <cmd>Telescope live_grep theme=get_dropdown<cr>
" find word under cursor in project
nmap <leader>ag <cmd>Telescope grep_string theme=get_dropdown<cr>

" show current file on master
nmap <leader>em :Gedit master:%<CR>

vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

" nvim-compe
inoremap <silent><expr> <C-Space> compe#complete()
inoremap <silent><expr> <CR>      compe#confirm('<CR>')
inoremap <silent><expr> <C-e>     compe#close('<C-e>')
inoremap <silent><expr> <C-f>     compe#scroll({ 'delta': +4 })
inoremap <silent><expr> <C-d>     compe#scroll({ 'delta': -4 })

" deoplete tab-complete
" inoremap <expr><tab> pumvisible() ? "\<C-n>" : "\<TAB>"
" inoremap <expr><s-tab> pumvisible() ? "\<C-p>" : "\<TAB>"

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
