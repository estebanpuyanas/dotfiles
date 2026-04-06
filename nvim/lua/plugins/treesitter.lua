return {
    {
        "nvim-treesitter/nvim-treesitter",

        branch = "master",
        lazy = false,
        build = ":TSUpdate",

        config = function()
            require("nvim-treesitter.configs").setup {
                ensure_installed = { "cpp", "python", "dockerfile",
                    "html", "lua", "sql", "tsx", "typescript",
                    "javascript", "css", "json", "markdown", "go" },
                highlight = { enable = true },
                indent = { enable = true },
            }
        end,
    },
}
