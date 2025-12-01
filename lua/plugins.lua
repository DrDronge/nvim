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
  { "saghen/Blink.cmp",
    dependencies = { "rafamadriz/friendly-snippets" },
    
    --- @module "blink.cmp"
    --- @type blink.cmp.Config
    opts = {
	keymap = { preset = "default" },
	
	appearance = { nerd_font_variant = "mono" },

	completion = { documentation = { auto_show = false } },

	sources = { default = { "lsp", "path", "snippets", "buffer" } },

	fuzzy = { implementation = "prefer_rust" }
    },
    opts_extend = { "sources.default" }
    },

  -- Git integration
  { "lewis6991/gitsigns.nvim" },

  -- Status line
  { "nvim-lualine/lualine.nvim" },

  -- Indentation
  { "saghen/blink.indent" },

  -- Diagnostic
  { "rachartier/tiny-inline-diagnostic.nvim" },
  
  -- Mappings helper
  { "folke/which-key.nvim" },

  -- Todo
  { "folke/todo-comments.nvim" },

  -- Git conflicts
  { "akinsho/git-conflict.nvim" },

  -- Line number change mode
  { "sethen/line-number-change-mode.nvim" },

  -- File explorer
  { "nvim-tree/nvim-tree.lua",
	sort = {
		sorter = "case_sensitive",
	},
	view = {
		width = 30,
	},
	renderer = {
		group_empty = true,
	},
	filters = {
		dotfiles = true,
	},
  },
  { "nvim-tree/nvim-web-devicons"}
},
}
