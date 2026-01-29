local M = {}

local map = vim.keymap.set
local terminal = require("terminal")
local build = require("build")

-- =====================================================
-- GLOBAL KEYMAPS
-- =====================================================
function M.setup()

-- General mappings
map("n", "<C-n>", ":NvimTreeToggle<CR>", { desc = "Toggle file tree" })
map("n", "<leader>e", ":NvimTreeFocus<CR>", { desc = "Focus file tree" })

-- Telescope
map("n", "<leader>ff", function()
  require("telescope.builtin").find_files({
    cwd = vim.fn.getcwd(),
    hidden = false,
    no_ignore = false,
  })
end, { desc = "Find files (current dir)" })

map("n", "<leader>fF", function()
  require("telescope.builtin").find_files({
    cwd = vim.fn.getcwd(),
    hidden = true,
    no_ignore = true,
  })
end, { desc = "Find ALL files (including hidden)" })

map("n", "<leader>fa", function()
  require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })
end, { desc = "Find files (nvim config)" })

map("n", "<leader>fg", function()
  require("telescope.builtin").live_grep({
    cwd = vim.fn.getcwd(),
  })
end, { desc = "Live grep" })

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

-- Close current window/pane
map("n", "<leader>x", function()
  local current_win = vim.api.nvim_get_current_win()
  local current_buf = vim.api.nvim_win_get_buf(current_win)
  local buftype = vim.api.nvim_get_option_value("buftype", { buf = current_buf })
  
  -- Handle terminal buffers
  if buftype == "terminal" then
    vim.cmd("bdelete!")
    if current_win == terminal.get_terminal_win() then
      terminal.clear_terminal_win()
    end
    return
  end
  
  -- Count non-NvimTree windows
  local non_tree_win_count = 0
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    local ft = vim.api.nvim_get_option_value("filetype", { buf = buf })
    if ft ~= "NvimTree" then
      non_tree_win_count = non_tree_win_count + 1
    end
  end
  
  -- Last window: delete buffer, otherwise close window
  if non_tree_win_count <= 1 then
    vim.cmd("bdelete")
  else
    vim.cmd("close")
  end
end, { desc = "Close current window/buffer" })

map("n", "<leader>X", ":bdelete!<CR>", { desc = "Force close buffer" })

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

-- Comment
map("n", "<leader>/", function() require("Comment.api").toggle.linewise.current() end, { desc = "Toggle comment" })
map("v", "<leader>/", "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>", { desc = "Toggle comment" })

-- Git
map("n", "<leader>gp", ":Gitsigns preview_hunk<CR>", { desc = "Preview git hunk" })
map("n", "<leader>gr", ":Gitsigns reset_hunk<CR>", { desc = "Reset git hunk" })
map("n", "<leader>gb", ":Gitsigns blame_line<CR>", { desc = "Git blame line" })

-- Diffview
map("n", "<leader>gv", ":DiffviewOpen<CR>", { desc = "Open diff view" })
map("n", "<leader>gc", ":DiffviewClose<CR>", { desc = "Close diff view" })
map("n", "<leader>gh", ":DiffviewFileHistory %<CR>", { desc = "Current file history" })
map("n", "<leader>gH", ":DiffviewFileHistory<CR>", { desc = "Branch history" })

-- ========================================
-- RUST DEVELOPMENT
-- ========================================

map("n", "<F7>", build.cargo_run, { desc = "Run Rust project" })
map("n", "<F8>", build.cargo_build, { desc = "Build Rust project" })
map("n", "<leader>rt", build.cargo_test, { desc = "Run Rust tests" })
map("n", "<leader>rc", build.cargo_check, { desc = "Check Rust project" })
map("n", "<leader>rl", build.cargo_clippy, { desc = "Run Clippy" })
map("n", "<leader>rf", build.cargo_format_file, { desc = "Format Rust file" })
map("n", "<leader>rb", build.cargo_build_release, { desc = "Build Rust release" })
map("n", "<leader>rr", build.cargo_run_release, { desc = "Run Rust release" })
map("n", "<leader>rx", build.cargo_clean, { desc = "Cargo clean" })
map("n", "<leader>rnb", build.cargo_new_bin, { desc = "New Rust binary project" })
map("n", "<leader>rnl", build.cargo_new_lib, { desc = "New Rust library" })
map("n", "<leader>ra", build.open_cargo_toml, { desc = "Open Cargo.toml" })

-- Rust-specific LSP keybindings (when rust-analyzer is attached)
vim.api.nvim_create_autocmd("LspAttach", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.name == "rust_analyzer" then
      local bufnr = args.buf
      
      -- Expand macro
      map("n", "<leader>re", function()
        vim.cmd.RustLsp("expandMacro")
      end, { buffer = bufnr, desc = "Expand macro" })
      
      -- View HIR
      map("n", "<leader>rh", function()
        vim.cmd.RustLsp({ "view", "hir" })
      end, { buffer = bufnr, desc = "View HIR" })
      
      -- View MIR
      map("n", "<leader>rm", function()
        vim.cmd.RustLsp({ "view", "mir" })
      end, { buffer = bufnr, desc = "View MIR" })
      
      -- Open Cargo.toml
      map("n", "<leader>ro", function()
        vim.cmd.RustLsp("openCargo")
      end, { buffer = bufnr, desc = "Open Cargo.toml" })
      
      -- Parent module
      map("n", "<leader>rp", function()
        vim.cmd.RustLsp("parentModule")
      end, { buffer = bufnr, desc = "Go to parent module" })
      
      -- Hover actions (overrides default K)
      map("n", "K", function()
        vim.cmd.RustLsp({ "hover", "actions" })
      end, { buffer = bufnr, desc = "Hover actions" })
      
      -- Code actions
      map("n", "<leader>ca", function()
        vim.cmd.RustLsp("codeAction")
      end, { buffer = bufnr, desc = "Code action" })
    end
  end,
})

-- ========================================
-- BUILD & RUN (C# / .NET)
-- ========================================

map("n", "<F5>", build.dotnet_build, { desc = "Build .NET project" })
map("n", "<F6>", build.dotnet_run, { desc = "Run .NET project" })
map("n", "<leader>br", build.dotnet_build_and_run, { desc = "Build and run" })
map("n", "<leader>bt", build.dotnet_test, { desc = "Run .NET tests" })
map("n", "<leader>bc", build.dotnet_clean_build, { desc = "Clean and build" })

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
-- .NET PROJECT MANAGEMENT
-- ========================================

map("n", "<leader>nco", build.new_console, { desc = "New console project" })
map("n", "<leader>nl", build.new_classlib, { desc = "New class library" })
map("n", "<leader>na", build.new_webapi, { desc = "New Web API project" })
map("n", "<leader>nc", build.new_class, { desc = "New C# class" })
map("n", "<leader>ni", build.new_interface, { desc = "New C# interface" })
map("n", "<leader>np", build.add_project_to_sln, { desc = "Add project to solution" })
map("n", "<leader>ns", build.new_solution, { desc = "New solution" })
map("n", "<leader>ng", build.add_package, { desc = "Add NuGet package" })

-- ========================================
-- DIRECTORY NAVIGATION
-- ========================================

-- Change to directory of current file
map("n", "<leader>cd", ":cd %:p:h<CR>:pwd<CR>", { desc = "Change to file directory" })

-- Change to project root
map("n", "<leader>cr", function()
  local root_patterns = { ".git", "*.sln", "*.csproj", "Cargo.toml" }
  local path = vim.fn.expand("%:p:h")
  
  while path ~= "/" and path ~= "C:\\" and path ~= "" do
    for _, pattern in ipairs(root_patterns) do
      if vim.fn.glob(path .. "/" .. pattern) ~= "" then
        vim.cmd("cd " .. path)
        print("Changed to: " .. path)
        return
      end
    end
    path = vim.fn.fnamemodify(path, ":h")
  end
  
  print("No project root found")
end, { desc = "Change to project root" })

-- Show current directory
map("n", "<leader>cp", ":pwd<CR>", { desc = "Show current directory" })

-- ========================================
-- NEOVIM CONFIG
-- ========================================

-- Reload Neovim config
map("n", "<leader>r", function()
  vim.cmd("source $MYVIMRC")
  vim.notify("Config reloaded!", vim.log.levels.INFO)
end, { desc = "Reload Neovim config" })

-- ========================================
-- TERMINAL SHORTCUTS
-- ========================================

local TERMINAL_HEIGHT = 10
local TERMINAL_WIDTH = 80

map("n", "<leader>th", string.format(":botright %dsplit | terminal<CR>i", TERMINAL_HEIGHT), { desc = "Terminal horizontal split" })
map("n", "<leader>tv", string.format(":botright %dvsplit | terminal<CR>i", TERMINAL_WIDTH), { desc = "Terminal vertical split" })

-- Exit terminal mode with Esc
map("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Close current window/pane
map("n", "<leader>w", function()
  local current_win = vim.api.nvim_get_current_win()
  vim.cmd("close")
  
  if current_win == terminal.get_terminal_win() then
    terminal.clear_terminal_win()
  end
end, { desc = "Close current window" })

-- Close terminal and window at once (from terminal mode)
map("t", "<C-q>", "<C-\\><C-n>:close<CR>", { desc = "Close terminal" })

-- Resize terminal/window from terminal mode
map("t", "<C-Up>", "<C-\\><C-n>:resize +2<CR>i", { desc = "Increase terminal height" })
map("t", "<C-Down>", "<C-\\><C-n>:resize -2<CR>i", { desc = "Decrease terminal height" })
map("t", "<C-Left>", "<C-\\><C-n>:vertical resize -2<CR>i", { desc = "Decrease terminal width" })
map("t", "<C-Right>", "<C-\\><C-n>:vertical resize +2<CR>i", { desc = "Increase terminal width" })

-- Quick resize terminal to specific sizes (from terminal mode)
local TERMINAL_SMALL = 10
local TERMINAL_MEDIUM = 20
local TERMINAL_LARGE = 30

map("t", "<A-=>", string.format("<C-\\><C-n>:resize %d<CR>i", TERMINAL_MEDIUM), { desc = "Terminal: medium height" })
map("t", "<A-+>", string.format("<C-\\><C-n>:resize %d<CR>i", TERMINAL_LARGE), { desc = "Terminal: large height" })
map("t", "<A-->", string.format("<C-\\><C-n>:resize %d<CR>i", TERMINAL_SMALL), { desc = "Terminal: small height" })

end

-- =====================================================
-- NVIMTREE SPECIFIC KEYMAPS
-- =====================================================
function M.nvim_tree_on_attach(bufnr)
  local api = require("nvim-tree.api")

  local function opts(desc)
    return { desc = "nvim-tree: " .. desc, buffer = bufnr, noremap = true, silent = true, nowait = true }
  end

  -- Default mappings
  api.config.mappings.default_on_attach(bufnr)

  -- Custom keybinding
  vim.keymap.set("n", "<CR>", api.node.open.edit, opts("Open"))
  vim.keymap.set("n", "C", function()
    local node = api.tree.get_node_under_cursor()
    if node then
      local dir = node.type == "directory" and node.absolute_path or vim.fn.fnamemodify(node.absolute_path, ":h")
      api.tree.change_root(dir)
      vim.cmd("cd " .. vim.fn.fnameescape(dir))
      print("📁 Changed root and cwd to: " .. vim.fn.fnamemodify(dir, ":t"))
    end
  end, opts("Change root and cwd"))
  vim.keymap.set("n", "U", api.tree.change_root_to_parent, opts("Root to parent"))
  vim.keymap.set("n", "r", api.tree.reload, opts("Refresh"))
  vim.keymap.set("n", "q", api.tree.close, opts("Close tree"))
end

return M
