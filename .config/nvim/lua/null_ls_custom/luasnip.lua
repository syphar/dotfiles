local null_ls = require("null-ls")

return {
	method = null_ls.methods.COMPLETION,
	filetypes = {},
	name = "luasnip",
	generator = {
		fn = function(params, done)
			local items = {}
			local available = require("luasnip").available()
			local snips = available[params.ft]
			vim.list_extend(snips, available.all)
			local targets = vim.tbl_filter(function(item)
				return string.match(item.name, "^" .. params.word_to_complete)
			end, snips)
			for _, item in ipairs(targets) do
				table.insert(items, {
					label = item.trigger,
					detail = table.concat(item.description, " "),
					kind = vim.lsp.protocol.CompletionItemKind["Snippet"],
				})
			end
			done({ { items = items, isIncomplete = #items == 0 } })
		end,
		async = true,
	},
}
