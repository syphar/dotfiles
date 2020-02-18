" based on and inspired by:
" https://www.reddit.com/r/vimporn/comments/efjcv0/gruvboxxx/ and
" https://github.com/ginkobab/dots/blob/master/.config/nvim/statusline.vim
" https://www.reddit.com/user/EmpressNoodle
" https://irrellia.github.io/blogs/vim-statusline/

" don't show mode since we want it in the statusline
set noshowmode

" always show status
set laststatus=2

" ':help statusline' is your friend!

function! SetModifiedSymbol(modified) " {{{
    if a:modified == 1
        hi MyStatuslineModifiedBody guifg=#d79921 guibg=#3c3836
    else
        hi MyStatuslineModifiedBody guifg=#928374 guibg=#3c3836
    endif
    return '●'
endfunction

function! SetGitBranch(gitbranch)
  if a:gitbranch == ''
      return 'ø'
  else
      return a:gitbranch
  endif
endfunction

function! SetFiletype(filetype)
  if a:filetype == ''
      return 'ø'
  else
      return a:filetype
  endif
endfunction

function! LinterStatus() abort
    if ale#engine#IsCheckingBuffer(bufnr(''))
        return "\uf110"
    endif

    let l:counts = ale#statusline#Count(bufnr(''))

    if l:counts.total == 0
        return "\uf00c"  " all ok, checkmark
    endif

    let l:all_errors = l:counts.error + l:counts.style_error
    let l:all_non_errors = l:counts.total - l:all_errors

    return printf(
    \   "%d \uf071 %d \uf05e",
    \   all_non_errors,
    \   all_errors
    \)
endfunction

" Statusbar items
" ====================================================================
function! ActiveLine()
  let statusline=""
  " Left side items
  " =======================
  " mode
  let statusline .= "%#MyStatuslineModeBody#\ %{toupper(mode())}%#MySeparator#\ "

  " git branch
  let statusline .= "%#MySeparator#%#MyStatuslineGitBranchBody#\ %{SetGitBranch(fugitive#head())}%#MySeparator#"

  let statusline .= "%#MySeparator#\ "
  " Modified status
  let statusline .= "%#MyStatuslineModifiedBody#%{SetModifiedSymbol(&modified)}\ "
  " Filename
  let statusline .= "%#MyStatuslineFilename#%f"
  let statusline .= "%#MySeparator#\ "

  " Right side items
  " =======================
  let statusline .= "%="
  " Linter Status
  let statusline .= "%#MySeparator#%#MyStatuslineLinterStatusBody#%{LinterStatus()}%#MySeparator#"
  " Padding
  let statusline .= "\ "
  " Line and Column
  let statusline .= "%#MySeparator#%#MyStatuslineLineColBody#%2l\/%2c%#MySeparator#"
  " Padding
  let statusline .= "\ "
  " Current scroll percentage and total lines of the file
  let statusline .= "%#MySeparator#%#MyStatuslinePercentageBody#%P\/\%L%#MySeparator#"
  " Padding
  let statusline .= "\ "
  " Filetype
  let statusline .= "%#MySeparator#%#MyStatuslineFiletypeBody#%{SetFiletype(&filetype)}%#MySeparator#\ "

  return statusline
endfunction

function! InactiveLine()
  let statusline=""
  " Left side items
  " =======================
  " mode
  let statusline .= "%#MyStatuslineFiletypeBody#\ %{toupper(mode())}%#MySeparator#\ "

  let statusline .= "%#MySeparator#\ "
  " Modified status
  let statusline .= "%#MyStatuslineModifiedBody#%{SetModifiedSymbol(&modified)}\ "
  " Filename
  let statusline .= "%#MyStatuslineFilename#%f "
  let statusline .= "%#MySeparator#\ "

  " Right side items
  " =======================
  let statusline .= "%="
  " Line and Column
  let statusline .= "%#MySeparator#%#MyStatuslineLineColBody#%2l\/%2c%#MySeparator#"
  " Padding
  let statusline .= "\ "
  " Current scroll percentage and total lines of the file
  let statusline .= "%#MySeparator#%#MyStatuslinePercentageBody#%P\/\%L%#MySeparator#"
  " Padding
  let statusline .= "\ "
  " Filetype
  let statusline .= "%#MySeparator#%#MyStatuslineFiletypeBody#%{SetFiletype(&filetype)}%#MySeparator#\ "

  return statusline
endfunction

function! SimpleLine()
  let statusline=""
  " Left side items
  " =======================
  " mode
  let statusline .= "%#MyStatuslineFiletypeBody#\ %{toupper(mode())}%#MySeparator#\ "

  let statusline .= "%#MySeparator#\ "
  " Modified status
  let statusline .= "%#MyStatuslineModifiedBody#%{SetModifiedSymbol(&modified)}\ "
  " Filename
  let statusline .= "%#MyStatuslineFilename#%f "
  let statusline .= "%#MySeparator#\ "

  return statusline
endfunction


" Setup the colors
hi StatusLine          guifg=#bdae93 guibg=None
hi StatusLineNC        guifg=#bdae93 guibg=None

hi MySeparator guifg=#3c3836 guibg=None
hi MyStatuslineModeBody  guifg=#689d6a guibg=#3c3836
hi MyStatuslineGitBranchBody  guifg=#458588 guibg=#3c3836
hi MyStatuslineFilename guifg=#bdae93 guibg=#3c3836

hi MyStatuslineLinterStatusBody  guifg=#689d6a guibg=#3c3836
hi MyStatuslineLineColBody  guifg=#458588 guibg=#3c3836
hi MyStatuslinePercentageBody guifg=#d65d0e guibg=#3c3836
hi MyStatuslineFiletypeBody  guifg=#689d6a guibg=#3c3836

" Change statusline automatically
augroup Statusline
  autocmd!
  autocmd WinEnter,BufEnter * setlocal statusline=%!ActiveLine()
  autocmd WinLeave,BufLeave * setlocal statusline=%!InactiveLine()
augroup END


" vim: et ts=2 sts=2 sw=2
