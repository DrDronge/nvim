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
vim.opt.number = true         -- Show absolute line numbers
vim.opt.relativenumber = false -- Show relative line numbers (useful for motions)
vim.opt.numberwidth = 4       -- Width of the number column

-- Enable filetype detection and syntax
vim.cmd([[
  filetype plugin indent on
  syntax enable
]])
-- Plugin setup
require("lazy").setup("plugins")
require("nvim-tree").setup()
-- require("settings")
require("mappings")

vim.cmd.colorscheme("onedark")

require("nvim-treesitter.configs").setup({
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = { enable = true },
})

