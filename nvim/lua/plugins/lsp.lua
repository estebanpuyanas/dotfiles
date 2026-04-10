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

-- Native autocompletion
vim.opt.completeopt = { 'menuone', 'noselect', 'popup' }

vim.api.nvim_create_autocmd('LspAttach', {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client:supports_method('textDocument/completion') then
            vim.lsp.completion.enable(true, client.id, args.buf, {
                autotrigger = true,
            })
        end
    end,
})

-- Tab/S-Tab navigate the completion menu; CR confirms
vim.keymap.set('i', '<Tab>', function()
    return vim.fn.pumvisible() == 1 and '<C-n>' or '<Tab>'
end, { expr = true })

vim.keymap.set('i', '<S-Tab>', function()
    return vim.fn.pumvisible() == 1 and '<C-p>' or '<S-Tab>'
end, { expr = true })

vim.keymap.set('i', '<CR>', function()
    return vim.fn.pumvisible() == 1 and '<C-y>' or '<CR>'
end, { expr = true })

vim.keymap.set('i', '<C-Space>', function()
    vim.lsp.completion.get()
end)

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
