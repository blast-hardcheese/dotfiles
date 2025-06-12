local M = {}

function M.setup()
  -- Setup Mason to automatically install LSP servers
  require('mason').setup()
  require('mason-lspconfig').setup({
    -- List servers you want to automatically install
    ensure_installed = { "lua_ls", "pyright", "ts_ls" },
    automatic_installation = true,
  })

  -- Setup LSP servers
  local lspconfig = require('lspconfig')
  local capabilities = require('cmp_nvim_lsp').default_capabilities()

  vim.lsp.set_log_level("warn")

  -- For each server you want to configure
  lspconfig.lua_ls.setup {
    capabilities = capabilities,
  }
  lspconfig.pyright.setup {
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
  lspconfig.ts_ls.setup {
    capabilities = capabilities,
    settings = {
	maxTsServerMemory = 8192,
    },
  }
  lspconfig.vtsls.setup {
    settings = {
      typescript = {
        tsserver = {
          maxTsServerMemory = 8192,
        },
      },
    },
  }
  
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
    end
  })
end

return M
