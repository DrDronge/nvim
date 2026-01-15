-- Setup Mason first
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "omnisharp" },
  automatic_installation = true,
})

-- LSP keybindings and settings
local on_attach = function(client, bufnr)
  vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
  
  -- Show a message when LSP is ready
  vim.notify("LSP attached: " .. client.name, vim.log.levels.INFO)
end

-- Enhanced LSP capabilities with blink.cmp
local capabilities = require("blink.cmp").get_lsp_capabilities()

-- Configure OmniSharp for background analysis (like a normal IDE)
vim.lsp.config.omnisharp = {
  cmd = { "omnisharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
  filetypes = { "cs", "vb" },
  root_markers = { "*.sln", "*.csproj" },
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    FormattingOptions = {
      EnableEditorConfigSupport = true,
      OrganizeImports = true,
    },
    RoslynExtensionsOptions = {
      EnableAnalyzersSupport = true,
      EnableImportCompletion = true,
      AnalyzeOpenDocumentsOnly = false,  -- Analyze entire project in background
    },
    Sdk = {
      IncludePrereleases = false,
    },
  },
  -- Make LSP non-blocking
  flags = {
    debounce_text_changes = 150,
    allow_incremental_sync = true,
  },
  -- Don't wait for server to be ready before returning
  on_new_config = function(new_config, new_root_dir)
    new_config.cmd = { "omnisharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) }
  end,
}

-- Enable OmniSharp
vim.lsp.enable('omnisharp')

-- Show LSP progress in the corner (like VS Code)
vim.api.nvim_create_autocmd("LspProgress", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client and client.name == "omnisharp" then
      local value = args.data.params.value
      if value.kind == "begin" then
        vim.notify(value.title or "Indexing project...", vim.log.levels.INFO, { 
          title = "OmniSharp",
          timeout = 1000,
        })
      end
    end
  end,
})

-- Diagnostic configuration
vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  underline = true,
  update_in_insert = false,
  severity_sort = true,
})

-- Diagnostic signs
local signs = { Error = "󰅚 ", Warn = "󰀪 ", Hint = "󰌶 ", Info = " " }
for type, icon in pairs(signs) do
  local hl = "DiagnosticSign" .. type
  vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
end