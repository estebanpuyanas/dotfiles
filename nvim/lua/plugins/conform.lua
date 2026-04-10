require("conform").setup({
    formatters_by_ft = {
        javascript      = { "prettierd", "prettier" },
        typescript      = { "prettierd", "prettier" },
        javascriptreact = { "prettierd", "prettier" },
        typescriptreact = { "prettierd", "prettier" },
        css             = { "prettierd", "prettier" },
        html            = { "prettierd", "prettier" },
        json            = { "prettierd", "prettier" },
        python          = { "ruff_format" },
        golang          = { "gofmt" },
    },
})
