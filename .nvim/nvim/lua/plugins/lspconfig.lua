return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      -- Example: basic setup for lua language server
      local lspconfig = require("lspconfig")

      -- Replace with any LSP server you want (e.g., pyright, clangd, etc.)
      lspconfig.lua_ls.setup({
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
          },
        },
      })
    end,
  }
}
