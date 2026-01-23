local M = {}

local map = vim.keymap.set

-- ========================================
-- HELPER: Get NvimTree selected folder or fallback to cwd
-- ========================================
local function get_working_directory()
  -- Check if we're currently in NvimTree
  if vim.bo.filetype == "NvimTree" then
    local ok, api = pcall(require, "nvim-tree.api")
    if ok then
      local node = api.tree.get_node_under_cursor()
      if node then
        -- If it's a directory, use it; if it's a file, use its parent directory
        local dir = node.type == "directory" and node.absolute_path or vim.fn.fnamemodify(node.absolute_path, ":h")
        return dir
      end
    end
  end
  
  -- Try to get NvimTree's root directory if tree is open
  local ok, api = pcall(require, "nvim-tree.api")
  if ok then
    local tree = api.tree.get_nodes()
    if tree and tree.absolute_path then
      return tree.absolute_path
    end
  end
  
  -- Fallback to Neovim's current working directory
  return vim.fn.getcwd()
end

-- ========================================
-- HELPER: Run command in terminal split
-- ========================================
local terminal_win = nil

local function run_in_terminal(cmd)
  -- Get the directory to run the command in
  local dir = get_working_directory()
  
  -- Prepend cd command if we need to change directory
  local full_cmd = dir and ("cd " .. vim.fn.fnameescape(dir) .. " && " .. cmd) or cmd
  
  -- Check if we have a valid terminal window
  if terminal_win and vim.api.nvim_win_is_valid(terminal_win) then
    local buf = vim.api.nvim_win_get_buf(terminal_win)
    
    -- Check if the buffer is still a valid terminal
    local ok, chan = pcall(vim.api.nvim_buf_get_var, buf, "terminal_job_id")
    
    -- Simple check: if we can get the job id and buffer is valid, terminal is alive
    if ok and chan and vim.api.nvim_buf_is_valid(buf) then
      -- Try to send command
      local send_ok = pcall(vim.api.nvim_chan_send, chan, "\x03") -- Send Ctrl+C
      
      if send_ok then
        -- Terminal is still running, send the command
        vim.api.nvim_set_current_win(terminal_win)
        vim.defer_fn(function()
          pcall(vim.api.nvim_chan_send, chan, full_cmd .. "\r") -- Send command + Enter
        end, 100)
        vim.cmd("startinsert")
      else
        -- Terminal job closed, create new terminal in same window
        vim.api.nvim_set_current_win(terminal_win)
        vim.cmd("terminal " .. full_cmd)
        vim.cmd("startinsert")
      end
    else
      -- Terminal job closed, but window still open - create new terminal in same window
      vim.api.nvim_set_current_win(terminal_win)
      vim.cmd("terminal " .. full_cmd)
      vim.cmd("startinsert")
    end
  else
    -- No terminal window exists, create a new one
    vim.cmd("botright 10split | terminal " .. full_cmd)
    terminal_win = vim.api.nvim_get_current_win()
    vim.cmd("startinsert")
    
    -- Clear terminal_win when the window is closed
    vim.api.nvim_create_autocmd("WinClosed", {
      pattern = tostring(terminal_win),
      callback = function()
        terminal_win = nil
      end,
      once = true,
    })
  end
end

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
  local buftype = vim.api.nvim_buf_get_option(current_buf, "buftype")
  
  -- Count how many windows are open (excluding NvimTree)
  local win_count = 0
  for _, win in ipairs(vim.api.nvim_list_wins()) do
    local buf = vim.api.nvim_win_get_buf(win)
    local ft = vim.api.nvim_buf_get_option(buf, "filetype")
    if ft ~= "NvimTree" then
      win_count = win_count + 1
    end
  end
  
  -- If it's a terminal buffer
  if buftype == "terminal" then
    -- Just close the buffer, keep the window if there are other terminals
    vim.cmd("bdelete!")
    
    -- Reset terminal_win if this was our tracked terminal window
    if current_win == terminal_win then
      terminal_win = nil
    end
  -- If it's the last non-NvimTree window, just delete the buffer
  elseif win_count <= 1 then
    vim.cmd("bdelete")
  else
    -- Otherwise close the window
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

-- Run Rust project
map("n", "<F7>", function()
  vim.cmd("w")
  run_in_terminal("cargo run")
end, { desc = "Run Rust project" })

-- Build Rust project
map("n", "<F8>", function()
  vim.cmd("w")
  run_in_terminal("cargo build")
end, { desc = "Build Rust project" })

-- Test Rust project
map("n", "<leader>rt", function()
  run_in_terminal("cargo test")
end, { desc = "Run Rust tests" })

-- Check Rust project (faster than build)
map("n", "<leader>rc", function()
  run_in_terminal("cargo check")
end, { desc = "Check Rust project" })

-- Run Clippy (linter)
map("n", "<leader>rl", function()
  run_in_terminal("cargo clippy")
end, { desc = "Run Clippy" })

-- Format Rust code
map("n", "<leader>rf", function()
  vim.cmd("!rustfmt %")
  vim.cmd("e") -- Reload file
end, { desc = "Format Rust file" })

-- Build release
map("n", "<leader>rb", function()
  run_in_terminal("cargo build --release")
end, { desc = "Build Rust release" })

-- Run release
map("n", "<leader>rr", function()
  run_in_terminal("cargo run --release")
end, { desc = "Run Rust release" })

-- Cargo clean
map("n", "<leader>rx", function()
  run_in_terminal("cargo clean")
end, { desc = "Cargo clean" })

-- Create new Rust project
map("n", "<leader>rnb", function()
  local name = vim.fn.input("Binary project name: ")
  if name ~= "" then
    run_in_terminal("cargo new " .. name)
  end
end, { desc = "New Rust binary project" })

-- Create new Rust library
map("n", "<leader>rnl", function()
  local name = vim.fn.input("Library name: ")
  if name ~= "" then
    run_in_terminal("cargo new --lib " .. name)
  end
end, { desc = "New Rust library" })

-- Add dependency (opens Cargo.toml)
map("n", "<leader>ra", function()
  vim.cmd("e Cargo.toml")
end, { desc = "Open Cargo.toml" })

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

-- Build current project
map("n", "<F5>", function()
  vim.cmd("w")
  run_in_terminal("dotnet build")
end, { desc = "Build .NET project" })

-- Run current project
map("n", "<F6>", function()
  vim.cmd("w")
  run_in_terminal("dotnet run")
end, { desc = "Run .NET project" })

-- Build and run
map("n", "<leader>br", function()
  vim.cmd("w")
  run_in_terminal("dotnet build && dotnet run")
end, { desc = "Build and run" })

-- Run tests
map("n", "<leader>bt", function()
  run_in_terminal("dotnet test")
end, { desc = "Run .NET tests" })

-- Clean build
map("n", "<leader>bc", function()
  run_in_terminal("dotnet clean && dotnet build")
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
-- .NET PROJECT MANAGEMENT
-- ========================================

-- Create new console app
map("n", "<leader>nco", function()
  local name = vim.fn.input("Console project name: ")
  if name ~= "" then
    run_in_terminal("dotnet new console -n " .. name)
  end
end, { desc = "New console project" })

-- Create new class library
map("n", "<leader>nl", function()
  local name = vim.fn.input("Library name: ")
  if name ~= "" then
    run_in_terminal("dotnet new classlib -n " .. name)
  end
end, { desc = "New class library" })

-- Create new web API
map("n", "<leader>na", function()
  local name = vim.fn.input("API name: ")
  if name ~= "" then
    run_in_terminal("dotnet new webapi -n " .. name)
  end
end, { desc = "New Web API project" })

-- Create new C# class
map("n", "<leader>nc", function()
  local name = vim.fn.input("Class name: ")
  if name ~= "" then
    run_in_terminal("dotnet new class -n " .. name)
  end
end, { desc = "New C# class" })

-- Create new interface
map("n", "<leader>ni", function()
  local name = vim.fn.input("Interface name: ")
  if name ~= "" then
    run_in_terminal("dotnet new interface -n " .. name)
  end
end, { desc = "New C# interface" })

-- Add project to solution
map("n", "<leader>np", function()
  local project = vim.fn.input("Project path (.csproj): ")
  if project ~= "" then
    run_in_terminal("dotnet sln add " .. project)
  end
end, { desc = "Add project to solution" })

-- Create new solution
map("n", "<leader>ns", function()
  local name = vim.fn.input("Solution name: ")
  if name ~= "" then
    run_in_terminal("dotnet new sln -n " .. name)
  end
end, { desc = "New solution" })

-- Add NuGet package
map("n", "<leader>ng", function()
  local package = vim.fn.input("Package name: ")
  if package ~= "" then
    run_in_terminal("dotnet add package " .. package)
  end
end, { desc = "Add NuGet package" })

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

-- Open terminal in split
map("n", "<leader>th", ":botright 10split | terminal<CR>i", { desc = "Terminal horizontal split" })
map("n", "<leader>tv", ":botright 80vsplit | terminal<CR>i", { desc = "Terminal vertical split" })

-- Exit terminal mode with Esc
map("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Close current window/pane
map("n", "<leader>w", function()
  local current_win = vim.api.nvim_get_current_win()
  vim.cmd("close")
  
  if current_win == terminal_win then
    terminal_win = nil
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
map("t", "<A-=>", "<C-\\><C-n>:resize 20<CR>i", { desc = "Terminal: medium height" })
map("t", "<A-+>", "<C-\\><C-n>:resize 30<CR>i", { desc = "Terminal: large height" })
map("t", "<A-->", "<C-\\><C-n>:resize 10<CR>i", { desc = "Terminal: small height" })

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