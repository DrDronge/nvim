-- Setup Mason first
require("mason").setup()
require("mason-lspconfig").setup({
  ensure_installed = { "omnisharp", "jsonls" },
  automatic_installation = true,
})

-- Enhanced LSP capabilities with blink.cmp
local capabilities = require("blink.cmp").get_lsp_capabilities()

-- LSP on_attach callback
local on_attach = function(client, bufnr)
  vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
  vim.notify("✅ LSP attached: " .. client.name, vim.log.levels.INFO)
end

-- Helper function to find solution root (prioritize .sln over .csproj)
local function find_csharp_root(fname)
  -- First, try to find .sln file (solution root)
  local sln_root = vim.fs.root(fname, function(name)
    return name:match("%.sln$")
  end)
  
  if sln_root then
    return sln_root
  end
  
  -- Fallback to .csproj or .git
  return vim.fs.root(fname, { "*.csproj", ".git" })
end

-- Auto-start OmniSharp for C# files
vim.api.nvim_create_autocmd("FileType", {
  pattern = "cs",
  callback = function(ev)
    -- Check if omnisharp is already running for this buffer
    local clients = vim.lsp.get_clients({ bufnr = ev.buf, name = "omnisharp" })
    if #clients > 0 then
      return -- Already attached
    end
    
    -- Find root directory (prioritize .sln)
    local root_dir = find_csharp_root(ev.buf)
    if not root_dir then
      vim.notify("⚠️ No C# project found (.sln or .csproj)", vim.log.levels.WARN)
      return
    end
    
    -- Change Neovim's working directory to project root
    vim.cmd("cd " .. vim.fn.fnameescape(root_dir))
    vim.notify("📁 Changed to: " .. vim.fn.fnamemodify(root_dir, ":t"), vim.log.levels.INFO)
    
    -- Start omnisharp
    vim.lsp.start({
      name = "omnisharp",
      cmd = { "omnisharp", "--languageserver", "--hostPID", tostring(vim.fn.getpid()) },
      root_dir = root_dir,
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
          AnalyzeOpenDocumentsOnly = false,
        },
      },
    })
  end,
})

-- Auto-start JSON Language Server for JSON files
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "json", "jsonc" },
  callback = function(ev)
    -- Check if jsonls is already running for this buffer
    local clients = vim.lsp.get_clients({ bufnr = ev.buf, name = "jsonls" })
    if #clients > 0 then
      return -- Already attached
    end
    
    -- Start jsonls
    vim.lsp.start({
      name = "jsonls",
      cmd = { "vscode-json-language-server", "--stdio" },
      root_dir = vim.fs.root(ev.buf, { ".git", "package.json" }) or vim.fn.getcwd(),
      capabilities = capabilities,
      on_attach = on_attach,
      settings = {
        json = {
          schemas = require("schemastore").json.schemas(),
          validate = { enable = true },
        },
      },
    })
  end,
})

-- Show LSP progress
vim.api.nvim_create_autocmd("LspProgress", {
  callback = function(args)
    local client = vim.lsp.get_client_by_id(args.data.client_id)
    if client then
      local value = args.data.params.value
      if value and value.kind == "begin" then
        vim.notify(value.title or "Indexing...", vim.log.levels.INFO, { 
          title = client.name,
          timeout = 1000,
        })
      end
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