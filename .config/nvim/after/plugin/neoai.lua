require("neoai").setup({
	-- ui = {
	-- 	output_popup_text = "NeoAI",
	-- 	input_popup_text = "Prompt",
	-- 	width = 30,         -- As percentage eg. 30%
	-- 	output_popup_height = 80, -- As percentage eg. 80%
	-- 	submit = "<Enter>", -- Key binding to submit the prompt
	-- },
	models = {
		{
			name = "openai",
			-- model = "gpt-3.5-turbo"
			-- https://platform.openai.com/docs/models/gpt-4
			model = "gpt-4",
			params = nil,
		},
	},
	-- register_output = {
	-- 	["g"] = function(output)
	-- 		return output
	-- 	end,
	-- 	["c"] = require("neoai.utils").extract_code_snippets,
	-- },
	-- inject = {
	-- 	cutoff_width = 75,
	-- },
	-- prompts = {
	-- 	context_prompt = function(context)
	-- 		return "Hey, I'd like to provide some context for future "
	-- 			.. "messages. Here is the code/text that I want to refer "
	-- 			.. "to in our upcoming conversations:\n\n"
	-- 			.. context
	-- 	end,
	-- },
	-- mappings = {
	-- 	["select_up"] = "<C-k>",
	-- 	["select_down"] = "<C-j>",
	-- },
	-- open_api_key_env = vim.env.OPENAI_API_KEY,
	-- shortcuts = {
	-- 	{
	-- 		name = "textify",
	-- 		key = "<leader>as",
	-- 		desc = "fix text with AI",
	-- 		use_context = true,
	-- 		prompt = [[
	--                Please rewrite the text to make it more readable, clear,
	--                concise, and fix any grammatical, punctuation, or spelling
	--                errors
	--            ]],
	-- 		modes = { "v" },
	-- 		strip_function = nil,
	-- 	},
	-- 	{
	-- 		name = "gitcommit",
	-- 		key = "<leader>ag",
	-- 		desc = "generate git commit message",
	-- 		use_context = false,
	-- 		prompt = function()
	-- 			return [[
	--                    Using the following git diff generate a consise and
	--                    clear git commit message, with a short title summary
	--                    that is 75 characters or less:
	--                ]] .. vim.fn.system("git diff --cached")
	-- 		end,
	-- 		modes = { "n" },
	-- 		strip_function = nil,
	-- 	},
	-- },
})
