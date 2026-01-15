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
  },

  -- File browser (Oil)
  { "stevearc/oil.nvim", opts = {} },

  -- Syntax highlighting & parsing
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    config = function()
      -- Platform-specific configuration for treesitter
      if vim.fn.has("win32") == 1 then
        -- Windows: Use Zig to avoid MSVC requirement
        require("nvim-treesitter.install").compilers = { "zig" }
      else
        -- Linux/Mac: Use system compilers (gcc, clang are usually available)
        require("nvim-treesitter.install").compilers = { "gcc", "clang", "cc" }
      end
      
      require("nvim-treesitter.configs").setup({
        ensure_installed = {
            "c_sharp",
            "lua",
            "vim"
        },
        sync_install = false,
        auto_install = true,  -- Safe to enable on Linux/Mac with system compilers
        highlight = {
          enable = true,
          -- Disable vim's regex highlighting
          additional_vim_regex_highlighting = false,
        },
        indent = {
          enable = true,
        },
      })
      
      -- Ensure C# files are recognized
      vim.filetype.add({
        extension = {
          cs = "cs",
        },
      })
    end,
  },

  -- LSP (Language Server Protocol)
  { "neovim/nvim-lspconfig" },

  -- Autocompletion
  {
    "saghen/blink.cmp",
    dependencies = { "rafamadriz/friendly-snippets" },
    version = "*",
    -- Platform-specific build command
    build = vim.fn.has("win32") == 1 and "pwsh -c .\\build.ps1" or "cargo build --release",
    --- @module "blink.cmp"
    --- @type blink.cmp.Config
    opts = {
      keymap = { preset = "default" },
      
      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = "mono"
      },

      completion = {
        documentation = { auto_show = true, auto_show_delay_ms = 500 }
      },

      sources = {
        default = { "lsp", "path", "snippets", "buffer" }
      },

      signature = { enabled = true }
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
  { "nvim-tree/nvim-web-devicons"},
  { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
}
