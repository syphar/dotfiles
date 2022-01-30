local ls = require("luasnip")
local snippet = ls.snippet
local text = ls.text_node
local insert = ls.insert_node

-- documentation for snippet format inside examples:
-- https://github.com/L3MON4D3/LuaSnip/blob/master/Examples/snippets.lua

ls.snippets = {
	rust = {
		snippet("testmod", {
			text({ "#[cfg(test)]", "mod tests {", "    use super::*;", "    ", "    " }),
			insert(0),
			text({ "", "}" }),
		}),
		snippet("debugprint", {
			text('println!("{:?}", '),
			insert(0),
			text(");"),
		}),
		snippet("default", { text("..Default::default()") }),
	},
	python = {
		snippet("loggermod", {
			text({ "logger = logging.getLogger(__name__)" }),
		}),
		snippet("pdb", {
			text({ "import pdb; pdb.set_trace()" }),
		}),
	},
}

-- this loads the snippets from friendly-snippets
-- https://github.com/rafamadriz/friendly-snippets
require("luasnip/loaders/from_vscode").lazy_load()

vim.cmd([[
	imap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>' 
	inoremap <silent> <S-Tab> <cmd>lua require'luasnip'.jump(-1)<Cr>

	snoremap <silent> <Tab> <cmd>lua require('luasnip').jump(1)<Cr>
	snoremap <silent> <S-Tab> <cmd>lua require('luasnip').jump(-1)<Cr>

	imap <silent><expr> <C-E> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>'
	smap <silent><expr> <C-E> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>'
]])
