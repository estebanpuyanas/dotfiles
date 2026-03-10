-- ~/.config/nvim/lua/config/lsp.lua

-- Mason
require("mason").setup()

-- Mason LSPConfig
require("mason-lspconfig").setup({
  ensure_installed = {
    "pyright", "clangd", "jdtls",
    "dockerls", "docker_compose_language_service",
    "html", "marksman", "ocamllsp", "rust_analyzer",
    "ts_ls", "eslint", "jsonls", "cssls", "tailwindcss",
  },

  handlers = {
    function(server_name)
      require("lspconfig")[server_name].setup({
        capabilities = require("cmp_nvim_lsp").default_capabilities(),
      })
    end,
  },
})

-- Autocompletion setup (cmp)
local cmp = require("cmp")
local luasnip = require("luasnip")

cmp.setup({
  snippet = {
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  mapping = cmp.mapping.preset.insert({
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
    ["<CR>"] = cmp.mapping.confirm({ select = true }),
    ["<C-Space>"] = cmp.mapping.complete(), -- Manual trigger
  }),
  sources = {
    { name = "nvim_lsp" },
    { name = "luasnip" },
    { name = "buffer" },
    { name = "path" },
  },
})

-- Diagnostic configuration (Neovim 0.10+ modern style)
vim.diagnostic.config({
  virtual_text = {
    prefix = "●",
    spacing = 4,
  },
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = "",
      [vim.diagnostic.severity.WARN]  = "",
      [vim.diagnostic.severity.HINT]  = "",
      [vim.diagnostic.severity.INFO]  = "",
    },
  },
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  float = {
    source = "always",
    border = "rounded",
  },
})

-- Show diagnostics on CursorHold
vim.o.updatetime = 250
vim.api.nvim_create_autocmd("CursorHold", {
  callback = function()
    vim.diagnostic.open_float(nil, { focusable = false })
  end,
})
