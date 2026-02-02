-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", lazypath })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "
vim.g.maplocalleader = " "
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

vim.opt.autochdir = false  -- Do NOT auto-change directory on file open
vim.opt.termguicolors = true

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.numberwidth = 4

-- Performance improvements
local UPDATE_TIME_MS = 250
local TIMEOUT_LEN_MS = 300

vim.opt.updatetime = UPDATE_TIME_MS
vim.opt.timeoutlen = TIMEOUT_LEN_MS
vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.writebackup = false

-- OS-specific shell configuration
if vim.fn.has("win32") == 1 then
  -- Windows: Use CMD for internal shell commands (faster than PowerShell)
  vim.opt.shell = "cmd.exe"
  vim.opt.shellcmdflag = "/c"
  vim.opt.shellquote = ""
  vim.opt.shellxquote = ""
else
  -- Mac/Linux: Use default shell (zsh/bash)
  -- This is already the default, but explicitly setting for clarity
  vim.opt.shell = vim.o.shell or "/bin/zsh"
end

-- Fix for Windows terminal focus issues
if vim.fn.has("win32") == 1 then
  local TTIMEOUT_MS = 10
  local REDRAW_TIME_MS = 1500
  
  vim.opt.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50"
  vim.opt.ttimeoutlen = TTIMEOUT_MS
  vim.opt.redrawtime = REDRAW_TIME_MS

  -- Auto-redraw on focus gain (fixes tab-out freeze)
  vim.api.nvim_create_autocmd({ "FocusGained", "BufEnter" }, {
    pattern = "*",
    command = "checktime",
  })

  vim.api.nvim_create_autocmd("FocusGained", {
    pattern = "*",
    callback = function()
      vim.cmd("redraw!")
    end,
  })
end

-- Enable filetype detection and syntax
vim.cmd([[
  filetype plugin indent on
  syntax enable
]])

-- Plugin setup with performance optimization
require("lazy").setup("plugins", {
  performance = {
    cache = { enabled = true },
    rtp = {
      disabled_plugins = {
        "gzip",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

require("lsp")
require("mappings").setup()

vim.cmd.colorscheme("vaporwave")

require("lualine").setup({
  options = {
    theme = "auto",
    component_separators = { left = "|", right = "|" },
    section_separators = { left = "", right = "" },
  },
  sections = {
    lualine_a = { "mode" },
    lualine_b = { "branch", "diff", "diagnostics" },
    lualine_c = { "filename" },
    lualine_x = { "encoding", "fileformat", "filetype" },
    lualine_y = { "progress" },
    lualine_z = { "location" },
  },
  tabline = {
    lualine_a = {
      {
        function()
          local cwd = vim.fn.getcwd()
          local parts = vim.split(cwd, "\\")
          if #parts > 2 then
            return " " .. parts[#parts - 1] .. "/" .. parts[#parts]
          end
          return " " .. vim.fn.fnamemodify(cwd, ":t")
        end,
        color = { gui = "bold" },
      },
    },
    lualine_b = {
      {
        "buffers",
        -- Filter out terminal buffers from tabline
        buffers_color = {
          active = { fg = "#ffffff", bg = "#3b4261" },
          inactive = { fg = "#7aa2f7", bg = "#1f2335" },
        },
        show_filename_only = true,
        show_modified_status = true,
        mode = 0, -- Shows buffer name
        max_length = vim.o.columns * 2 / 3,
        -- Only show non-terminal buffers
        filetype_names = {
          TelescopePrompt = "Telescope",
          dashboard = "Dashboard",
          lazy = "Lazy",
          mason = "Mason",
        },
        symbols = {
          modified = " ●",
          alternate_file = "",
          directory = "",
        },
        -- Filter function to exclude terminals
        buffers_filter = function(buf)
          local buftype = vim.api.nvim_buf_get_option(buf, "buftype")
          return buftype ~= "terminal"
        end,
      },
    },
    lualine_c = {},
    lualine_x = {},
    lualine_y = {},
    lualine_z = { "tabs" },
  },
  winbar = {
    lualine_c = {
      {
        function()
          -- Show terminal buffers in the terminal window's winbar
          local buftype = vim.bo.buftype
          if buftype == "terminal" then
            local term_list = {}
            local current_buf = vim.api.nvim_get_current_buf()
            
            -- Get all terminal buffers
            for _, buf in ipairs(vim.api.nvim_list_bufs()) do
              if vim.api.nvim_buf_is_valid(buf) and vim.api.nvim_buf_get_option(buf, "buftype") == "terminal" then
                local term_name = vim.api.nvim_buf_get_name(buf)
                local term_num = term_name:match("term://.*//(%d+):")
                local is_current = buf == current_buf
                
                if is_current then
                  table.insert(term_list, "%#TabLineSel# Terminal " .. (term_num or "?") .. " %*")
                else
                  table.insert(term_list, "%#TabLine# Terminal " .. (term_num or "?") .. " %*")
                end
              end
            end
            
            return table.concat(term_list, " | ")
          end
          return ""
        end,
      },
    },
  },
})
