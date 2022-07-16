local refactoring = require("refactoring")
refactoring.setup({})

vim.keymap.set("v", "<leader>rr", refactoring.select_refactor, { noremap = true, silent = true, expr = false })
