lua require('impatient')
lua require('packer_compiled') 

lua require('plugins')
lua require'lsp_config'.lsp_setup()
lua require'lsp_config'.cmp_setup()
source ~/.config/nvim/vim_config.vim
source ~/.config/nvim/statusline.vim
source ~/.config/nvim/keyboard.vim

" vim: et ts=2 sts=2 sw=2
