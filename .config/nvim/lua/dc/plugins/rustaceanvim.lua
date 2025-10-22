return {
	"mrcjkb/rustaceanvim",
	version = "^6",
	ft = { "rust" },
	config = function()
		local cfg = require("dc.lsp")

		require("type-fmt").setup({
			-- In case if you only want to enable this for limited buffers
			-- We already filter it by checking capabilities of attached lsp client
			buf_filter = function(bufnr)
				return true
			end,
			-- If multiple clients are capable of onTypeFormatting, we use this to determine which will win
			-- This is a rare situation but we still provide it for the correctness of lsp client handling
			prefer_client = function(client_a, client_b)
				return client_a or client_b
			end,
		})

		vim.g.rustaceanvim = {
			inlay_hints = {
				highlight = "NonText",
			},
			tools = {
				hover_actions = {
					auto_focus = true,
				},
			},
			server = {
				flags = cfg.global_flags(),
				capabilities = cfg.capabilities(),
				on_attach = function(client, bufnr)
					cfg.lsp_on_attach(client, bufnr)

					-- disable LSP server hilighting, I prefer treesitter for now
					-- client.server_capabilities.semanticTokensProvider = nil
				end,
				settings = {
					["rust-analyzer"] = {
						files = {
							excludeDirs = { ".rustwide-docker", ".rustwide", ".rustwide-docker" },
						},
						imports = {
							granularity = {
								group = "crate",
							},
							group = {
								enable = true,
							},
							merge = {
								glob = false,
							},
							prefix = "crate",
							preferPrelude = false,
						},
						inlayHints = {
							--     Whether to show inlay type hints for binding modes.
							bindingModeHints = { enable = false }, -- default: false
							--     Whether to show inlay type hints for method chains.
							chainingHints = { enable = true }, -- default: true

							closingBraceHints = {
								-- Whether to show inlay hints after a closing } to indicate what item it belongs to.
								enable = false, --default: true
								-- Minimum number of lines required before the } until the hint is shown (set to 0 or 1 to always show them).
								minLines = 25, -- default: 25
							},

							-- Whether to show inlay type hints for return types of closures.
							closureReturnTypeHints = { enable = "with_block" }, --default: "never", options: "always", "never", "with_block"

							-- Whether to show inlay hints for closure captures.
							closureCaptureHints = { enable = false }, -- default : false

							-- Whether to show inlay hints for type adjustments.
							expressionAdjustmentHints = { enable = "never" }, --default: "never", options "always", "never", "reborrow"

							lifetimeElisionHints = {
								-- Whether to show inlay type hints for elided lifetimes in function signatures.
								enable = "never", -- default: "never", options: "always", "never", "skip_trivial"
								-- Whether to prefer using parameter names as the name for elided lifetime hints if possible.
								useParameterNames = true, -- default: false
							},

							--     Maximum length for inlay hints. Set to null to have an unlimited length.
							maxLength = 25, -- default: 25

							-- Whether to show function parameter name inlay hints at the call site.
							parameterHints = { enable = true }, --  default: true

							-- Whether to show inlay hints for compiler inserted reborrows. This setting is deprecated in favor of expressionAdjustmentHints.enable.
							reborrowHints = { enable = "never" }, --default: "never", options "always", "never", "mutable"

							-- Whether to render leading colons for type hints, and trailing colons for parameter hints.
							renderColons = true, -- default: true

							typeHints = {
								-- Whether to show inlay type hints for variables.
								enable = true, -- default: true
								-- Whether to hide inlay type hints for let statements that initialize to a closure.
								-- Only applies to closures with blocks, same as closureReturnTypeHints.enable.
								hideClosureInitialization = false, -- default: false
								-- Whether to hide inlay type hints for constructors.
								hideNamedConstructor = false, -- default: false
							},
						},
						checkOnSave = {
							enable = true,
							-- command = "clippy",
							-- allTargets = true,
							-- allFeatures = true,
						},
						editor = { formatOnType = true },
						cachePriming = {
							enable = false,
						},
						cargo = {
							loadOutDirsFromCheck = true,
						},
						procMacro = {
							enable = true,
						},
						workspace = {
							symbol = {
								search = {
									-- scope = "workspace_and_dependencies", --  (default: "workspace")
									scope = "workspace",
								},
							},
						},
					},
				},
			},
		}
	end,
}
