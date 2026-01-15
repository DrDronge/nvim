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

vim.opt.termguicolors = true

-- Line numbers
vim.opt.number = true
vim.opt.relativenumber = false
vim.opt.numberwidth = 4

-- Performance improvements
vim.opt.updatetime = 250
vim.opt.timeoutlen = 300
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
  vim.opt.guicursor = "n-v-c:block,i-ci-ve:ver25,r-cr:hor20,o:hor50"
  vim.opt.ttimeoutlen = 10
  vim.opt.redrawtime = 1500

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
    cache = {
      enabled = true,
    },
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

require("nvim-tree").setup({
  sync_root_with_cwd = false,
  respect_buf_cwd = false,
  update_focused_file = {
    enable = true,
    update_root = false,
  },
  filesystem_watchers = {
    enable = true,
    debounce_delay = 50,
    ignore_dirs = {
      "node_modules",
      ".git",
      "bin",
      "obj",
      ".vs",
      ".vscode",
      ".idea",
    },
  },
  git = {
    enable = true,
    ignore = false,
    timeout = 400,
  },
  view = {
    width = 30,
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = false,
    custom = { "^.git$", "^node_modules$", "^bin$", "^obj$" },
  },
})

require("lsp")
require("mappings")

vim.cmd.colorscheme("vaporwave")

require("nvim-treesitter.configs").setup({
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = { enable = true },
})