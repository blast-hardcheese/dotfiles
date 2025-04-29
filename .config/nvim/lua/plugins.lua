vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]])

return require('packer').startup(function(use)
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
end)
