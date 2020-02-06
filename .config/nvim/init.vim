" Required:
set runtimepath+=$HOME/.cache/dein/repos/github.com/Shougo/dein.vim

" Required:
if dein#load_state('$HOME/.cache/dein')
  call dein#begin('$HOME/.cache/dein')

  " Let dein manage dein
  " Required:
  call dein#add('$HOME/.cache/dein/repos/github.com/Shougo/dein.vim')
  call dein#add('haya14busa/dein-command.vim')

  " interface
  call dein#add('chriskempson/base16-vim')

  " for statusline
  call dein#add('itchyny/lightline.vim')
  call dein#add('maximbaz/lightline-ale')

  " general plugins
  call dein#add('vim-scripts/restore_view.vim') " safe/restore folds and position
  call dein#add('vim-scripts/LargeFile')  " disable stuff for big files for performance
  call dein#add('terryma/vim-expand-region') " intelligently expand selection with V / CTRL+V
  call dein#add('simnalamburt/vim-mundo')  " visual undo tree
  call dein#add('christoomey/vim-tmux-navigator')  " nativate between vim and tmux panes
  call dein#add('tmux-plugins/vim-tmux-focus-events')
  call dein#add('benmills/vimux') " run commands in other tmux pane
  call dein#add('alok/notational-fzf-vim', {'on_cmd': ['NV']})  " fzf markdown notes

  " file management / search
  call dein#add('tpope/vim-vinegar') " simple 'dig through current folder'  on the - key

  if isdirectory('/usr/local/opt/fzf')
    call dein#add('/usr/local/opt/fzf')
  end


  call dein#add('junegunn/fzf.vim')
  call dein#add('airblade/vim-rooter')  " automatically set root directory to project directory
  " call dein#add('meain/vim-automkdir')  " autocreate missing directories on save

  " GIT integration
  call dein#add('tpope/vim-fugitive') " git commands
  call dein#add('tpope/vim-rhubarb')  " fugitive and github integration
  call dein#add('mhinz/vim-signify')  " git changes in sign column
  call dein#add('junegunn/gv.vim')  " nice git log


  " distraction free writing
  call dein#add('junegunn/goyo.vim')
  call dein#add('junegunn/limelight.vim')

  " specific file types
  call dein#add('chrisbra/csv.vim', {'on_ft': ['csv']})
  call dein#add('cespare/vim-toml', {'on_ft': ['toml']})
  call dein#add('elzr/vim-json', { 'on_ft': ['json'] })
  call dein#add('godlygeek/tabular', { 'on_ft': ['md', 'markdown'] })
  call dein#add('plasticboy/vim-markdown', { 'on_ft': ['md', 'markdown'] })
  call dein#add('jtdowney/vimux-cargo', {'on_ft': ['rust']})

  call dein#add('raimon49/requirements.txt.vim', { 'on_ft': ['requirements'] })
  call dein#add('Shougo/neco-vim', {'on_ft': ['vim']})  " autocomplete for viml
  call dein#add('tmux-plugins/vim-tmux') " tmux config filetype
  call dein#add('vim-scripts/applescript.vim', {'on_ft': ['applescript']})

  " generic software dev stuff
  call dein#add('Yggdroot/indentLine') " indent helper lines
  call dein#add('Shougo/echodoc.vim') " Show signature
  call dein#add('rhysd/committia.vim') " Better COMMIT_EDITMSG editing
  call dein#add('dense-analysis/ale') " linting / fixing
  call dein#add('tpope/vim-commentary') " comment/uncomment on gcc
  call dein#add('editorconfig/editorconfig-vim') " read editorconfig and configure vim
  call dein#add('liuchengxu/vista.vim', {'on_cmd': ['Vista!!', 'Vista']}) " tagbar
  call dein#add('wellle/context.vim', {'on_ft': ['python', 'rust']})  " show context of things outside of screen. old: 'rev': '23-nvim-no-redraw',
  call dein#add('direnv/direnv.vim') " read direnv for vim env
  call dein#add('janko/vim-test', {'on_ft': ['python', 'rust']}) " simple test running
  call dein#add('tpope/vim-projectionist', {'on_ft': ['python', 'rust']}) " :A alternate command to switch between tests and implementation

  call dein#add('Shougo/deoplete.nvim', {'on_i': 1}) " autocomplete
  call dein#add('tbodt/deoplete-tabnine', { 'on_i': 1, 'build': './install.sh' }) " ML-based autocomplete

  call dein#add('autozimu/LanguageClient-neovim', {
     \ 'rev': 'next',
     \ 'build': 'bash install.sh',
     \ 'on_ft': ['python', 'rust'],
     \ })

  " python stuff
  call dein#add('Vimjas/vim-python-pep8-indent', {'on_ft': ['python']})
  call dein#add('jeetsukumaran/vim-pythonsense', {'on_ft': ['python']})

  " Required:
  call dein#end()
  call dein#save_state()
endif


" If you want to install not installed plugins on startup.
if dein#check_install()
  call dein#install()
endif

"End dein Scripts-------------------------
"

source ~/.config/nvim/vim_config.vim
source ~/.config/nvim/plugin_config.vim
source ~/.config/nvim/statusline.vim
source ~/.config/nvim/keyboard.vim

" vim: et ts=2 sts=2 sw=2
