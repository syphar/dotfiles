local ls = require("luasnip")
local snippet = ls.snippet
local function_ = ls.function_node
local repeat_ = require("luasnip.extras").rep
local text = ls.text_node
local fmt = require("luasnip.extras.fmt").fmt
local insert = ls.insert_node
local indent = ls.indent_snippet_node

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
	snippet("test", {
		text({ "#[test]", "fn test_" }),
		insert(1),
		text({ "() {", "    " }),
		insert(2),
		text({ "", "}" }),
	}),
	snippet("debugprint", {
		text('println!("{:?}", '),
		insert(0),
		text(");"),
	}),
	snippet("default", { text("..Default::default()") }),
	snippet("clcl", fmt("let {1} = {2}.clone();", { insert(1), repeat_(1) })),
}, {
	key = "my_rust_snippets",
})

ls.add_snippets("python", {
	snippet("loggermod", {
		text({ "logger = logging.getLogger(__name__)" }),
	}),
	snippet("pdb", { text("__import__('pdb').set_trace()") }),
	snippet("ipdb", { text("__import__('ipdb').set_trace()") }),
	snippet("djconf", { text("from django.conf import settings") }),
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

vim.keymap.set({ "i", "s" }, "<C-E>", "<Plug>luasnip-next-choice")
vim.keymap.set("n", "<leader><leader>s", "<CMD>source ~/.config/nvim/after/plugin/snippets.lua<CR>")
