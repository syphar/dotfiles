nmap <leader>tr :term cargo run<CR>
nmap <leader>tn :TestNearest<CR>
nmap <leader>tf :TestFile<CR>
nmap <leader>ts :TestSuite<CR>
nmap <leader>tl :TestLast<CR>

source $HOME/.config/nvim/languageserver.vim

let g:ale_fixers.rust = ['rustfmt']
let g:ale_linters.rust = ['rls', 'cargo']

let b:ale_rust_cargo_use_clippy = executable('cargo-clippy')
let b:ale_rust_rustfmt_options = '--edition 2018'
let g:ale_rust_rls_executable = g:LanguageClient_serverCommands.rust[0]


compiler cargo
setlocal makeprg=cargo
