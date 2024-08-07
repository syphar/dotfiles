local M = {}

function M.setup(cfg, lspconfig)
	lspconfig.pylsp.setup({
		-- cmd = {
		-- 	"/Users/syphar/src/python-lsp-server/.direnv/python-3.9.15/bin/pylsp",
		-- 	"-vvv",
		-- 	"--log-file=/Users/syphar/tmp/pylsp.log",
		-- },
		flags = cfg.global_flags(),
		capabilities = cfg.capabilities(),
		on_attach = cfg.lsp_on_attach,
		settings = {
			pylsp = {
				plugins = {
					-- broken currently with my setup
					-- rope_autoimport = {
					-- 	enabled = true,
					-- },
					pydocstyle = {
						enabled = false,
					},
					pycodestyle = {
						enabled = false,
					},
					pyflakes = {
						enabled = false,
					},
					jedi_signature_help = {
						enabled = true,
					},
					pylsp_mypy = {
						enabled = true,
						live_mode = false,
						report_progress = true,
						dmypy = true,
					},
				},
			},
		},
	})
end

return M
