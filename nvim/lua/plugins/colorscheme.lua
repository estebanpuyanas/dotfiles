
return {
  {
    "rebelot/kanagawa.nvim",
    version = false,
    lazy = false,
    priority = 1000,
    config = function()
      require("kanagawa").setup {
        theme = "wave",
      }
      require("kanagawa").load()
    end,
  }
}
