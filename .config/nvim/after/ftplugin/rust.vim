nmap <leader>tr :CargoRun<CR>
nmap <leader>ts :CargoTestAll<CR>
nmap <leader>tf :CargoUnitTestCurrentFile<CR>
nmap <leader>tn :CargoUnitTestFocused<CR>
nmap <leader>tc :VimuxCloseRunner<CR>

source $HOME/.config/nvim/languageserver.vim

let g:ale_fixers.rust = ['rustfmt']
let g:ale_linters.rust = ['rls', 'cargo']

let b:ale_rust_cargo_use_clippy = executable('cargo-clippy')
let b:ale_rust_rustfmt_options = '--edition 2018'
let g:ale_rust_rls_executable = g:LanguageClient_serverCommands.rust[0]
