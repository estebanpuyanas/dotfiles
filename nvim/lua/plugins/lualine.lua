require("lualine").setup {
    options = {
        theme              = "auto",
        icons_enabled      = true,
        section_separators    = { left = "", right = "" },
        component_separators = { left = "", right = "" },
    },
    sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff" },
        lualine_c = {
            {
                "filename",
                path = 1,
                symbols = {
                    modified = " [M]",
                    readonly = " []",
                    unnamed  = "[No Name]",
                    newfile  = " [U]",
                },
            },
            {
                "diagnostics",
                sources          = { "nvim_diagnostic" },
                sections         = { "error", "warn", "hint", "info" },
                symbols          = { error = " ", warn = " ", hint = " ", info = " " },
                colored          = true,
                update_in_insert = false,
                always_visible   = false,
            },
        },
        lualine_x = {},
        lualine_y = {},
        lualine_z = {},
    },
    extensions = { "nvim-tree", "fugitive" },
}
