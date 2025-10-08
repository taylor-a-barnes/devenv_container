return {
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPre", "BufNewFile" },
    dependencies = {
      -- For better completion support
      { "hrsh7th/cmp-nvim-lsp" },
    },
    config = function()
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
        buf_set_keymap(bufnr, "n", "gD", "<cmd>lua vim.lsp.buf.declaration()<CR>", opts)
        buf_set_keymap(bufnr, "n", "gr", "<cmd>lua vim.lsp.buf.references()<CR>", opts)
        -- add more keymaps as needed
      end

      -- Add capabilities for completion/snippet support
      local capabilities = vim.lsp.protocol.make_client_capabilities()
      capabilities.textDocument.completion.completionItem.snippetSupport = true

      -- Integrate with nvim-cmp if available
      local cmp_lsp = pcall(require, "cmp_nvim_lsp") and require("cmp_nvim_lsp")
      if cmp_lsp then
        capabilities = cmp_lsp.default_capabilities(capabilities)
      end
      capabilities.textDocument.completion.completionItem.snippetSupport = true

      -- Setup lua_ls
      vim.lsp.config.lua_ls = {
        default_config = {
          cmd = { "lua-language-server" },
          filetypes = { "lua" },
          root_dir = vim.loop.cwd(), -- Use current working directory as root
          settings = {
            Lua = {
              diagnostics = {
                globals = { "vim" }, -- Recognize 'vim' global for Neovim
              },
              workspace = {
                library = vim.api.nvim_get_runtime_file("", true), -- Lua runtime files
              },
            },
          },
        },
        on_attach = on_attach,
        capabilities = capabilities,
      }
      vim.lsp.start(vim.lsp.config.lua_ls.default_config)

      -- Setup neocmake
      vim.lsp.config.neocmake = {
        default_config = {
          cmd = { "neocmakelsp" }, -- Verify the correct command
          filetypes = { "cmake" },
          root_dir = vim.loop.cwd(),
        },
        on_attach = on_attach,
        capabilities = capabilities,
      }
      vim.lsp.start(vim.lsp.config.neocmake.default_config)

      -- Setup clangd
      vim.lsp.config.clangd = {
        default_config = {
          cmd = { "clangd", "--header-insertion=never" },
          filetypes = { "c", "cpp", "objc", "objcpp", "cuda" },
          root_dir = vim.loop.cwd(),
        },
        on_attach = on_attach,
        capabilities = capabilities,
      }

      -- Autocommand to start clangd for specific filetypes
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "c", "cpp", "objc", "objcpp", "cuda" },
        callback = function(args)
          vim.lsp.start(vim.lsp.config.clangd.default_config, { bufnr = args.buf })
        end,
      })

    end,
  },
}

