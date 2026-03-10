vim.opt.nu = true
vim.opt.relativenumber = true

vim.opt.tabstop = 4         -- Visual width of a tab character
vim.opt.softtabstop = 4     -- Spaces inserted when pressing <Tab>
vim.opt.shiftwidth = 4      -- Spaces used when indenting (e.g., auto-indent)
vim.opt.expandtab = true    -- Converts tabs to spaces

vim.opt.smartindent = true

vim.opt.swapfile = false
vim.opt.backup = false

vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.hlsearch = false
vim.opt.incsearch = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8

vim.opt.signcolumn = "yes"

vim.opt.updatetime = 50

vim.opt.colorcolumn = "80"

vim.opt.cursorline = true         -- Highlight current line
vim.opt.splitright = true         -- Vertical splits open to the right
vim.opt.splitbelow = true         -- Horizaontal splits open below
vim.opt.guicursor = "a:hor20"

vim.api.nvim_create_autocmd("BufWritePre", {
  callback = function(args)
    require("conform").format({
      bufnr = args.buf,
      lsp_fallback = true,
      async = false,
    })
  end,
})
