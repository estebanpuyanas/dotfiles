vim.pack.add({
    -- Utilities (required by many plugins)
    'https://github.com/nvim-lua/plenary.nvim',

    -- Fuzzy finder
    { src = 'https://github.com/nvim-telescope/telescope.nvim',   version = '0.1.8' },

    -- Syntax highlighting
    -- 'main' is the Neovim 0.12 rewrite; 'master' is the locked Neovim 0.11 compat branch
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'main' },

    -- Colorscheme
    'https://github.com/rebelot/kanagawa.nvim',

    -- Git
    'https://github.com/tpope/vim-fugitive',
    'https://github.com/lewis6991/gitsigns.nvim',

    -- Auto-pairing brackets
    'https://github.com/windwp/nvim-autopairs',

    -- File explorer & icons
    'https://github.com/nvim-tree/nvim-tree.lua',
    'https://github.com/nvim-tree/nvim-web-devicons',

    -- Markdown rendering
    'https://github.com/MeanderingProgrammer/render-markdown.nvim',

    -- Diagnostics viewer
    'https://github.com/folke/trouble.nvim',

    -- HTML auto-close tags
    'https://github.com/windwp/nvim-ts-autotag',

    -- Code formatting
    'https://github.com/stevearc/conform.nvim',

    -- GitHub Copilot (Vimscript plugin, auto-initializes)
    'https://github.com/github/copilot.vim',

    -- Status line
    'https://github.com/nvim-lualine/lualine.nvim',

    -- Indent guides
    'https://github.com/lukas-reineke/indent-blankline.nvim',

    -- LSP: nvim-lspconfig provides lsp/*.lua server configs read by vim.lsp.enable()
    -- mason manages the server binaries; mason-lspconfig handles ensure_installed
    'https://github.com/neovim/nvim-lspconfig',
    'https://github.com/mason-org/mason.nvim',
    'https://github.com/mason-org/mason-lspconfig.nvim',
})

-- Simple setups with no custom configuration
require("nvim-web-devicons").setup()
require("nvim-autopairs").setup()
require("nvim-ts-autotag").setup()
require("ibl").setup()
require("render-markdown").setup({})

-- Plugins with custom configuration
require("plugins.colorscheme")
require("plugins.telescope")
require("plugins.treesitter")
require("plugins.fugitive")
require("plugins.nvimtree")
require("plugins.trouble")
require("plugins.conform")
require("plugins.lualine")
require("plugins.lsp")
