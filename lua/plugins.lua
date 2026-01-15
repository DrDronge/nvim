return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      defaults = {
        path_display = { "truncate" },
        layout_strategy = "horizontal",
        layout_config = {
          horizontal = {
            prompt_position = "top",
            preview_width = 0.55,
            results_width = 0.8,
          },
          width = 0.87,
          height = 0.80,
          preview_cutoff = 120,
        },
        sorting_strategy = "ascending",
        file_ignore_patterns = { 
          "^%.git/",        -- .git at start
          "/%.git/",        -- .git in path
          "%.git$",         -- .git at end
          "node_modules/",
          "bin/",
          "obj/",
          "%.dll$",
          "%.pdb$",
          "%.exe$",
          "%.cache$",
          "lazy%-lock%.json",
          "/lazy/",
          "/site/pack/",
          "/plugged/",
          "%.vs/",
          "%.vscode/",
        },
      },
      pickers = {
        find_files = {
          hidden = true,
          follow = true,
        },
      },
    },
  },
  
  { "stevearc/oil.nvim", cmd = "Oil", opts = {} },
  
  {
    "nvim-treesitter/nvim-treesitter",
    event = { "BufReadPost", "BufNewFile" },
    build = ":TSUpdate",
    config = function()
      if vim.fn.has("win32") == 1 then
        require("nvim-treesitter.install").compilers = { "zig" }
      end

      require("nvim-treesitter.configs").setup({
        ensure_installed = { "c_sharp", "lua", "vim" },
        auto_install = true,
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        indent = { enable = true },
      })

      vim.filetype.add({ extension = { cs = "cs" } })
    end,
  },

  { "neovim/nvim-lspconfig" },

  {
    "saghen/blink.cmp",
    dependencies = { "rafamadriz/friendly-snippets" },
    version = "*",
    build = vim.fn.has("win32") == 1 and "pwsh -c .\\build.ps1" or "cargo build --release",
    opts = {
      keymap = { preset = "default" },
      appearance = {
        use_nvim_cmp_as_default = true,
        nerd_font_variant = "mono",
      },
      completion = {
        documentation = {
          auto_show = true,
          auto_show_delay_ms = 500,
        },
      },
      sources = {
        default = { "lsp", "path", "snippets", "buffer" },
      },
      signature = { enabled = true },
    },
    opts_extend = { "sources.default" },
  },
  
  { 
    "lewis6991/gitsigns.nvim",
    event = { "BufReadPost", "BufNewFile" },
    opts = {
      signs = {
        add = { text = "+" },
        change = { text = "~" },
        delete = { text = "_" },
      },
    },
  },
  
  { "nvim-lualine/lualine.nvim", event = "VeryLazy", opts = {} },
  { "saghen/blink.indent" },
  { "rachartier/tiny-inline-diagnostic.nvim", event = "LspAttach", opts = {} },
  { "folke/which-key.nvim", event = "VeryLazy", opts = {} },
  { "folke/todo-comments.nvim", event = { "BufReadPost", "BufNewFile" }, opts = {} },
  { "akinsho/git-conflict.nvim", event = "VeryLazy", opts = {} },
  { "sethen/line-number-change-mode.nvim" },
  
  {
    "nvim-tree/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
  },
  
  { "nvim-tree/nvim-web-devicons", lazy = true },
  { "olimorris/onedarkpro.nvim", priority = 1000 },
  
  {
    "mfussenegger/nvim-dap",
    cmd = { "DapToggleBreakpoint", "DapContinue" },
    dependencies = { "rcarriga/nvim-dap-ui", "nvim-neotest/nvim-nio" },
  },

  { "Decodetalkers/csharpls-extended-lsp.nvim", ft = "cs" },
  { "nvimtools/none-ls.nvim", event = "LspAttach", dependencies = { "nvim-lua/plenary.nvim" } },
  { "windwp/nvim-autopairs", event = "InsertEnter", opts = {} },
  { "numToStr/Comment.nvim", keys = { "gc", "gb" }, opts = {} },
  { "kylechui/nvim-surround", event = "VeryLazy", opts = {} },
  { "nvim-pack/nvim-spectre", cmd = "Spectre" },
  { "windwp/nvim-ts-autotag", ft = { "html", "xml" } },
  { "williamboman/mason.nvim", cmd = "Mason", opts = {} },
  { "williamboman/mason-lspconfig.nvim", lazy = true, opts = {} },
  
  {
    "j-hui/fidget.nvim",
    event = "LspAttach",
    opts = {
      notification = {
        window = {
          winblend = 0,
        },
      },
    },
  },
}