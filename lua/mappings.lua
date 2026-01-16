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
map("n", "<leader>X", ":bdelete!<CR>", {desc = "Force close buffer" })

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

-- ========================================
-- BUILD & RUN (C# / .NET) - Now Async!
-- ========================================

-- Build current project (in terminal)
map("n", "<F5>", function()
  vim.cmd("w") -- Save first
  run_in_terminal("dotnet build")
end, { desc = "Build .NET project" })

-- Run current project (in terminal)
map("n", "<F6>", function()
  vim.cmd("w") -- Save first
  run_in_terminal("dotnet run")
end, { desc = "Run .NET project" })

-- Build and run (in terminal)
map("n", "<leader>br", function()
  vim.cmd("w")
  run_in_terminal("dotnet build && dotnet run")
end, { desc = "Build and run" })

-- Run tests (in terminal)
map("n", "<leader>bt", function()
  run_in_terminal("dotnet test")
end, { desc = "Run .NET tests" })

-- Clean build (in terminal)
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
-- .NET PROJECT MANAGEMENT - Now Async!
-- ========================================

-- Create new console app (async)
map("n", "<leader>nco", function()
  local name = vim.fn.input("Console project name: ")
  if name ~= "" then
    run_in_terminal("dotnet new console -n " .. name)
  end
end, { desc = "New console project" })

-- Create new class library (async)
map("n", "<leader>nl", function()
  local name = vim.fn.input("Library name: ")
  if name ~= "" then
    run_in_terminal("dotnet new classlib -n " .. name)
  end
end, { desc = "New class library" })

-- Create new web API (async)
map("n", "<leader>na", function()
  local name = vim.fn.input("API name: ")
  if name ~= "" then
    run_in_terminal("dotnet new webapi -n " .. name)
  end
end, { desc = "New Web API project" })

-- Create new C# class (async)
map("n", "<leader>nc", function()
  local name = vim.fn.input("Class name: ")
  if name ~= "" then
    run_in_terminal("dotnet new class -n " .. name)
  end
end, { desc = "New C# class" })

-- Create new interface (async)
map("n", "<leader>ni", function()
  local name = vim.fn.input("Interface name: ")
  if name ~= "" then
    run_in_terminal("dotnet new interface -n " .. name)
  end
end, { desc = "New C# interface" })

-- Add project to solution (async)
map("n", "<leader>np", function()
  local project = vim.fn.input("Project path (.csproj): ")
  if project ~= "" then
    run_in_terminal("dotnet sln add " .. project)
  end
end, { desc = "Add project to solution" })

-- Create new solution (async)
map("n", "<leader>ns", function()
  local name = vim.fn.input("Solution name: ")
  if name ~= "" then
    run_in_terminal("dotnet new sln -n " .. name)
  end
end, { desc = "New solution" })

-- Add NuGet package (async)
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

-- Change to project root (finds .git, .sln, etc.)
map("n", "<leader>cr", function()
  local root_patterns = { ".git", "*.sln", "*.csproj" }
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

-- Open terminal in split (15 lines high)
map("n", "<leader>th", ":botright 10split | terminal<CR>i", { desc = "Terminal horizontal split" })

-- Open terminal in vertical split (80 columns wide)
map("n", "<leader>tv", ":botright 70vsplit | terminal<CR>i", { desc = "Terminal vertical split" })

-- Exit terminal mode with Esc
map("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })

-- Close current window/pane (works for terminal too!)
map("n", "<leader>w", ":close<CR>", { desc = "Close current window" })

-- Close terminal and window at once (from terminal mode)
map("t", "<C-q>", "<C-\\><C-n>:close<CR>", { desc = "Close terminal" })

-- Resize terminal/window from terminal mode
map("t", "<C-Up>", "<C-\\><C-n>:resize +2<CR>i", { desc = "Increase terminal height" })
map("t", "<C-Down>", "<C-\\><C-n>:resize -2<CR>i", { desc = "Decrease terminal height" })
map("t", "<C-Left>", "<C-\\><C-n>:vertical resize +2<CR>i", { desc = "Decrease terminal width" })
map("t", "<C-Right>", "<C-\\><C-n>:vertical resize -2<CR>i", { desc = "Increase terminal width" })

-- Quick resize terminal to specific sizes (from terminal mode)
map("t", "<A-=>", "<C-\\><C-n>:resize 20<CR>i", { desc = "Terminal: medium height" })
map("t", "<A-+>", "<C-\\><C-n>:resize 30<CR>i", { desc = "Terminal: large height" })
map("t", "<A-->", "<C-\\><C-n>:resize 10<CR>i", { desc = "Terminal: small height" })