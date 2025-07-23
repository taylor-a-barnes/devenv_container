return {
  'akinsho/toggleterm.nvim',
  config = function()
    require("toggleterm").setup({
      size = function(term)
        if term.direction == "horizontal" then
          return math.floor(vim.o.lines * 0.3) -- Initial height: 30% of window
        elseif term.direction == "vertical" then
          return math.floor(vim.o.columns * 0.4) -- Optional: for vertical splits
        end
      end,
      open_mapping = [[<c-\>]], -- Keybinding to toggle terminal
      direction = "horizontal", -- Default direction
      persist_size = true, -- Retain size between toggles
      hide_numbers = true, -- hide the number column in toggleterm buffers
      shade_filetypes = {},
      autochdir = false, -- when neovim changes it current directory the terminal will change it's own when next it's opened
      shade_terminals = true, -- NOTE: this option takes priority over highlights specified so if you specify Normal highlights you should set this to false
      start_in_insert = true,
      insert_mappings = true, -- whether or not the open mapping applies in insert mode
      terminal_mappings = true, -- whether or not the open mapping applies in the opened terminals
      persist_size = false,
      persist_mode = true, -- if set to true (default) the previous terminal mode will be remembered
      direction = 'horizontal',
      close_on_exit = true, -- close the terminal window when the process exits
      clear_env = false, -- use only environmental variables from `env`, passed to jobstart()
      -- Change the default shell. Can be a string or a function returning a string
      --  shell = vim.o.shell,
      shell = "/bin/bash",
      auto_scroll = true, -- automatically scroll to the bottom on terminal output
    })

  end,
}
