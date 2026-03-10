-- Leader key + couple remaps:
vim.g.mapleader = " "
vim.keymap.set("n", "<leader>pv", vim.cmd.Ex) 
vim.keymap.set("n", "<leader>tt", ":split | terminal<CR>", { desc = "Horizontal terminal" })
vim.keymap.set("n", "<leader>e", ":NvimTreeToggle<CR>", { desc = "Toggle file explorer" })
vim.keymap.set("i", "jj", "<Esc>", { desc = "Enter normal mode from insert mode"})
vim.keymap.set("n", "zz", ":wq!<CR>", { desc = "write-quit-bang remap" })
vim.keymap.set("n", "ww", ":w<CR>", { desc = "normal write remap" })

-- Disable arrow keys in all modes:
local opts = { noremap = true, silent = true }

vim.keymap.set({ "n", "i", "v", "x", "o" }, "<Up>", "<Nop>", opts)
vim.keymap.set({ "n", "i", "v", "x", "o" }, "<Down>", "<Nop>", opts)
vim.keymap.set({ "n", "i", "v", "x", "o" }, "<Left>", "<Nop>", opts)
vim.keymap.set({ "n", "i", "v", "x", "o" }, "<Right>", "<Nop>", opts)

vim.api.nvim_create_user_command("Ls", function()
  vim.cmd("Lazy sync")
end, {})

--[[
Alternative way of blocking arrow keys that make it annoying:
vim.keymap.set({ "n", "i", "v" }, "<Up>", function() print("Use k!") end)
vim.keymap.set({ "n", "i", "v" }, "<Down>", function() print("Use j!") end)
vim.keymap.set({ "n", "i", "v" }, "<Left>", function() print("Use h!") end)
vim.keymap.set({ "n", "i", "v" }, "<Right>", function() print("Use l!") end)
--]]
