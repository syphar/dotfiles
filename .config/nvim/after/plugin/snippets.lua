local ls = require("luasnip")
local snippet = ls.snippet
local text = ls.text_node
local insert = ls.insert_node
local set_keymap = require("utils").set_keymap

ls.config.set_config({
	history = true,
	updateevents = "TextChanged,TextChangedI",
})

-- documentation for snippet format inside examples:
-- https://github.com/L3MON4D3/LuaSnip/blob/master/Examples/snippets.lua

ls.add_snippets("rust", {
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
	ls.parser.parse_snippet("clcl", "let $1 = $1.clone();"),
	ls.parser.parse_snippet("dbl", 'log::debug!("{:?}", $1);'),
}, {
	key = "my_rust_snippets",
})

ls.add_snippets("python", {
	snippet("loggermod", {
		text({ "logger = logging.getLogger(__name__)" }),
	}),
	snippet("pdb", {
		text({ "import pdb; pdb.set_trace()" }),
	}),
}, {
	key = "my_python_snippets",
})

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

set_keymap("n", "<leader><leader>s", "<CMD>source ~/.config/nvim/after/plugin/snippets.lua<CR>")
