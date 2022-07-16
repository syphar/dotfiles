local refactoring = require("refactoring")
refactoring.setup({})

vim.keymap.set("v", "<leader>rr", refactoring.select_refactor, { noremap = true, silent = true, expr = false })

-- print function name
vim.keymap.set("n", "<leader>rp", function()
	refactoring.debug.printf({ below = false })
end)

-- Print var

-- Remap in normal mode and passing { normal = true } will automatically find the variable under the cursor and print it
vim.keymap.set("n", "<leader>rv", function()
	refactoring.debug.print_var({ normal = true })
end)

-- Remap in visual mode will print whatever is in the visual selection
vim.keymap.set("v", "<leader>rv", function()
	refactoring.debug.print_var({})
end)

-- Cleanup function: this remap should be made in normal mode
vim.keymap.set("n", "<leader>rc", function()
	refactoring.debug.cleanup({})
end)
