" Required:
set runtimepath+=$HOME/.cache/dein/repos/github.com/Shougo/dein.vim

" Required:
if dein#load_state('$HOME/.cache/dein')
  call dein#begin('$HOME/.cache/dein')

  " Let dein manage dein
  " Required:
  call dein#add('$HOME/.cache/dein/repos/github.com/Shougo/dein.vim')
  call dein#add('haya14busa/dein-command.vim')

  " some dependencies for several plugins
  call dein#add('nvim-lua/popup.nvim')
  call dein#add('nvim-lua/plenary.nvim')

  " interface
  " call dein#add('projekt0n/github-nvim-theme', {'rev': '8e1cdd2'})
  call dein#add('projekt0n/github-nvim-theme')
  call dein#add('itchyny/lightline.vim')
  call dein#add('josa42/nvim-lightline-lsp')
  call dein#add('drzel/vim-line-no-indicator')

  " general plugins
  call dein#add('zhimsel/vim-stay') " save/restore sessions properly
  call dein#add('christoomey/vim-tmux-navigator')  " nativate between vim and tmux panes
  call dein#add('tmux-plugins/vim-tmux-focus-events')
  call dein#add('RyanMillerC/better-vim-tmux-resizer') " easily resize vim and tmux panes through meta+hjkl
  call dein#add('terryma/vim-expand-region') " intelligently expand selection with V / CTRL+V
  call dein#add('machakann/vim-highlightedyank') " highlight yanked area

  " treesitter base
  call dein#add('nvim-treesitter/nvim-treesitter')
  call dein#add('nvim-treesitter/playground')

  " file management / search
  call dein#add('tpope/vim-vinegar') " simple 'dig through current folder'  on the - key
  call dein#add('airblade/vim-rooter')  " automatically set root directory to project directory

  " telescope
  call dein#add('nvim-telescope/telescope.nvim', {'rev': 'f1a27baf279976845eb43c65e99a71d7f0f92d02'})
  " call dein#add('nvim-telescope/telescope.nvim')
  call dein#add('nvim-telescope/telescope-fzf-native.nvim', {'build': 'make'})

  " GIT integration
  call dein#add('tpope/vim-fugitive') " git commands
  call dein#add('tpope/vim-rhubarb')  " fugitive and github integration
  call dein#add('lewis6991/gitsigns.nvim')  " git changes in sign column

  " specific file types
  call dein#add('cespare/vim-toml', {'on_ft': ['toml']})
  call dein#add('elzr/vim-json', { 'on_ft': ['json'] })
  call dein#add('plasticboy/vim-markdown', { 'on_ft': ['md', 'markdown'] })
  call dein#add('raimon49/requirements.txt.vim', { 'on_ft': ['requirements'] })
  call dein#add('rust-lang/rust.vim', {'on_ft': ['rust']}) " rust
  call dein#add('simrat39/rust-tools.nvim')
  call dein#add('dag/vim-fish', {'on_ft': ['fish']}) " fish

  " generic software dev stuff
  let dev_types = ['python', 'rust', 'yaml', 'json', 'vim']
  call dein#add('kyazdani42/nvim-web-devicons')
  call dein#add('folke/trouble.nvim')
  call dein#add('kosayoda/nvim-lightbulb')
  call dein#add('weilbith/nvim-code-action-menu')

  call dein#add('rizzatti/dash.vim')
  call dein#add('rhysd/committia.vim') " Better COMMIT_EDITMSG editing
  call dein#add('tpope/vim-commentary') " comment/uncomment on gcc
  call dein#add('editorconfig/editorconfig-vim') " read editorconfig and configure vim
  call dein#add('romgrk/nvim-treesitter-context') " show context based on treesitter
  call dein#add('direnv/direnv.vim') " read direnv for vim env
  call dein#add('janko/vim-test', {'on_ft': dev_types}) " simple test running
  call dein#add('tpope/vim-dispatch', {'on_ft': dev_types})
  call dein#add('tpope/vim-projectionist', {'on_ft': dev_types}) " :A alternate command to switch between tests and implementation
  call dein#add('chaoren/vim-wordmotion')
  call dein#add('vim-scripts/argtextobj.vim')
  call dein#add('michaeljsmith/vim-indent-object')

  call dein#add('neovim/nvim-lspconfig') " LSP server configs
  call dein#add('ray-x/lsp_signature.nvim') " show function signatures
  call dein#add('hrsh7th/nvim-compe')  " completion
  call dein#add('tzachar/compe-tabnine', {'build': './install.sh'}) "ML-based automomplete

  " python stuff
  call dein#add('Vimjas/vim-python-pep8-indent', {'on_ft': ['python']})
  call dein#add('jeetsukumaran/vim-pythonsense', {'on_ft': ['python']})
  call dein#add('5long/pytest-vim-compiler', {'on_ft': ['python']})

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
