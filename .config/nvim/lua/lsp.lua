local M = {}

function M.setup()

  -- Setup LSP servers
  local lspconfig = require('lspconfig')
  local capabilities = require('cmp_nvim_lsp').default_capabilities()

  -- For each server you want to configure
  vim.lsp.config["ts_ls"] = {
    capabilities = capabilities,
    root_dir = lspconfig.util.root_pattern("package.json", "tsconfig.json"),
    single_file_support = false,
    init_options = {
      maxTsServerMemory = 6144,
    },
  }


  vim.lsp.config["lua_ls"] {
    capabilities = capabilities,
  }

  vim.lsp.config["pyright"] {
    capabilities = capabilities,
    settings = {
      python = {
        analysis = {
          autoSearchPaths = true,
          diagnosticMode = "workspace",
          useLibraryCodeForTypes = true,
        }
      }
    }
  }

  -- Setup Mason to automatically install LSP servers
  require('mason').setup()
  require('mason-lspconfig').setup({
    -- List servers you want to automatically install
    ensure_installed = { "lua_ls", "pyright", "ts_ls" },
    automatic_installation = true,
  })

  vim.lsp.set_log_level("warn")

  vim.env.NODE_OPTIONS = "--huge-max-old-generation-size " .. (vim.env.NODE_OPTIONS or "")

  -- Set keybindings when an LSP is attached to a buffer
  vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
      local opts = { buffer = ev.buf }
      -- Enable completion triggered by <c-x><c-o>
      vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

      -- Define your keybindings
      vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
      vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
      vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
      vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
      vim.keymap.set('n', '<space>ca', vim.lsp.buf.code_action, opts)
      vim.keymap.set('n', 'gr', vim.lsp.buf.references, { noremap = true, silent = true })
    end
  })
end

return M
