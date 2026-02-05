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

local capabilities = require("blink.cmp").get_lsp_capabilities()
local lspconfig = require("lspconfig")

-- C# LSP (OmniSharp)
-- Use lspconfig's omnisharp integration to avoid INVALID_SERVER_MESSAGE issues.
lspconfig.omnisharp.setup({
  capabilities = capabilities,
  on_attach = lsp_helper.on_attach,
  cmd = { "omnisharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
  root_dir = function(fname)
    -- Prefer solution root when present (OmniSharp behaves best at .sln root)
    return vim.fs.root(fname, function(name)
      return name:match("%.sln$")
    end) or vim.fs.root(fname, { "*.csproj", ".git" })
  end,
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

-- Rust LSP is handled by rustaceanvim plugin (no auto-cd needed)

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