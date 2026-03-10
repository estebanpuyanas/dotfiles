-- ~/.config/nvim/lua/plugins/icons.lua
return {
  {
    "nvim-tree/nvim-web-devicons",
    lazy = true, -- loads only when needed by another plugin
    config = function()
      require("nvim-web-devicons").setup {
        -- override = {},
        -- default = true,
      }
    end
  }
}

