return {
  {
    "nvim-treesitter/nvim-treesitter",

    branch = "master",
    lazy = false,
    build = ":TSUpdate",

    config = function()
      require("nvim-treesitter.configs").setup {
        ensure_installed = { "java", "cpp", "python", "elixir", "dockerfile",
                            "html", "lua", "sql", "ocaml", "tsx" , "typescript",
                            "javascript", "css", "json", "markdown", "rust",},
        highlight = { enable = true },
        indent = { enable = true },
      }
    end,
  },
}


