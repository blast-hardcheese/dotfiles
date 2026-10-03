vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

local ensure_packer = function()
  local fn = vim.fn
  local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
  if fn.empty(fn.glob(install_path)) > 0 then
    fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
    vim.cmd [[packadd packer.nvim]]
    return true
  end
  return false
end

local packer_bootstrap = ensure_packer()

local function plugins_installed()
  local install_root = vim.fn.stdpath('data')..'/site/pack/packer/'
  for _, plugin in ipairs({
    'telescope.nvim',
    'telescope-file-browser.nvim',
    'solarized.nvim',
    'nvim-cmp',
    'cmp-nvim-lsp',
    'mason.nvim',
    'mason-lspconfig.nvim',
  }) do
    if vim.fn.isdirectory(install_root..'start/'..plugin) == 0
      and vim.fn.isdirectory(install_root..'opt/'..plugin) == 0 then
      return false
    end
  end
  return true
end

local plugins_ready = not packer_bootstrap and plugins_installed()

require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Usability
  use 'Lokaltog/vim-easymotion'
  use 'ciaranm/detectindent'
  use 'maxmx03/solarized.nvim'
  use 'tpope/vim-fugitive'
  use 'whiteinge/diffconflicts'
  use 'lewis6991/gitsigns.nvim'

  use {
    'nvim-telescope/telescope-file-browser.nvim',
    requires = {
      { 'nvim-lua/plenary.nvim' },
      { 'nvim-telescope/telescope.nvim', branch = '0.1.x' },
    }
  }

  -- Language support
  use "williamboman/mason.nvim"
  use "williamboman/mason-lspconfig.nvim"
  use 'neovim/nvim-lspconfig'
  use 'hrsh7th/nvim-cmp'
  use 'hrsh7th/cmp-nvim-lsp'

  use 'cappyzawa/starlark.vim'

  -- GenAI
-- use {
--   'pasky/claude.vim',
--   config = function()
--     local api_key = os.getenv("NVIM_ANTHROPIC_API_KEY")
--     if api_key then
--       vim.g.claude_api_key = api_key
--     else
--       vim.notify("NVIM_ANTHROPIC_API_KEY environment variable is not set", vim.log.levels.WARN)
--     end
--   end
-- }
  use {
    'frankroeder/parrot.nvim',
    requires = { 'ibhagwan/fzf-lua', 'nvim-lua/plenary.nvim' },
    -- optionally include "folke/noice.nvim" or "rcarriga/nvim-notify" for beautiful notifications
    config = function()
      require("parrot").setup {
        -- Providers must be explicitly added to make them available.
        providers = {
--        anthropic = {
--          api_key = os.getenv "NVIM_ANTHROPIC_API_KEY",
--        },
--        gemini = {
--          api_key = os.getenv "GEMINI_API_KEY",
--        },
--        groq = {
--          api_key = os.getenv "GROQ_API_KEY",
--        },
--        mistral = {
--          api_key = os.getenv "MISTRAL_API_KEY",
--        },
--        pplx = {
--          api_key = os.getenv "PERPLEXITY_API_KEY",
--        },
--        -- provide an empty list to make provider available (no API key required)
--        ollama = {},
          openai = {
            name = "openai",
            api_key = function()
              return os.getenv("OPENAI_API_KEY")
            end,
            endpoint = "https://api.openai.com/v1/chat/completions",
            models = {
              "gpt-4o",
              "o4-mini",
              "gpt-4.1-nano",
            },
          },
--        github = {
--          api_key = os.getenv "GITHUB_TOKEN",
--        },
--        nvidia = {
--          api_key = os.getenv "NVIDIA_API_KEY",
--        },
--        xai = {
--          api_key = os.getenv "XAI_API_KEY",
--        },
--        deepseek = {
--          api_key = os.getenv "DEEPSEEK_API_KEY",
--        },
        },
      }
    end,
  }

  if not plugins_ready then
    require('packer').sync()
  end
end)

return plugins_ready
