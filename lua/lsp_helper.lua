local M = {}

-- LSP attach notification
function M.on_attach(client, bufnr)
  vim.bo[bufnr].omnifunc = "v:lua.vim.lsp.omnifunc"
  vim.notify("✅ LSP attached: " .. client.name, vim.log.levels.INFO)
end

-- Find project root by pattern list
local function find_root(fname, patterns)
  for _, pattern in ipairs(patterns) do
    if pattern:match("%.") then
      -- File pattern (e.g., "*.sln")
      local root = vim.fs.root(fname, function(name)
        return name:match(pattern)
      end)
      if root then
        return root
      end
    else
      -- Directory pattern (e.g., ".git")
      local root = vim.fs.root(fname, { pattern })
      if root then
        return root
      end
    end
  end
  return nil
end

-- Check if LSP is already attached to buffer
local function is_lsp_attached(bufnr, lsp_name)
  local clients = vim.lsp.get_clients({ bufnr = bufnr, name = lsp_name })
  return #clients > 0
end

-- Setup LSP for filetype with auto-start (NO auto-cd)
function M.setup_filetype_lsp(opts)
  vim.api.nvim_create_autocmd("FileType", {
    pattern = opts.filetypes,
    callback = function(ev)
      if is_lsp_attached(ev.buf, opts.name) then
        return
      end
      
      local root_dir = find_root(ev.buf, opts.root_patterns)
      
      if not root_dir then
        vim.notify("⚠️ No " .. opts.display_name .. " project found", vim.log.levels.WARN)
        return
      end
      
      if opts.lsp_config then
        vim.lsp.start(vim.tbl_deep_extend("force", {
          name = opts.name,
          root_dir = root_dir,
          capabilities = require("blink.cmp").get_lsp_capabilities(),
          on_attach = M.on_attach,
        }, opts.lsp_config))
      end
    end,
  })
end

return M
