-- Setup Mason first
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { 
    "omnisharp",      -- C#
    "rust_analyzer",  -- Rust
    "jsonls",         -- JSON
    "ts_ls",          -- TypeScript/JavaScript
    "html",           -- HTML
    "cssls",          -- CSS
  },
  automatic_installation = true,
})

local lsp_helper = require("lsp_helper")

-- C# LSP Configuration
lsp_helper.setup_filetype_lsp({
  name = "omnisharp",
  filetypes = "cs",
  root_patterns = { "%.sln$", "*.csproj", ".git" },
  icon = "📁",
  display_name = "C#",
  lsp_config = {
    cmd = { "omnisharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
    settings = {
      FormattingOptions = {
        EnableEditorConfigSupport = true,
        OrganizeImports = true,
      },
      RoslynExtensionsOptions = {
        EnableAnalyzersSupport = true,
        EnableImportCompletion = true,
        AnalyzeOpenDocumentsOnly = false,
      },
    },
  },
})

-- JSON LSP Configuration
lsp_helper.setup_filetype_lsp({
  name = "jsonls",
  filetypes = { "json", "jsonc" },
  root_patterns = { ".git", "package.json" },
  icon = "📄",
  display_name = "JSON",
  lsp_config = {
    cmd = { "vscode-json-language-server", "--stdio" },
    settings = {
      json = {
        schemas = require("schemastore").json.schemas(),
        validate = { enable = true },
      },
    },
  },
})

-- Rust auto-cd (LSP managed by rustaceanvim plugin)
lsp_helper.setup_filetype_cd({
  filetypes = "rust",
  root_patterns = { "Cargo.toml", ".git" },
  icon = "🦀",
  display_name = "Rust",
})

-- Show LSP progress
vim.api.nvim_create_autocmd("LspProgress", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if not client then
      return
    end
    
    local value = args.data.params.value
    if value and value.kind == "begin" then
      vim.notify(value.title or "Indexing...", vim.log.levels.INFO, { 
        title = client.name,
        timeout = 1000,
      })
    end
  end,
})

-- Diagnostic configuration with signs
vim.diagnostic.config({
  virtual_text = false,
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "󰅚",
      [vim.diagnostic.severity.WARN] = "󰀪",
      [vim.diagnostic.severity.HINT] = "󰌶",
      [vim.diagnostic.severity.INFO] = "",
    },
  },
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})