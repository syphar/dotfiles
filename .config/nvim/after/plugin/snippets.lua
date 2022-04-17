local ls = require("luasnip")
local snippet = ls.snippet
local function_ = ls.function_node
local text = ls.text_node
local fmt = require("luasnip.extras.fmt").fmt
local insert = ls.insert_node

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
	snippet("pdb", { text("__import__('pdb').set_trace()") }),
	snippet("ipdb", { text("__import__('ipdb').set_trace()") }),
}, {
	key = "my_python_snippets",
})

ls.add_snippets("lua", {
	snippet(
		"req",
		fmt([[local {} = require("{}")]], {
			function_(function(args)
				local splits = vim.split(args[1][1], ".", true)
				return splits[#splits] or ""
			end, { 1 }),
			insert(1),
		})
	),
}, {
	key = "my_lua_snippets",
})

vim.cmd([[
	imap <silent><expr> <Tab> luasnip#expand_or_jumpable() ? '<Plug>luasnip-expand-or-jump' : '<Tab>'
	inoremap <silent> <S-Tab> <cmd>lua require'luasnip'.jump(-1)<CR>

	snoremap <silent> <Tab> <cmd>lua require('luasnip').jump(1)<CR>
	snoremap <silent> <S-Tab> <cmd>lua require('luasnip').jump(-1)<CR>

	imap <silent><expr> <C-E> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>'
	smap <silent><expr> <C-E> luasnip#choice_active() ? '<Plug>luasnip-next-choice' : '<C-E>'
]])

vim.keymap.set("n", "<leader><leader>s", "<CMD>source ~/.config/nvim/after/plugin/snippets.lua<CR>")
