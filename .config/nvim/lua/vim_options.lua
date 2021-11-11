vim.cmd("filetype plugin indent on")
vim.cmd("syntax enable")

-- TODO: not needed any more?
-- https://github.com/nanotee/nvim-lua-guide#vimapinvim_replace_termcodes
-- vim.cmd([[
-- let &t_8f = "\<Esc>[38;2;%lu;%lu;%lum"
-- let &t_8b = "\<Esc>[48;2;%lu;%lu;%lum"
-- set termguicolors
-- " italic fonts
-- let &t_ZH="\e[3m"
-- let &t_ZR="\e[23m"
-- ]])

vim.g.python3_host_prog = vim.fn.expand("$HOME/src/neovim_env/venv/bin/python")

-- enable mouse support
vim.opt.mouse = "a"

-- search files into subfolders
-- provides tab-complete for all files
-- by default we had `/usr/include` in here, which we don't need
vim.opt.path = { ".", "**" }
-- vim wildignore. Used for path autocomplete and `gf`.
vim.opt.wildignore:append({
	"*/.git/", -- I might have to remove this when fugitive has problems
	"*/__pycache__/",
	"*/.direnv/",
	"*/node_modules/",
	"*/.pytest_cache/",
	"*/.mypy_cache/",
	"*/target/", -- rust target directory
	"tags",
})

-- show all options when tab-completing
vim.opt.wildmenu = true

-- global tab/spaces settings
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

-- really write files
vim.opt.fsync = true

vim.opt.clipboard = "unnamed" -- use system clipboard
vim.opt.autoread = true
vim.opt.hidden = true

vim.opt.conceallevel = 2
vim.opt.concealcursor = ""

-- to get an incremental visual feedback when doing the substitude command.
vim.opt.inccommand = "split"

vim.opt.grepprg = "rg --vimgrep --smart-case --follow"

vim.opt.tags:append({ "./tags;/" })

vim.opt.showtabline = 1

vim.opt.showmatch = true

-- auto-adjust splits when window is resized
-- https://vi.stackexchange.com/questions/201/make-panes-resize-when-host-window-is-resized
vim.cmd("autocmd VimResized * wincmd =")

vim.opt.equalalways = true

vim.opt.completeopt = { "menu", "menuone", "noselect" }

vim.opt.foldmethod = "manual"
vim.opt.foldlevelstart = 10 -- open most folds by default
vim.opt.foldnestmax = 10 -- 10 nested fold max
vim.opt.backspace = { "indent", "eol", "start" }

-- mkview and loadview shouldn't do options (which includes keyboard mappings
-- etc)
vim.opt.viewoptions = { "cursor", "slash", "unix" } -- ,folds

-- https://vi.stackexchange.com/questions/16148/slow-vim-escape-from-insert-mode
vim.opt.timeoutlen = 1000
vim.opt.ttimeoutlen = 5

-- better backup, swap and undos storage
vim.opt.backup = true -- make backup files
vim.opt.undofile = true -- persistent undos - undo after you re-open the file
vim.opt.directory = vim.fn.expand("~/.cache/vim/dirs/tmp") -- directory to place swap files in
vim.opt.backupdir = vim.fn.expand("~/.cache/vim/dirs/backups") -- where to put backup files
vim.opt.undodir = vim.fn.expand("~/.cache/vim/dirs/undodir") -- undo directory

-- Redraw only when essential
vim.opt.lazyredraw = true
vim.opt.redrawtime = 10000

-- Just sync some lines of a large file
vim.opt.synmaxcol = 400
vim.cmd("syntax sync minlines=256")

-- Highlight cursor line (slows down)
vim.opt.cursorline = false

-- Set updatetime
vim.opt.updatetime = 2000

-- When scrolling, keep cursor 5 lines away from screen border
vim.opt.scrolloff = 10

vim.opt.incsearch = true -- search as characters are entered
vim.opt.hlsearch = true -- highlight matches
vim.opt.smartcase = true -- smartcase search

-- CTRL-6 should go back to the last file, not netrw/vinegar
vim.g.netrw_altfile = 1
vim.g.netrw_banner = 0 -- disable banner
vim.g.netrw_liststyle = 3 -- tree view
vim.g.netrw_altv = 1 -- open split on the right
