local tree_keymaps = require("mappings").nvim_tree_on_attach

-- Constants
local TREE_WIDTH = 30
local WATCHER_DEBOUNCE_MS = 100
local GIT_TIMEOUT_MS = 8000
local MAX_FILE_LENGTH = 10000
local GITSIGNS_DEBOUNCE_MS = 200
local GITSIGNS_WATCH_INTERVAL_MS = 1000
local DOC_DELAY_MS = 500

return {
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = {"nvim-tree/nvim-web-devicons"},
        config = function()
            require("nvim-tree").setup({
                on_attach = tree_keymaps,

                sync_root_with_cwd = true,
                respect_buf_cwd = true,

                update_focused_file = {
                    enable = true,
                    update_root = false
                },

                filesystem_watchers = {
                    enable = true,
                    debounce_delay = WATCHER_DEBOUNCE_MS,
                    ignore_dirs = {"node_modules", ".git", "bin", "obj", ".vs", ".vscode", ".idea"}
                },

                git = {
                    enable = true,
                    ignore = false,
                    timeout = GIT_TIMEOUT_MS
                },

                view = {
                    width = TREE_WIDTH,
                    float = {
                        enable = false
                    }
                },

                renderer = {
                    group_empty = true,
                    root_folder_label = function(path)
                        return " " .. vim.fn.fnamemodify(path, ":~")
                    end
                },

                filters = {
                    dotfiles = false,
                    custom = {"^.git$", "^node_modules$", "^bin$", "^obj$"}
                },

                actions = {
                    open_file = {
                        resize_window = false
                    },
                    change_dir = {
                        enable = true,
                        global = true
                    }
                }
            })
        end
    }, {
        "nvim-telescope/telescope.nvim",
        cmd = "Telescope",
        dependencies = {"nvim-lua/plenary.nvim"},
        opts = {
            defaults = {
                path_display = {"truncate"},
                layout_strategy = "horizontal",
                layout_config = {
                    horizontal = {
                        prompt_position = "top",
                        preview_width = 0.55,
                        results_width = 0.8
                    },
                    width = 0.87,
                    height = 0.80,
                    preview_cutoff = 120
                },
                sorting_strategy = "ascending",
                file_ignore_patterns = {
                    "^%.git/", -- .git at start
                    "/%.git/", -- .git in path
                    "%.git$", -- .git at end
                    "node_modules/", "bin/", "obj/", "%.dll$", "%.pdb$", "%.exe$", "%.cache$", "lazy%-lock%.json",
                    "/lazy/", "/site/pack/", "/plugged/", "%.vs/", "%.vscode/"
                }
            },
            pickers = {
                find_files = {
                    hidden = true,
                    follow = true
                }
            }
        }
    }, {
        "stevearc/oil.nvim",
        cmd = "Oil",
        opts = {}
    }, {
        "nvim-treesitter/nvim-treesitter",
        event = {"BufReadPost", "BufNewFile"},
        build = ":TSUpdate",
        config = function()
            if vim.fn.has("win32") == 1 then
                require("nvim-treesitter.install").compilers = {"zig"}
            end

            require("nvim-treesitter.configs").setup({
                ensure_installed = {"c_sharp", "lua", "vim", "rust", "toml"},
                auto_install = true,
                highlight = {
                    enable = true,
                    additional_vim_regex_highlighting = false
                },
                indent = {
                    enable = true
                }
            })

            vim.filetype.add({
                extension = {
                    cs = "cs",
                    rs = "rust"
                }
            })
        end
    }, {"neovim/nvim-lspconfig"}, {
        "saghen/blink.cmp",
        dependencies = {"rafamadriz/friendly-snippets"},
        version = "*",
        build = vim.fn.has("win32") == 1 and "pwsh -c .\\build.ps1",
        opts = {
            keymap = {
                preset = "default"
            },
            appearance = {
                use_nvim_cmp_as_default = true,
                nerd_font_variant = "mono"
            },
            completion = {
                documentation = {
                    auto_show = true,
                    auto_show_delay_ms = DOC_DELAY_MS
                }
            },
            sources = {
                default = {"lsp", "path", "snippets", "buffer"}
            },
            signature = {
                enabled = true
            }
        },
        opts_extend = {"sources.default"}
    }, {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPre", "BufNewFile" },
  opts = {
    signs = {
      add = { text = "+" },
      change = { text = "~" },
      delete = { text = "_" },
      topdelete = { text = "‾" },
      changedelete = { text = "~" },
      untracked = { text = "┆" },
    },
    watch_gitdir = {
      interval = GITSIGNS_WATCH_INTERVAL_MS,
      follow_files = true,
    },
    current_line_blame = false,
    max_file_length = MAX_FILE_LENGTH,
    update_debounce = GITSIGNS_DEBOUNCE_MS,
  },
}, {
        "nvim-lualine/lualine.nvim",
        event = "VeryLazy",
        opts = {}
    }, {"saghen/blink.indent"}, {
        "rachartier/tiny-inline-diagnostic.nvim",
        event = "LspAttach",
        opts = {}
    }, {
        "folke/which-key.nvim",
        event = "VeryLazy",
        opts = {}
    }, {
        "folke/todo-comments.nvim",
        event = {"BufReadPost", "BufNewFile"},
        opts = {}
    }, {
        "sindrets/diffview.nvim",
        cmd = {"DiffviewOpen", "DiffviewClose", "DiffviewFileHistory"},
        opts = {
            enhanced_diff_hl = true,
            view = {
                default = {
                    layout = "diff2_horizontal"
                },
                merge_tool = {
                    layout = "diff3_horizontal"
                }
            }
        }
    }, {"sethen/line-number-change-mode.nvim"}, {
        "nvim-tree/nvim-web-devicons",
        lazy = true
    }, {
        "olimorris/onedarkpro.nvim",
        priority = 1000
    }, {
        "mfussenegger/nvim-dap",
        cmd = {"DapToggleBreakpoint", "DapContinue"},
        dependencies = {"rcarriga/nvim-dap-ui", "nvim-neotest/nvim-nio"}
    }, {
        "Decodetalkers/csharpls-extended-lsp.nvim",
        ft = "cs"
    }, {
        "nvimtools/none-ls.nvim",
        event = "LspAttach",
        dependencies = {"nvim-lua/plenary.nvim"}
    }, {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = {}
    }, {
        "numToStr/Comment.nvim",
        keys = {"gc", "gb"},
        opts = {}
    }, {
        "kylechui/nvim-surround",
        event = "VeryLazy",
        opts = {}
    }, {
        "nvim-pack/nvim-spectre",
        cmd = "Spectre"
    }, {
        "windwp/nvim-ts-autotag",
        ft = {"html", "xml"}
    }, {
        "williamboman/mason.nvim",
        cmd = "Mason",
        opts = {}
    }, {
        "williamboman/mason-lspconfig.nvim",
        lazy = true,
        opts = {}
    }, {
        "j-hui/fidget.nvim",
        event = "LspAttach",
        opts = {
            notification = {
                window = {
                    winblend = 0
                }
            }
        }
    }, -- Rust plugins
    {
        "mrcjkb/rustaceanvim",
        version = "^5",
        lazy = false,
        ft = {"rust"},
        config = function()
            vim.g.rustaceanvim = {
                server = {
                    on_attach = function(client, bufnr)
                        -- Enable inlay hints
                        vim.lsp.inlay_hint.enable(true, {
                            bufnr = bufnr
                        })
                    end,
                    default_settings = {
                        ["rust-analyzer"] = {
                            cargo = {
                                allFeatures = true,
                                loadOutDirsFromCheck = true,
                                buildScripts = {
                                    enable = true
                                }
                            },
                            checkOnSave = true,
                            check = {
                                command = "clippy"
                            },
                            procMacro = {
                                enable = true
                            }
                        }
                    }
                }
            }
        end
    }, {
        "saecki/crates.nvim",
        event = {"BufRead Cargo.toml"},
        config = function()
            require("crates").setup({
                lsp = {
                    enabled = true,
                    actions = true,
                    completion = true,
                    hover = true
                }
            })
        end
    }, {
        "b0o/schemastore.nvim",
        lazy = true
    }
}
