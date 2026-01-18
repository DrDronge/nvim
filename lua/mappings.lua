local M = {}

local map = vim.keymap.set

-- =====================================================
-- GLOBAL KEYMAPS
-- =====================================================
function M.setup()
  -- GENERAL
  map("n", "<C-n>", ":NvimTreeToggle<CR>", { desc = "Toggle file tree" })
  map("n", "<leader>e", ":NvimTreeFocus<CR>", { desc = "Focus file tree" })
  map("n", "<leader>b", "<C-w>p", { desc = "Back to last window" })

  -- TELESCOPE
  map("n", "<leader>ff", ":Telescope find_files<CR>", { desc = "Find files" })
  map("n", "<leader>fa", function()
    require("telescope.builtin").find_files({ cwd = vim.fn.stdpath("config") })
  end, { desc = "Find nvim config files" })
  map("n", "<leader>fg", ":Telescope live_grep<CR>", { desc = "Live grep" })
  map("n", "<leader>fb", ":Telescope buffers<CR>", { desc = "Find buffers" })
  map("n", "<leader>fh", ":Telescope help_tags<CR>", { desc = "Help tags" })
  map("n", "<leader>fr", ":Telescope oldfiles<CR>", { desc = "Recent files" })

  -- OIL
  map("n", "-", ":Oil<CR>", { desc = "Open parent directory" })

  -- LSP
  map("n", "gD", vim.lsp.buf.declaration, { desc = "Go to declaration" })
  map("n", "gd", vim.lsp.buf.definition, { desc = "Go to definition" })
  map("n", "K", vim.lsp.buf.hover, { desc = "Hover docs" })
  map("n", "gi", vim.lsp.buf.implementation, { desc = "Go to implementation" })
  map("n", "<C-k>", vim.lsp.buf.signature_help, { desc = "Signature help" })
  map("n", "<leader>rn", vim.lsp.buf.rename, { desc = "Rename symbol" })
  map("n", "<leader>ca", vim.lsp.buf.code_action, { desc = "Code action" })
  map("n", "gr", vim.lsp.buf.references, { desc = "References" })
  map("n", "<leader>f", function()
    vim.lsp.buf.format({ async = true })
  end, { desc = "Format buffer" })

  -- DIAGNOSTICS
  map("n", "<leader>d", vim.diagnostic.open_float, { desc = "Show diagnostic" })
  map("n", "[d", vim.diagnostic.goto_prev, { desc = "Previous diagnostic" })
  map("n", "]d", vim.diagnostic.goto_next, { desc = "Next diagnostic" })
  map("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Diagnostics list" })

  -- BUFFERS
  map("n", "<Tab>", ":bnext<CR>", { desc = "Next buffer" })
  map("n", "<S-Tab>", ":bprevious<CR>", { desc = "Previous buffer" })
  map("n", "<leader>x", ":bdelete<CR>", { desc = "Close buffer" })
  map("n", "<leader>X", ":bdelete!<CR>", { desc = "Force close buffer" })

  -- WINDOW NAVIGATION
  map("n", "<C-h>", "<C-w>h", { desc = "Left window" })
  map("n", "<C-j>", "<C-w>j", { desc = "Down window" })
  map("n", "<C-k>", "<C-w>k", { desc = "Up window" })
  map("n", "<C-l>", "<C-w>l", { desc = "Right window" })

  -- WINDOW RESIZE (ALT + HJKL — MAC SAFE)
  map("n", "<A-h>", ":vertical resize -2<CR>", { desc = "Shrink width" })
  map("n", "<A-l>", ":vertical resize +2<CR>", { desc = "Grow width" })
  map("n", "<A-j>", ":resize -2<CR>", { desc = "Shrink height" })
  map("n", "<A-k>", ":resize +2<CR>", { desc = "Grow height" })

  -- TERMINAL MODE RESIZE
  map("t", "<A-h>", "<C-\\><C-n>:vertical resize -2<CR>i", { desc = "Terminal shrink width" })
  map("t", "<A-l>", "<C-\\><C-n>:vertical resize +2<CR>i", { desc = "Terminal grow width" })
  map("t", "<A-j>", "<C-\\><C-n>:resize -2<CR>i", { desc = "Terminal shrink height" })
  map("t", "<A-k>", "<C-\\><C-n>:resize +2<CR>i", { desc = "Terminal grow height" })

  -- MOVE LINES
  map("n", "<C-A-j>", ":m .+1<CR>==", { desc = "Move line down" })
  map("n", "<C-A-k>", ":m .-2<CR>==", { desc = "Move line up" })
  map("v", "<C-A-j>", ":m '>+1<CR>gv=gv", { desc = "Move selection down" })
  map("v", "<C-A-k>", ":m '<-2<CR>gv=gv", { desc = "Move selection up" })

  -- TERMINAL
  map("n", "<leader>th", ":botright 10split | terminal<CR>i", { desc = "Terminal horizontal" })
  map("n", "<leader>tv", ":botright 70vsplit | terminal<CR>i", { desc = "Terminal vertical" })
  map("t", "<Esc>", "<C-\\><C-n>", { desc = "Exit terminal mode" })
  map("t", "<C-q>", "<C-\\><C-n>:close<CR>", { desc = "Close terminal" })

  -- SAVE / QUIT
  map("n", "<C-s>", ":w<CR>", { desc = "Save file" })
  map("n", "<C-q>", ":q<CR>", { desc = "Quit" })

  -- CLEAR SEARCH
  map("n", "<Esc>", ":noh<CR>", { desc = "Clear highlight" })
end

-- =====================================================
-- NVIM-TREE KEYMAPS (BUFFER-LOCAL, ON_ATTACH)
-- =====================================================
function M.nvim_tree_on_attach(bufnr)
  local api = require("nvim-tree.api")

  local function opts(desc)
    return {
      desc = "nvim-tree: " .. desc,
      buffer = bufnr,
      noremap = true,
      silent = true,
      nowait = true,
    }
  end

  api.config.mappings.default_on_attach(bufnr)

  vim.keymap.set("n", "<CR>", api.node.open.edit, opts("Open"))
  vim.keymap.set("n", "C", api.tree.change_root_to_node, opts("Root to node"))
  vim.keymap.set("n", "U", api.tree.change_root_to_parent, opts("Root to parent"))
  vim.keymap.set("n", "r", api.tree.reload, opts("Refresh"))
  vim.keymap.set("n", "q", api.tree.close, opts("Close tree"))
end

return M
