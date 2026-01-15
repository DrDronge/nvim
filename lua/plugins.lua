return {
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    dependencies = { "nvim-lua/plenary.nvim" },
    opts = {
      defaults = {
        file_ignore_patterns = { 
          "node_modules",
          "%.git/",
          "bin/",
          "obj/",
          "%.dll$",
          "%.pdb$",
          "%.cache$",
        },
        vimgrep_arguments = {
          "rg",
          "--color=never",
          "--no-heading",
          "--with-filename",
          "--line-number",
          "--column",
          "--smart-case",
          "--hidden",
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
}