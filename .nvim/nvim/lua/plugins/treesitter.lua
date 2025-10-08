return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPre", "BufNewFile" },
    config = function()
      require("nvim-treesitter.configs").setup({
        -- List of parsers to install
        ensure_installed = {
          "bash",
          "c",
          "cmake",
          "cpp",
          "cuda",
          "lua",
          "python",
          "rust",
          "vim",
          "vimdoc",
          "query",
          "markdown",
          "markdown_inline",
        },
        -- Install parsers synchronously (only for ensure_installed)
        sync_install = true,
        -- Enable highlighting
        highlight = {
          enable = true,
          additional_vim_regex_highlighting = false,
        },
        -- Optional: Enable other Treesitter modules
        indent = {
          enable = true,
        },
      })
    end,
  },
}
