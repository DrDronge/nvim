return {
  -- Fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      defaults = {
        prompt_prefix = "> ",
        selection_caret = "> ",
        sorting_strategy = "ascending",
        layout_strategy = "horizontal",
        layout_config = { prompt_position = "top" },
      },
    },
    config = function(_, opts)
      require("telescope").setup(opts)
    end,

  -- File browser (Oil)
  { "stevearc/oil.nvim", opts = {} },

  -- Syntax highlighting & parsing
  { "nvim-treesitter/nvim-treesitter", build = ":TSUpdate" },

  -- LSP (Language Server Protocol)
  { "neovim/nvim-lspconfig" },

  -- Autocompletion
  { "hrsh7th/nvim-cmp" },
  { "hrsh7th/cmp-nvim-lsp" },
  { "L3MON4D3/LuaSnip" },

  -- Git integration
  { "lewis6991/gitsigns.nvim" },

  -- Status line
  { "nvim-lualine/lualine.nvim" },
},
}
