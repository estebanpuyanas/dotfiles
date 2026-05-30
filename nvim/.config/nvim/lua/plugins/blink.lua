require('blink.cmp').setup({
    keymap = {
        preset = 'none',
        ['<Tab>']     = { 'select_next', 'fallback' },
        ['<S-Tab>']   = { 'select_prev', 'fallback' },
        ['<Down>']    = { 'select_next', 'fallback' },
        ['<Up>']      = { 'select_prev', 'fallback' },
        ['<CR>']      = { 'accept', 'fallback' },
        ['<C-Space>'] = { 'show', 'show_documentation', 'hide_documentation' },
        ['<C-e>']     = { 'hide', 'fallback' },
    },
    sources = {
        default = { 'lsp', 'path', 'buffer' },
    },
    completion = {
        documentation = {
            auto_show = true,
            auto_show_delay_ms = 250,
        },
    },
    fuzzy = { implementation = 'lua' },
})
