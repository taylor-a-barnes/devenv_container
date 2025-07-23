return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      local lspconfig = require("lspconfig")
      local configs = require("lspconfig.configs")

      -- Define on_attach function here
      local on_attach = function(client, bufnr)
        -- Enable completion triggered by <c-x><c-o>
        vim.api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.vim.lsp.omnifunc")

        -- Keymaps for LSP features
        local opts = { noremap=true, silent=true }
        local buf_set_keymap = vim.api.nvim_buf_set_keymap
        buf_set_keymap(bufnr, "n", "K", "<cmd>lua vim.lsp.buf.hover()<CR>", opts)
        buf_set_keymap(bufnr, "n", "gd", "<cmd>lua vim.lsp.buf.definition()<CR>", opts)
        buf_set_keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
        -- add more keymaps as needed
      end

      -- Setup lua_ls as usual
      lspconfig.lua_ls.setup({
        settings = {
          Lua = {
            diagnostics = {
              globals = { "vim" },
            },
          },
        },
      })

      -- Register custom neocmake server if not already registered
      if not configs.neocmake then
        configs.neocmake = {
          default_config = {
            cmd = { "neocmakelsp", "--stdio" },
            filetypes = { "cmake", "txt" },
            root_dir = function(fname)
              return lspconfig.util.find_git_ancestor(fname) or vim.loop.cwd()
            end,
            single_file_support = true,
            on_attach = on_attach, -- now on_attach is defined and passed
            init_options = {
              format = { enable = true },
              lint = { enable = true },
              scan_cmake_in_package = true,
            },
          },
        }
      end

      -- Add capabilities for completion/snippet support
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.completion.completionItem.snippetSupport = true

      -- Setup the server with capabilities and on_attach
      lspconfig.neocmake.setup({
        on_attach = on_attach,
        capabilities = capabilities,
      })
    end,
  },
}

