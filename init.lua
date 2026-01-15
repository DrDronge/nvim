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
require("catppuccin").setup({
	auto_integrations = true,
	integrations = {
		treesitter = true,
	},
})
vim.cmd.colorscheme("catppuccin")
-- require("plugins")
require("mason").setup({
    registries = {
        "github:mason-org/mason-registry",
        "github:Crashdummyy/mason-registry",
    },
})
require("nvim-treesitter.configs").setup({
  highlight = {
    enable = true,
    additional_vim_regex_highlighting = false,
  },
  indent = { enable = true },
})

