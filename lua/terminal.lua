local M = {}

-- Constants
local TERMINAL_HEIGHT = 10
local COMMAND_DELAY_MS = 100
local CTRL_C = "\x03"
local ENTER = "\r"

-- State
local terminal_win = nil

-- Check if terminal window is valid and active
local function is_terminal_valid(win, buf)
  if not win or not vim.api.nvim_win_is_valid(win) then
    return false
  end
  
  if not buf or not vim.api.nvim_buf_is_valid(buf) then
    return false
  end
  
  local ok, chan = pcall(vim.api.nvim_buf_get_var, buf, "terminal_job_id")
  return ok and chan ~= nil
end

-- Send command to existing terminal
local function send_to_terminal(chan, cmd)
  local interrupt_ok = pcall(vim.api.nvim_chan_send, chan, CTRL_C)
  
  if not interrupt_ok then
    return false
  end
  
  vim.defer_fn(function()
    pcall(vim.api.nvim_chan_send, chan, cmd .. ENTER)
  end, COMMAND_DELAY_MS)
  
  return true
end

-- Create new terminal in window
local function create_terminal_in_window(win, cmd)
  vim.api.nvim_set_current_win(win)
  vim.cmd("terminal " .. cmd)
  vim.cmd("startinsert")
end

-- Create new terminal split
local function create_terminal_split(cmd)
  vim.cmd(string.format("botright %dsplit | terminal %s", TERMINAL_HEIGHT, cmd))
  terminal_win = vim.api.nvim_get_current_win()
  vim.cmd("startinsert")
  
  vim.api.nvim_create_autocmd("WinClosed", {
    pattern = tostring(terminal_win),
    callback = function()
      terminal_win = nil
    end,
    once = true,
  })
end

-- Get working directory from NvimTree or fallback to cwd
local function get_working_directory()
  if vim.bo.filetype == "NvimTree" then
    local ok, api = pcall(require, "nvim-tree.api")
    if ok then
      local node = api.tree.get_node_under_cursor()
      if node and node.type == "directory" then
        return node.absolute_path
      end
    end
  end
  
  local ok, api = pcall(require, "nvim-tree.api")
  if ok then
    local tree = api.tree.get_nodes()
    if tree and tree.absolute_path then
      return tree.absolute_path
    end
  end
  
  return vim.fn.getcwd()
end

-- Build full command with directory change
local function build_command(cmd, dir)
  if not dir then
    return cmd
  end
  return "cd " .. vim.fn.fnameescape(dir) .. " && " .. cmd
end

-- Run command in persistent terminal
function M.run(cmd)
  local dir = get_working_directory()
  local full_cmd = build_command(cmd, dir)
  
  if not terminal_win or not vim.api.nvim_win_is_valid(terminal_win) then
    create_terminal_split(full_cmd)
    return
  end
  
  local buf = vim.api.nvim_win_get_buf(terminal_win)
  local ok, chan = pcall(vim.api.nvim_buf_get_var, buf, "terminal_job_id")
  
  if ok and chan and vim.api.nvim_buf_is_valid(buf) then
    if send_to_terminal(chan, full_cmd) then
      vim.api.nvim_set_current_win(terminal_win)
      vim.cmd("startinsert")
      return
    end
  end
  
  create_terminal_in_window(terminal_win, full_cmd)
end

-- Get current terminal window ID
function M.get_terminal_win()
  return terminal_win
end

-- Clear terminal window reference
function M.clear_terminal_win()
  terminal_win = nil
end

return M
