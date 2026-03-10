return {
  {
    "nvim-lualine/lualine.nvim",
    dependencies = { "nvim-tree/nvim-web-devicons" }, -- for icons
    config = function()
      require("lualine").setup {
        options = {
          theme = "auto",
          icons_enabled = true,
          section_separators = { left = "", right = "" },
          component_separators = { left = "", right = "" },
        },
        sections = {
          lualine_a = { "mode" },
          lualine_b = { "branch", "diff", },
          lualine_c = {
            {
              "filename",
              path = 1, -- relative path
              symbols = {
                modified = " [M]",     -- like VS Code: modified
                readonly = " []",
                unnamed = "[No Name]",
                newfile = " [U]",      -- VS Code-style untracked
              },
            },
            {
              "diagnostics",
              sources = { "nvim_diagnostic" },
              sections = { "error", "warn", "hint", "info" },
              symbols = {
                error = " ",
                warn  = " ",
                hint  = " ",
                info  = " ",
              },
              colored = true,
              update_in_insert = false,
              always_visible = false,
            },
          },
          lualine_x = {},
          lualine_y = {},
          lualine_z = {},
        },
        extensions = {"nvim-tree", "fugitive" },
      }
    end
  }
}
