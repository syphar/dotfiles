let mapleader = ','

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

nnoremap <leader>f <cmd>Telescope treesitter theme=get_dropdown<cr>
nnoremap <leader>F <cmd>Telescope tags theme=get_dropdown<cr>
nnoremap <leader>m <cmd>Telescope buffers theme=get_dropdown<cr>
nnoremap <leader>ht <cmd>Telescope help_tags theme=get_dropdown<cr>
nnoremap <leader>a <cmd>Telescope lsp_code_actions<cr>
nnoremap <leader>rg <cmd>Telescope live_grep theme=get_dropdown<cr>
nnoremap <leader>ag <cmd>Telescope grep_string theme=get_dropdown<cr>

nmap <silent> <leader>d <Plug>DashSearch

" show current file on master
nmap <leader>em :Gedit master:%<CR>

vmap v <Plug>(expand_region_expand)
vmap <C-v> <Plug>(expand_region_shrink)

nnoremap <F3> <cmd>TroubleToggle lsp_document_diagnostics<cr>
nnoremap <F4> <cmd>TroubleToggle lsp_workspace_diagnostics<cr>
nnoremap <F9> :cprevious<CR>
nnoremap <F10> :cnext<CR>


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
