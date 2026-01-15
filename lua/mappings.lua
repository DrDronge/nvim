local builtin = require("telescope.builtin")
vim.keymap.set("n", "<leader>ff", builtin.find_files, { desc = "Find files" })
vim.keymap.set("n", "<leader>fg", builtin.live_grep, { desc = "Live grep" })
vim.keymap.set("n", "<leader>fs", builtin.grep_string, { desc = "Search string under cursor" })
vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "List open buffers" })
vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "Search help" })

-- Cross-platform clipboard operations
if vim.fn.has("mac") == 1 then
  -- macOS clipboard
  vim.keymap.set("v", "<leader>y", ":w !pbcopy<CR><CR>", { desc = "Copy selection to clipboard" })
  vim.keymap.set("n", "<leader>Y", ":.+w !pbcopy<CR><CR>", { desc = "Copy line to clipboard" })
  vim.keymap.set("n", "<leader>p", ":r !pbpaste<CR>", { desc = "Paste from clipboard" })
  vim.keymap.set("i", "<C-p>", "<C-r>=system('pbpaste')<CR>", { desc = "Paste from clipboard" })
elseif vim.fn.has("unix") == 1 then
  -- Linux clipboard (requires xclip or xsel)
  vim.keymap.set("v", "<leader>y", '"+y', { desc = "Copy selection to clipboard" })
  vim.keymap.set("n", "<leader>Y", '"+yy', { desc = "Copy line to clipboard" })
  vim.keymap.set("n", "<leader>p", '"+p', { desc = "Paste from clipboard" })
  vim.keymap.set("i", "<C-p>", '<C-r>+', { desc = "Paste from clipboard" })
else
  -- Windows clipboard
  vim.keymap.set("v", "<leader>y", '"+y', { desc = "Copy selection to clipboard" })
  vim.keymap.set("n", "<leader>Y", '"+yy', { desc = "Copy line to clipboard" })
  vim.keymap.set("n", "<leader>p", '"+p', { desc = "Paste from clipboard" })
  vim.keymap.set("i", "<C-p>", '<C-r>+', { desc = "Paste from clipboard" })
end

vim.keymap.set("n", "<leader>gb", ":Gitsigns toggle_current_line_blame<CR>", {desc = "Gitblame current line"})

-- NvimTree
vim.keymap.set("n", "<leader>nt", ":NvimTreeToggle<CR>", { desc = "NvimTreeToggle to open and close NvimTree"})
vim.keymap.set("n", "<leader>nf", ":NvimTreeFocus<CR>", { desc = "NvimTree focus"})
