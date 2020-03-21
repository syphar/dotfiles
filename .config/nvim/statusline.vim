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
  let statusline .= " %{toupper(mode())} │ "
  " git branch
  let statusline .= " %{SetGitBranch(fugitive#head())} │ "
  " Modified status and Filename
  let statusline .= "%f %m %r"

  " Right side items
  " =======================
  let statusline .= "%="

  " Linter Status
  let statusline .= "%{LinterStatus()} │ "
  " Line and Column
  let statusline .= "%2l\/%2c │ "
  " Filetype
  let statusline .= "%{SetFiletype(&filetype)} "

  return statusline
endfunction

function! InactiveLine()
  let statusline=""
  " Left side items
  " =======================
  " mode
  let statusline .= " %{toupper(mode())} │ "
  " Modified status and Filename
  let statusline .= "%f %m %r"

  " Right side items
  " =======================
  let statusline .= "%="

  " Line and Column
  let statusline .= "%2l\/%2c │ "
  " Filetype
  let statusline .= "%{SetFiletype(&filetype)} "

  return statusline
endfunction

function! SimpleLine()
  let statusline=""
  " Left side items
  " =======================
  " mode
  let statusline .= " %{toupper(mode())} │ "
  " Modified status and Filename
  let statusline .= "%f %m %r"

  return statusline
endfunction


" Setup the colors
" - I can't make guibg=None, because then vim will print "^" as a separator.
" - So I just set the background color of the terminal
hi StatusLine          guifg=#bdae93 ctermbg=None guibg=#161616 term=bold gui=bold
hi StatusLineNC        guifg=#bdae93 ctermbg=None guibg=#161616 term=bold gui=bold

" Change statusline automatically
augroup Statusline
  autocmd!
  autocmd WinEnter,BufEnter * setlocal statusline=%!ActiveLine()
  autocmd WinLeave,BufLeave * setlocal statusline=%!InactiveLine()
augroup END


" vim: et ts=2 sts=2 sw=2
