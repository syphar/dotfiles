" let g:dash_map = {
"         \ 'java' : 'android'
"         \ }

" require("dash").setup({
" 	search_engine = "google",
" 	debounce = vim.opt.updatetime:get(),
" 	file_type_keywords = {
" 		python = { "python3", "django" },
" 	},
" })

" vim.keymap.set("n", "<leader>k", ":DashWord<CR>")
nmap <silent> <leader>k <Plug>DashSearch
