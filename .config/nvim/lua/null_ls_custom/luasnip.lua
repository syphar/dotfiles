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
			for _, item in ipairs(snips) do
				table.insert(items, {
					label = item.name,
					detail = "",
					kind = vim.lsp.protocol.CompletionItemKind["Snippet"],
				})
			end
			done({ { items = items, isIncomplete = #items == 0 } })
		end,
		async = true,
	},
}
