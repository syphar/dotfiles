nmap <leader>tr :term cargo run<CR>
nmap <leader>tn :TestNearest<CR>
nmap <leader>tf :TestFile<CR>
nmap <leader>ts :TestSuite<CR>
nmap <leader>tl :TestLast<CR>

source $HOME/.config/nvim/languageserver.vim

let g:ale_fixers.rust = ['rustfmt']
let g:ale_linters.rust = ['cargo', 'analyzer']

let b:ale_rust_rustfmt_options = '--edition 2018'

let b:ale_rust_cargo_use_clippy = 1
let g:ale_rust_cargo_clippy_options = '-- -D warnings -W clippy::all -W clippy::nursery' "  -W clippy::pedantic'
let g:ale_rust_cargo_check_tests = 1
let g:ale_rust_cargo_check_all_targets = 1
let g:ale_rust_cargo_check_examples = 1

let g:ale_rust_rls_executable = g:LanguageClient_serverCommands.rust[0]
let g:ale_rust_rls_config = {
      \   'rust': {
      \     'clippy_preference': 'on'
      \   }
      \ }


compiler cargo
setlocal makeprg=cargo\ build

let g:rust_fold=1
