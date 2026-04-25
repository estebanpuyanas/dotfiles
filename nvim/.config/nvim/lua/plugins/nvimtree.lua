require("nvim-tree").setup({
    git = {
        enable       = true,
        ignore       = false,
        show_on_dirs = true,
        timeout      = 400,
    },

    view = {
        width          = 35,
        number         = true,
        relativenumber = true,
    },

    renderer = {
        highlight_git = true,
        icons = {
            show = {
                git          = true,
                folder       = true,
                file         = true,
                folder_arrow = true,
            },
        },
    },
})
