-- Setup Mason first
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "omnisharp" },
  automatic_installation = true,
})

-- LSP keybindings and settings
local on_attach = function(client, bufnr)
  vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
end

-- Enhanced LSP capabilities with blink.cmp
local capabilities = require("blink.cmp").get_lsp_capabilities()

-- Configure OmniSharp with better performance settings
vim.lsp.config.omnisharp = {
  cmd = { "omnisharp", "--languageserver" },
  filetypes = { "cs", "vb" },
  root_markers = { "*.sln", "*.csproj" },
  capabilities = capabilities,
  on_attach = on_attach,
  settings = {
    omnisharp = {
      enableRoslynAnalyzers = true,
      organizeImportsOnFormat = true,
      enableImportCompletion = true,
      -- Performance optimizations
      sdkIncludePrereleases = false,
      analyzeOpenDocumentsOnly = true,  -- Only analyze open files, not entire project
    },
  },
  flags = {
    debounce_text_changes = 150,
  },
}

-- Enable OmniSharp
vim.lsp.enable('omnisharp')

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