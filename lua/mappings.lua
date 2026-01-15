local map = vim.keymap.set

-- General mappings
map("n", "<C-n>", ":NvimTreeToggle<CR>", { desc = "Toggle file tree" })
map("n", "<leader>e", ":NvimTreeFocus<CR>", { desc = "Focus file tree" })

-- Telescope
map("n", "<leader>ff", ":Telescope find_files<CR>", { desc = "Find files (current dir)" })
map("n", "<leader>fa", function()
  require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })
end, { desc = "Find files (nvim config)" })
map("n", "<leader>fg", ":Telescope live_grep<CR>", { desc = "Live grep" })
map("n", "<leader>fb", ":Telescope buffers<CR>", { desc = "Find buffers" })
map("n", "<leader>fh", ":Telescope help_tags<CR>", { desc = "Help tags" })
map("n", "<leader>fr", ":Telescope oldfiles<CR>", { desc = "Recent files" })

-- Oil (file browser)
map("n", "-", ":Oil<CR>", { desc = "Open parent directory" })

-- LSP keybindings
map("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
map("n", "K", vim.lsp.buf.hover, { desc = "Hover documentation" })
map("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
map("n", "<C-k>", vim.lsp.buf.signature_help, { desc = "Signature help" })
map("n", "<leader>wa", vim.lsp.buf.add_workspace_folder, { desc = "Add workspace folder" })
map("n", "<leader>wr", vim.lsp.buf.remove_workspace_folder, { desc = "Remove workspace folder" })
map("n", "<leader>wl", function()
  print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
end, { desc = "List workspace folders" })
map("n", "<leader>D", vim.lsp.buf.type_definition, { desc = "Type definition" })
map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
map("n", "gr", vim.lsp.buf.references, { desc = "Find references" })
map("n", "<leader>f", function()
  vim.lsp.buf.format({ async = true })
end, { desc = "Format buffer" })

-- Diagnostics
map("n", "<leader>d", vim.diagnostic.open_float, { desc = "Show diagnostic" })
map("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Diagnostic quickfix" })

-- Telescope LSP integration
map("n", "<leader>lr", ":Telescope lsp_references<CR>", { desc = "LSP references" })
map("n", "<leader>ld", ":Telescope lsp_definitions<CR>", { desc = "LSP definitions" })
map("n", "<leader>ls", ":Telescope lsp_document_symbols<CR>", { desc = "Document symbols" })
map("n", "<leader>lw", ":Telescope lsp_workspace_symbols<CR>", { desc = "Workspace symbols" })

-- Buffer navigation
map("n", "<Tab>", ":bnext<CR>", { desc = "Next buffer" })
map("n", "<S-Tab>", ":bprevious<CR>", { desc = "Previous buffer" })
map("n", "<leader>x", ":bdelete<CR>", { desc = "Close buffer" })

-- Window navigation
map("n", "<C-h>", "<C-w>h", { desc = "Move to left window" })
map("n", "<C-j>", "<C-w>j", { desc = "Move to bottom window" })
map("n", "<C-k>", "<C-w>k", { desc = "Move to top window" })
map("n", "<C-l>", "<C-w>l", { desc = "Move to right window" })

-- Resize windows
map("n", "<C-Up>", ":resize +2<CR>", { desc = "Increase window height" })
map("n", "<C-Down>", ":resize -2<CR>", { desc = "Decrease window height" })
map("n", "<C-Left>", ":vertical resize -2<CR>", { desc = "Decrease window width" })
map("n", "<C-Right>", ":vertical resize +2<CR>", { desc = "Increase window width" })

-- Better indenting
map("v", "<", "<gv", { desc = "Indent left" })
map("v", ">", ">gv", { desc = "Indent right" })

-- Move lines up/down
map("n", "<A-j>", ":m .+1<CR>==", { desc = "Move line down" })
map("n", "<A-k>", ":m .-2<CR>==", { desc = "Move line up" })
map("v", "<A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
map("v", "<A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

-- Clear search highlighting
map("n", "<Esc>", ":noh<CR>", { desc = "Clear search highlight" })

-- Save and quit shortcuts
map("n", "<C-s>", ":w<CR>", { desc = "Save file" })
map("n", "<C-q>", ":q<CR>", { desc = "Quit" })

-- Comment (if using Comment.nvim)
map("n", "<leader>/", function() require("Comment.api").toggle.linewise.current() end, { desc = "Toggle comment" })
map("v", "<leader>/", "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>", { desc = "Toggle comment" })

-- Git (if using gitsigns)
map("n", "<leader>gp", ":Gitsigns preview_hunk<CR>", { desc = "Preview git hunk" })
map("n", "<leader>gr", ":Gitsigns reset_hunk<CR>", { desc = "Reset git hunk" })
map("n", "<leader>gb", ":Gitsigns blame_line<CR>", { desc = "Git blame line" })

-- ========================================
-- BUILD & RUN (C# / .NET)
-- ========================================

-- Build current project
map("n", "<F5>", function()
  vim.cmd("w") -- Save first
  vim.cmd("!dotnet build")
end, { desc = "Build .NET project" })

-- Run current project
map("n", "<F6>", function()
  vim.cmd("w") -- Save first
  vim.cmd("!dotnet run")
end, { desc = "Run .NET project" })

-- Build and run
map("n", "<leader>br", function()
  vim.cmd("w")
  vim.cmd("!dotnet build && dotnet run")
end, { desc = "Build and run" })

-- Run tests
map("n", "<leader>bt", function()
  vim.cmd("!dotnet test")
end, { desc = "Run .NET tests" })

-- Clean build
map("n", "<leader>bc", function()
  vim.cmd("!dotnet clean && dotnet build")
end, { desc = "Clean and build" })

-- ========================================
-- DEBUGGING (using nvim-dap)
-- ========================================

-- Toggle breakpoint
map("n", "<leader>db", function()
  require("dap").toggle_breakpoint()
end, { desc = "Toggle breakpoint" })

-- Start/Continue debugging
map("n", "<F9>", function()
  require("dap").continue()
end, { desc = "Start/Continue debugging" })

-- Step over
map("n", "<F10>", function()
  require("dap").step_over()
end, { desc = "Step over" })

-- Step into
map("n", "<F11>", function()
  require("dap").step_into()
end, { desc = "Step into" })

-- Step out
map("n", "<S-F11>", function()
  require("dap").step_out()
end, { desc = "Step out" })

-- Stop debugging
map("n", "<leader>ds", function()
  require("dap").terminate()
end, { desc = "Stop debugging" })

-- Open debug UI
map("n", "<leader>du", function()
  require("dapui").toggle()
end, { desc = "Toggle debug UI" })

-- Evaluate expression under cursor
map("n", "<leader>de", function()
  require("dapui").eval()
end, { desc = "Evaluate expression" })

-- ========================================
-- TERMINAL SHORTCUTS
-- ========================================

-- Open terminal in split
map("n", "<leader>th", ":split | terminal<CR>", { desc = "Terminal horizontal split" })
map("n", "<leader>tv", ":vsplit | terminal<CR>", { desc = "Terminal vertical split" })

-- Exit terminal mode with Esc
map("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Close current window/pane (works for terminal too!)
map("n", "<leader>w", ":close<CR>", { desc = "Close current window" })

-- Close terminal and window at once (from terminal mode)
map("t", "<C-q>", "<C-\\><C-n>:close<CR>", { desc = "Close terminal" })