return {
  {
    "nvim-treesitter/nvim-treesitter",
    build = ":TSUpdate",
    event = { "BufReadPre", "BufNewFile" },

    opts = {
      ensure_installed = {
        "bash","c","cmake","cpp","cuda","lua","python","rust",
        "vim","vimdoc","query","markdown","markdown_inline",
      },
      sync_install = true,
      highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
      },
      indent = { enable = true },
    },

    config = function(_, opts)
      local ok, configs = pcall(require, "nvim-treesitter.configs")
      if not ok then
        return
      end
      configs.setup(opts)
    end,
  },
}
