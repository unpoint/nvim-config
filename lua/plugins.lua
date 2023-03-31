-- This file can be loaded by calling `lua require('plugins')` from your init.vim

return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Colorscheme
  use ({ 'projekt0n/github-nvim-theme', tag = 'v0.0.7' })

  -- lsp server and enhancer
  use 'neovim/nvim-lspconfig'
  use 'j-hui/fidget.nvim' -- show lsp server initialization progression

-- Autocompletion framework
  use("hrsh7th/nvim-cmp")
  use({
    -- cmp LSP completion
    "hrsh7th/cmp-nvim-lsp",
    -- cmp Snippet completion
    "hrsh7th/cmp-vsnip",
    -- cmp Path completion
    "hrsh7th/cmp-path",
    "hrsh7th/cmp-buffer",
    after = { "hrsh7th/nvim-cmp" },
    requires = { "hrsh7th/nvim-cmp" },
  })
  -- See hrsh7th other plugins for more great completion sources!
  -- Snippet engine
  use('hrsh7th/vim-vsnip')
  use('rafamadriz/friendly-snippets') -- set of preconfigured snippet

  -- Adds extra functionality over rust analyzer
  use("simrat39/rust-tools.nvim")

  -- Optional
  use("nvim-lua/popup.nvim")
  use("nvim-lua/plenary.nvim")
  use("nvim-telescope/telescope.nvim")

	-- developers helper's
	--use 'm-demare/hlargs.nvim'
	use 'preservim/tagbar'
	use 'ntpeters/vim-better-whitespace'
	use 'windwp/nvim-autopairs'

	-- versionning
	use 'doronbehar/nvim-fugitive'

end)
