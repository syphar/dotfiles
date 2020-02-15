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

function! SetFiletype(filetype)
  if a:filetype == ''
      return '-'
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
  let statusline .= "%#MyStatuslineFiletypeBody#\ %{toupper(mode())}%#MyStatuslineFiletype#\ "

  " git branch
  let statusline .= "%#MyStatuslineLineCol#%#MyStatuslineLineColBody#\ %{fugitive#head()}%#MyStatuslineLineCol#"

  let statusline .= "%#MyStatuslineAccent#\ "
  " Modified statu"s
  let statusline .= "%#MyStatuslineModifiedBody#%{SetModifiedSymbol(&modified)}\ "
  " Filename
  let statusline .= "%#MyStatuslineFilename#%f"
  let statusline .= "%#MyStatuslineSeparator#\ "

  " Right side ite"ms
  " =============="=========
  let statusline .= "%="
  " Linter Status
  let statusline .= "%#MyStatuslineLineCol#%#MyStatuslineFiletypeBody#%{LinterStatus()}%#MyStatuslineLineCol#"
  " Padding
  let statusline .= "\ "
  " Line and Colum"n
  let statusline .= "%#MyStatuslineLineCol#%#MyStatuslineLineColBody#%2l\/%2c%#MyStatuslineLineCol#"
  " Padding
  let statusline .= "\ "
  " Current scroll" percentage and total lines of the file
  let statusline .= "%#MyStatuslinePercentage#%#MyStatuslinePercentageBody#%P\/\%L%#MyStatuslinePercentage#"
  " Padding
  let statusline .= "\ "
  " Filetype
  let statusline .= "%#MyStatuslineFiletype#%#MyStatuslineFiletypeBody#%{SetFiletype(&filetype)}%#MyStatuslineFiletype#\ "

  return statusline
endfunction

function! InactiveLine()
  let statusline=""
  " Left side items
  " =======================
  " mode
  let statusline .= "%#MyStatuslineFiletypeBody#\ %{toupper(mode())}%#MyStatuslineFiletype#\ "

  let statusline .= "%#MyStatuslineAccent#\ "
  " Modified status
  let statusline .= "%#MyStatuslineModifiedBody#%{SetModifiedSymbol(&modified)}\ "
  " Filename
  let statusline .= "%#MyStatuslineFilename#%f "
  let statusline .= "%#MyStatuslineSeparator#\ "

  " Right side items
  " =============="=========
  let statusline .= "%="
  " Line and Column
  let statusline .= "%#MyStatuslineLineCol#%#MyStatuslineLineColBody#%2l\/%2c%#MyStatuslineLineCol#"
  " Padding
  let statusline .= "\ "
  " Current scroll percentage and total lines of the file
  let statusline .= "%#MyStatuslinePercentage#%#MyStatuslinePercentageBody#%P\/\%L%#MyStatuslinePercentage#"
  " Padding
  let statusline .= "\ "
  " Filetype
  let statusline .= "%#MyStatuslineFiletype#%#MyStatuslineFiletypeBody#%{SetFiletype(&filetype)}%#MyStatuslineFiletype#\ "

  return statusline
endfunction


" Setup the colors
hi StatusLine          guifg=#282828 guibg=#98971a
hi StatusLineNC        guifg=#282828 guibg=#98971a

hi mystatuslineseparator guifg=#3c3836 guibg=None

hi MyStatuslineModified guifg=#3c3836 guibg=None

hi MyStatuslineFiletype guifg=#3c3836 guibg=None
hi MyStatuslineFiletypeBody ctermfg=5 cterm=italic ctermbg=0  guifg=#689d6a guibg=#3c3836  gui=italic

hi MyStatuslinePercentageBody guifg=#d65d0e guibg=#3c3836
hi MyStatuslinePercentage guibg=None guifg=#3c3836

hi MyStatuslineLineCol ctermfg=0 cterm=NONE ctermbg=NONE guifg=#3c3836 guibg=None
hi MyStatuslineLineColBody ctermbg=0 cterm=none ctermfg=2  guifg=#458588 guibg=#3c3836

hi MyStatuslineAccent  guifg=#3c3836 gui=bold
hi MyStatuslineFilename guifg=#bdae93 guibg=#3c3836
hi MyStatuslineAccentBody guifg=#bdae93  guibg=#3c3836

" Change statusline automatically
augroup Statusline
  autocmd!
  autocmd WinEnter,BufEnter * setlocal statusline=%!ActiveLine()
  autocmd WinLeave,BufLeave * setlocal statusline=%!InactiveLine()
augroup END


" vim: et ts=2 sts=2 sw=2
