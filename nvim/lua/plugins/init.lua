vim.pack.add({
    -- Utilities (required by many plugins)
    'https://github.com/nvim-lua/plenary.nvim',

    -- Fuzzy finder
    { src = 'https://github.com/nvim-telescope/telescope.nvim', version = '0.1.8' },

    -- Syntax highlighting
    { src = 'https://github.com/nvim-treesitter/nvim-treesitter', version = 'master' },

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

    -- GitHub Copilot
    'https://github.com/github/copilot.vim',

    -- Status line
    'https://github.com/nvim-lualine/lualine.nvim',

    -- Indent guides
    'https://github.com/lukas-reineke/indent-blankline.nvim',

    -- LSP binary manager
    'https://github.com/mason-org/mason.nvim',
    'https://github.com/mason-org/mason-lspconfig.nvim',
})

-- Plugin configurations (colorscheme first, icons before dependents)
require("plugins.colorscheme")
require("plugins.icons")
require("plugins.telescope")
require("plugins.treesitter")
require("plugins.fugitive")
require("plugins.autopairs")
require("plugins.nvimtree")
require("plugins.mdrender")
require("plugins.trouble")
require("plugins.autotags")
require("plugins.conform")
require("plugins.lualine")
require("plugins.blankline")
require("plugins.lsp")
