-- kotlin.nvim starts/configures JetBrains' kotlin-lsp itself, no vim.lsp.enable() needed.
-- Install the LSP binary separately: :MasonInstall kotlin-lsp
require("kotlin").setup({
    inlay_hints = { enabled = true },
    folding = { enabled = true },
})
