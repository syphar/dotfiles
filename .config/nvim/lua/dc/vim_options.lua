-- disable some default plugins
vim.g.loaded_gzip = 1
vim.g.loaded_tar = 1
vim.g.loaded_tarPlugin = 1
vim.g.loaded_zip = 1
vim.g.loaded_zipPlugin = 1

vim.g.loaded_getscript = 1
vim.g.loaded_getscriptPlugin = 1
vim.g.loaded_vimball = 1
vim.g.loaded_vimballPlugin = 1

vim.g.loaded_2html_plugin = 1
vim.g.loaded_logiPat = 1
vim.g.loaded_rrhelper = 1

-- vim.g.loaded_netrw = 1 -- this is needed for :GBrowse
-- vim.g.loaded_netrwPlugin = 1
-- vim.g.loaded_netrwSettings = 1
-- vim.g.loaded_netrwFileHandlers = 1

vim.cmd("filetype plugin indent on")
vim.cmd("syntax enable")
vim.o.termguicolors = true

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

-- default tab/spaces settings
vim.opt.expandtab = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4

-- really write files
vim.opt.fsync = true

vim.opt.clipboard = "unnamedplus" -- use system clipboard
vim.opt.autoread = true
vim.opt.hidden = true

vim.opt.conceallevel = 0
vim.opt.concealcursor = ""

-- to get an incremental visual feedback when doing the substitude command.
vim.opt.inccommand = "split"

-- use ripgrep for :grep
vim.opt.grepprg = "rg --vimgrep --smart-case --follow --hidden"

vim.opt.tags:append({ "./tags;/" })

vim.opt.showmatch = true

vim.opt.foldexpr = "v:lua.vim.treesitter.foldexpr()"
vim.opt.foldmethod = "expr"

vim.opt.foldlevelstart = 10 -- open most folds by default
vim.opt.foldnestmax = 10    -- 10 nested fold max

vim.opt.list = false
-- vim.opt.listchars = "tab:>-"

vim.opt.backspace = { "indent", "eol", "start" }

-- mkview and loadview shouldn't do options (which includes keyboard mappings
-- etc)
vim.opt.viewoptions = { "cursor", "slash", "unix" } -- ,folds

-- https://vi.stackexchange.com/questions/16148/slow-vim-escape-from-insert-mode
vim.opt.timeoutlen = 1000
vim.opt.ttimeoutlen = 5

-- better backup, swap and undos storage
vim.opt.backup = true                  -- make backup files
vim.opt.undofile = true                -- persistent undos - undo after you re-open the file
vim.opt.directory = "/tmp/nvim/tmp"    -- directory to place swap files in
vim.opt.backupdir = "/tmp/nvim/backup" -- where to put backup files
vim.opt.undodir = "/tmp/nvim/undodir"  -- undo directory

-- Set updatetime
vim.opt.updatetime = 500

vim.opt.incsearch = true -- search as characters are entered
vim.opt.hlsearch = true  -- highlight matches
vim.opt.smartcase = true -- smartcase search

vim.cmd("set nowrap")

-- formatoptions
vim.opt.formatoptions = {
	-- default: jtqlnr
	j = true, -- remove comment leader when joining lines
	t = false, -- autoformat text using textwidth
	q = true, -- format comments with gq
	l = true, -- keep long lines when they were long before insert-mode
	n = true, -- autoformat numbered list
	r = true, -- auto insert comment leader on pressing enter
	c = true, -- autoformat comment using textwidth
	o = false, -- don't insert comment leader on pressing o
	a = false, -- don't autoformat. Enabled filetype specific
	[1] = true, -- indent of the first line of the paragraph defines further indent
}

vim.opt.laststatus = 3

-- vim.opt.spell  true
vim.opt.spelllang = { "en_us" }
vim.opt.spellsuggest = "best,9"

-- auto-adjust splits when window is resized
-- https://vi.stackexchange.com/questions/201/make-panes-resize-when-host-window-is-resized
vim.api.nvim_create_autocmd({ "VimResized" }, {
	pattern = "*",
	command = "wincmd =",
})

vim.opt.equalalways = true

-- line numbers and relative number
vim.opt.number = false
vim.opt.relativenumber = false

-- enable mouse support
vim.opt.mouse = "a"

vim.opt.showtabline = 0

-- no cursor line
vim.opt.cursorline = false

-- no command line
-- vim.opt.cmdheight = 0

-- Redraw only when essential
vim.opt.lazyredraw = true
vim.opt.redrawtime = 10000

-- Just sync some lines of a large file
vim.opt.synmaxcol = 400
vim.cmd("syntax sync minlines=256")

-- When scrolling, keep cursor 10 lines away from screen border
vim.opt.scrolloff = 10
