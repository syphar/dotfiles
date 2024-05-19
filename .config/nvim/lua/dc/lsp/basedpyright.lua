local M = {}

function M.setup(cfg, lspconfig)
	lspconfig.basedpyright.setup({
		flags = cfg.global_flags(),
		on_attach = function(client, bufnr)
			-- disable all LSP capabilities except inlay hints for this server
			local sc = client.server_capabilities
			for key, _ in pairs(sc) do
				sc[key] = nil
			end
			sc.inlayHintProvider = true

			-- we also don't need to call our own lsp_on_attach method
			-- this the "default" pyright server will handle the rest of the features
		end,
		handlers = {
			["textDocument/publishDiagnostics"] = function() end,
		},
	})
end

return M
