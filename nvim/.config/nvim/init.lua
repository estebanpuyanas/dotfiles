require("estebanpuyanas")
require("plugins")

-- Enable true color support
vim.opt.termguicolors = true

vim.cmd [[
  augroup NetrwLineNumbers
    autocmd!
    autocmd FileType netrw setlocal number relativenumber
  augroup END
]]
