return {
	{
		"zbirenbaum/copilot.lua",
		cmd = "Copilot",
		event = "InsertEnter",
		opts = {
			copilot_model = "gpt-4o-copilot",
			suggestion = { enabled = true, auto_trigger = true },
			panel = { enabled = false },
			copilot_node_command = "/opt/homebrew/bin/node",
		},
	},
}
