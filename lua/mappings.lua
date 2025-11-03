local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
vim.keymap.set("n", "<leader>fs", builtin.grep_string, { desc = "Search string under cursor" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "List open buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Search help" })

-- Copy visual selection to macOS clipboard
vim.keymap.set("v", "<leader>y", ":w !pbcopy<CR><CR>", { desc = "Copy selection to clipboard" })

-- Copy current line to clipboard
vim.keymap.set("n", "<leader>Y", ":.+w !pbcopy<CR><CR>", { desc = "Copy line to clipboard" })

-- Paste from macOS clipboard in normal mode
vim.keymap.set("n", "<leader>p", ":r !pbpaste<CR>", { desc = "Paste from clipboard" })

-- Paste from macOS clipboard in insert mode
vim.keymap.set("i", "<C-p>", "<C-r>=system('pbpaste')<CR>", { desc = "Paste from clipboard" })

vim.keymap.set("n", "<leader>gb", ":Gitsigns toggle_current_line_blame<CR>", {desc = "Gitblame current line"})
