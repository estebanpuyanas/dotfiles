return {
  {
    "nvim-tree/nvim-tree.lua",
    dependencies = { "nvim-tree/nvim-web-devicons" },
    config = function()
      require("nvim-tree").setup({
        git = {
          enable = true,       -- ✔ show git status
          ignore = false,      -- ✖ don't ignore `.gitignore`d files
          show_on_dirs = true, -- ✔ show status on folders too
          timeout = 400,
        },
        view = {
          width = 35,
          number = true,
          relativenumber = true,
        },
        renderer = {
          highlight_git = true, -- ✔ highlight git status with color
          icons = {
            show = {
              git = true,
              folder = true,
              file = true,
              folder_arrow = true,
            },
          },
        },
      })
    end,
  },
}

