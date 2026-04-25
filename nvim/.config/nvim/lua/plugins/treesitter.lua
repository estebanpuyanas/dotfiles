-- nvim-treesitter (main branch) — Neovim 0.12 API
-- setup() is optional; only needed to override install_dir
require('nvim-treesitter').setup({
    install_dir = vim.fn.stdpath('data') .. '/site',
})

-- Install parsers on startup (async, no-op when already installed)
require('nvim-treesitter').install({
    'cpp', 'python', 'dockerfile',
    'html', 'lua', 'sql', 'tsx', 'typescript',
    'javascript', 'css', 'json', 'markdown', 'go',
})

local ts_filetypes = {
    'c', 'cpp', 'python', 'dockerfile',
    'html', 'lua', 'sql', 'tsx', 'typescript',
    'javascript', 'javascriptreact', 'typescriptreact',
    'css', 'json', 'markdown', 'go',
}

-- Highlighting: nvim-treesitter provides the queries; Neovim runs them
-- pcall silently skips filetypes whose parser isn't installed yet
vim.api.nvim_create_autocmd('FileType', {
    pattern = ts_filetypes,
    callback = function()
        pcall(vim.treesitter.start)
    end,
})

-- Indentation (experimental)
vim.api.nvim_create_autocmd('FileType', {
    pattern = ts_filetypes,
    callback = function()
        vim.bo.indentexpr = "v:lua.require'nvim-treesitter'.indentexpr()"
    end,
})
