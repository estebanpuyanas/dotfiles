require("mason").setup()

-- Mason-LSPConfig: auto-installs configured server binaries
require("mason-lspconfig").setup({
    ensure_installed = {
        "pyright", "clangd",
        "dockerls", "docker_compose_language_service",
        "html", "marksman", "ts_ls", "eslint",
        "jsonls", "cssls", "gopls", "lua_ls",
    },
})

-- Global defaults applied to every LSP server
vim.lsp.config('*', {
    root_markers = { '.git', '.hg' },
    capabilities = require('blink.cmp').get_lsp_capabilities(),
    settings = {
        Lua = {
            diagnostics = {
                globals = { 'vim' },
            },
        },
    },
})

-- Enable servers (uses bundled $VIMRUNTIME/lsp/ configs merged with above defaults)
vim.lsp.enable({
    'pyright', 'clangd', 'dockerls', 'docker_compose_language_service',
    'html', 'marksman', 'ts_ls', 'eslint', 'jsonls', 'cssls', 'gopls', 'lua_ls',
})

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, { buffer = args.buf, desc = 'LSP hover' })
    end,
})

-- Diagnostic configuration
vim.diagnostic.config({
    virtual_text = {
        prefix = "●",
        spacing = 4,
    },
    signs = {
        text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN]  = "",
            [vim.diagnostic.severity.HINT]  = "",
            [vim.diagnostic.severity.INFO]  = "",
        },
    },
    underline = true,
    update_in_insert = false,
    severity_sort = true,
    float = {
        source = "always",
        border = "rounded",
    },
})

-- Show diagnostics float on cursor idle
vim.o.updatetime = 250
vim.api.nvim_create_autocmd("CursorHold", {
    callback = function()
        vim.diagnostic.open_float(nil, { focusable = false })
    end,
})
