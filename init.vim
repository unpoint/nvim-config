"""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""""
" Global settings
"""""""""""""""""
set nocompatible
syntax on
set encoding=utf8
set mouse=                      " disable mouse use
set backspace=indent,eol,start
set wildmenu
set wildmode=longest,full

" Color settings
""""""""""""""""
"set termguicolors
colorscheme github_dark_default "sonokai
set background=dark

" Editor settings
"""""""""""""""""
set number relativenumber
set ruler
set list
set listchars=tab:→\ ,space:·,nbsp:␣,trail:•,precedes:«,extends:»,eol:↵,      "affichage des espaces, tab, ...
"set textwidth=120 " max text width on a column
set colorcolumn=120 " max column color
hi clear SignColumn  " enable max column highlight
set cursorline " enable cursor line
set signcolumn=yes
set splitright
set splitbelow

" allow to open .ovsec as zip \o/
au BufReadCmd *.ovsec call zip#Browse(expand("<amatch>"))

" Status settings
"""""""""""""""""
set laststatus=2
set updatetime=100 " Reduce lag time for tagbar

" Indent settings
"""""""""""""""""
set tabstop=4
set shiftwidth=4
set smarttab
set noexpandtab
set autoindent                  " Indent at the same level of the previous line
set softtabstop=0               " Let backspace delete indent

" Search settings
"""""""""""""""""
set showmatch
set incsearch
set hlsearch
set ignorecase
set smartcase

" Completion behavior
"""""""""""""""""""""
" Set completeopt to have a better completion experience
" -menuone: popup even when there's only one match
" -noinsert: Do not insert text until a selection is made
" -noselect: Do not auto-select, nvim-cmp plugin will handle this for us.
set completeopt="menuone,noinsert,noselect"

" LSP Enhancement
"""""""""""""""""
"hi default LspReferenceText gui=bold,underline guifg=black guibg=red
"hi default LspReferenceRead gui=bold guifg=black guibg=yellow
"hi default LspReferenceWrite gui=bold guifg=black guibg=green
autocmd CursorHold  <buffer> lua vim.lsp.buf.document_highlight()
autocmd CursorHoldI <buffer> lua vim.lsp.buf.document_highlight()
autocmd CursorMoved <buffer> lua vim.lsp.buf.clear_references()

" Remap settings
""""""""""""""""
" Enable move in different window with Control+Arrow
nmap <silent> <C-Up> :wincmd k<CR>
nmap <silent> <C-Down> :wincmd j<CR>
nmap <silent> <C-Left> :wincmd h<CR>
nmap <silent> <C-Right> :wincmd l<CR>

" Clipboard mappings
vnoremap <C-X> "+x
vnoremap <C-C> "+y
cmap <C-V> <C-R>+
imap <C-V> <C-R>+

" Enable move in tab with Alt+Arrow
nmap <M-Right> :tabnext<CR>
nmap <M-Left> :tabprevious<CR>
nmap <M-Up> :tabnew<CR>
nmap <M-Down> :tabclose<CR>

" Code navigation
"nnoremap <silent> gD    <cmd>lua vim.lsp.buf.implementation()<CR>
"nnoremap <silent> gr    <cmd>lua vim.lsp.buf.references()<CR>
"nnoremap <silent> gt    <cmd>lua vim.lsp.buf.type_definition()<CR>
"nnoremap <silent> gd    <cmd>lua vim.lsp.buf.definition()<CR>
nnoremap <silent> gn    <cmd>lua vim.lsp.buf.rename()<CR>
nnoremap <silent> K     <cmd>lua vim.lsp.buf.hover()<CR>

" fuzy finder
nnoremap ff <cmd>lua require('telescope.builtin').find_files()<CR>
nnoremap fg <cmd>lua require('telescope.builtin').live_grep()<CR>
nnoremap fb <cmd>lua require('telescope.builtin').buffers()<CR>
nnoremap fh <cmd>lua require('telescope.builtin').help_tags()<CR>
nnoremap fd <cmd>lua require('telescope.builtin').spell_suggest()<CR>
nnoremap ft <cmd>lua require('telescope.builtin').treesitter()<CR>

" fuzzy git
nnoremap fgc <cmd>lua require('telescope.builtin').git_commits()<CR>
nnoremap fgs <cmd>lua require('telescope.builtin').git_status()<CR>

" fuzzy lsp
nnoremap gr <cmd>lua require('telescope.builtin').lsp_references()<CR>
nnoremap gd <cmd>lua require('telescope.builtin').lsp_definitions()<CR>
nnoremap gD <cmd>lua require('telescope.builtin').lsp_implementations()<CR>
nnoremap gt <cmd>lua require('telescope.builtin').lsp_type_definitions()<CR>
nnoremap gi <cmd>lua require('telescope.builtin').lsp_incoming_calls()<CR>
nnoremap go <cmd>lua require('telescope.builtin').lsp_outgoing_calls()<CR>

" fuzzy error
nnoremap gla <cmd>lua require('telescope.builtin').diagnostics()<CR>
nnoremap <silent> ga    <cmd>lua vim.lsp.buf.code_action()<CR>


imap <expr> <C-j>   vsnip#expandable()  ? '<Plug>(vsnip-expand)'         : '<C-j>'

" Plugins configuration
"""""""""""""""""""""""
" snippet
" tagbar
nmap <C-x> :TagbarToggle<CR>


" LUA
"""""

lua <<EOF

-- plugins management configuration
require('plugins')
require('packer')

-- colorscheme configuration
require('github-theme').setup{
	transparent = true,
	theme_style = "dark_default",

	-- Overwrite the highlight groups
	  overrides = function(c)
		return {
		  LspReferenceText = {fg = c.black, bg = c.green, style = "bold,underline"},
		  LspReferenceRead = {fg = c.black, bg = c.yellow, style = "bold,underline"},
		  LspReferenceWrite = {fg = c.black, bg = c.red, style = "bold,underline"},
		}
	  end
}

require("nvim-autopairs").setup()

-- fuzzy finder
require('telescope').setup{
	defaults = {
		path_display = { "shorten" },
	},
}

-- lsp server and enhancer configuration
local function on_attach(client, buffer)
	-- Show diagnostic popup on cursor hover
    local diag_float_grp = vim.api.nvim_create_augroup("DiagnosticFloat", { clear = true })
    vim.api.nvim_create_autocmd("CursorHold", {
      callback = function()
        vim.diagnostic.open_float(nil, { focusable = false })
      end,
      group = diag_float_grp,
    })
end


require('rust-tools').setup{
  tools = {
    runnables = {
      use_telescope = true,
    },
    inlay_hints = {
      auto = true,
      show_parameter_hints = true,
      parameter_hints_prefix = "-- ",
      other_hints_prefix = "|| ",
    },
  },

  -- all the opts to send to nvim-lspconfig
  -- these override the defaults set by rust-tools.nvim
  -- see https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#rust_analyzer
  server = {
    -- on_attach is a callback called when the language server attachs to the buffer
--    on_attach = on_attach,
    settings = {
      -- to enable rust-analyzer settings visit:
      -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
      ["rust-analyzer"] = {
        -- enable clippy on save
        checkOnSave = {
          command = "clippy",
        },
      },
    },
  },
}

require('fidget').setup()

-- Completion configuration
local cmp = require("cmp")
cmp.setup({
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    -- Add tab support
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.close(),
    ["<CR>"] = cmp.mapping.confirm({
      behavior = cmp.ConfirmBehavior.Insert,
      select = true,
    }),
  },

  -- Installed sources:
  sources = {
    { name = 'path' },                              -- file paths
    { name = 'nvim_lsp', keyword_length = 3 },      -- from language server
    { name = 'nvim_lsp_signature_help'},            -- display function signatures with current parameter emphasized
    { name = 'nvim_lua', keyword_length = 2},       -- complete neovim's Lua runtime API such vim.lsp.*
    { name = 'buffer', keyword_length = 2 },        -- source current buffer
    { name = 'vsnip', keyword_length = 2 },         -- nvim-cmp source for vim-vsnip
    { name = 'calc'},                               -- source for math calculation
  },

  window = {
      completion = cmp.config.window.bordered(),
      documentation = cmp.config.window.bordered(),
  },
  formatting = {
      fields = {'menu', 'abbr', 'kind'},
      format = function(entry, item)
          local menu_icon ={
              vsnip = '⋗',
              nvim_lsp = 'λ',
              buffer = 'Ω',
              path = '🖫',
          }
          item.menu = menu_icon[entry.source.name]
          return item
      end,
  },
})



EOF
