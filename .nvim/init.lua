-- Setup for nvim-tree
-- disable netrw at the very start of your init.lua
vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.o.hidden = true


-- Set <space> as the leader key
-- See `:help mapleader`
-- NOTE: Must happen before plugins are loaded (otherwise wrong leader will be used)
vim.g.mapleader = ' '

-- [[ Setting options ]] See `:h vim.o`
-- NOTE: You can change these options as you wish!
-- For more options, you can see `:help option-list`
-- To see documentation for an option, you can use `:h 'optionname'`, for example `:h 'number'`
-- (Note the single quotes)

-- Print the line number in front of each line
vim.o.number = true

-- Use relative line numbers, so that it is easier to jump with j, k. This will affect the 'number'
-- option above, see `:h number_relativenumber`
vim.o.relativenumber = true

-- Sync clipboard between OS and Neovim. Schedule the setting after `UiEnter` because it can
-- increase startup-time. Remove this option if you want your OS clipboard to remain independent.
-- See `:help 'clipboard'`
vim.api.nvim_create_autocmd('UIEnter', {
  callback = function()
    vim.o.clipboard = 'unnamedplus'
  end,
})

-- Case-insensitive searching UNLESS \C or one or more capital letters in the search term
vim.o.ignorecase = true
vim.o.smartcase = true

-- Highlight the line where the cursor is on
vim.o.cursorline = true

-- Minimal number of screen lines to keep above and below the cursor.
vim.o.scrolloff = 10

-- Show <tab> and trailing spaces
vim.o.list = true

-- if performing an operation that would fail due to unsaved changes in the buffer (like `:q`),
-- instead raise a dialog asking if you wish to save the current file(s) See `:help 'confirm'`
vim.o.confirm = true

-- [[ Set up keymaps ]] See `:h vim.keymap.set()`, `:h mapping`, `:h keycodes`

-- Use <Esc> to exit terminal mode
vim.keymap.set('t', '<Esc>', '<C-\\><C-n>')

-- Map <A-j>, <A-k>, <A-h>, <A-l> to navigate between windows in any modes
vim.keymap.set({ 't', 'i' }, '<A-h>', '<C-\\><C-n><C-w>h')
vim.keymap.set({ 't', 'i' }, '<A-j>', '<C-\\><Cn><C-w>j')
vim.keymap.set({ 't', 'i' }, '<A-k>', '<C-\\><C-n><C-w>k')
vim.keymap.set({ 't', 'i' }, '<A-l>', '<C-\\><C-n><C-w>l')
vim.keymap.set({ 'n' }, '<A-h>', '<C-w>h')
vim.keymap.set({ 'n' }, '<A-j>', '<C-w>j')
vim.keymap.set({ 'n' }, '<A-k>', '<C-w>k')
vim.keymap.set({ 'n' }, '<A-l>', '<C-w>l')

-- [[ Basic Autocommands ]].
-- See `:h lua-guide-autocommands`, `:h autocmd`, `:h nvim_create_autocmd()`

-- Highlight when yanking (copying) text.
-- Try it with `yap` in normal mode. See `:h vim.hl.on_yank()`
vim.api.nvim_create_autocmd('TextYankPost', {
  desc = 'Highlight when yanking (copying) text',
  callback = function()
    vim.hl.on_yank()
  end,
})

-- [[ Create user commands ]]
-- See `:h nvim_create_user_command()` and `:h user-commands`

-- Create a command `:GitBlameLine` that print the git blame for the current line
vim.api.nvim_create_user_command('GitBlameLine', function()
  local line_number = vim.fn.line('.') -- Get the current line number. See `:h line()`
  local filename = vim.api.nvim_buf_get_name(0)
  print(vim.fn.system({ 'git', 'blame', '-L', line_number .. ',+1', filename }))
end, { desc = 'Print the git blame for the current line' })

-- [[ Add optional packages ]]
-- Nvim comes bundled with a set of packages that are not enabled by
-- default. You can enable any of them by using the `:packadd` command.

-- For example, to add the "nohlsearch" package to automatically turn off search highlighting after
-- 'updatetime' and when going to insert mode
-- vim.cmd('packadd! nohlsearch')








local vim = vim
local Plug = vim.fn['plug#']

vim.call('plug#begin')


-- Add a full webtree
Plug 'nvim-tree/nvim-web-devicons'
Plug 'nvim-tree/nvim-tree.lua'

Plug 'nvim-neo-tree/neo-tree.nvim'
Plug 'nvim-lua/plenary.nvim'
Plug 'MunifTanjim/nui.nvim'

Plug 'akinsho/toggleterm.nvim'

vim.call('plug#end')















-- optionally enable 24-bit colour
vim.opt.termguicolors = true

-- nvim-tree setup
require('nvim-web-devicons').setup { default = true }
require("nvim-tree").setup({
  sort = {
    sorter = "case_sensitive",
  },
  view = {
    width = 30,
    side = "right",
  },
  renderer = {
    group_empty = true,
  },
  filters = {
    dotfiles = true,
  },
})


-- Toggle Term setup
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

-- Autocommand to resize ToggleTerm on window resize
vim.api.nvim_create_autocmd("VimResized", {
  group = vim.api.nvim_create_augroup("ToggleTermResize", { clear = true }),
  callback = function()
    -- Iterate through all windows to find ToggleTerm windows
    for _, win in ipairs(vim.api.nvim_list_wins()) do
      local buf = vim.api.nvim_win_get_buf(win)
      -- Check if the buffer is a terminal buffer managed by ToggleTerm
      if vim.bo[buf].filetype == "toggleterm" then
        -- Calculate new height (30% of current window height)
        local new_height = math.floor(vim.o.lines * 0.3)
        -- Set the window height
        vim.api.nvim_win_set_height(win, new_height)
      end
    end
  end,
})

vim.api.nvim_create_augroup("ToggleTermStatusline", { clear = true })

vim.api.nvim_create_autocmd("TermOpen", {
  group = "ToggleTermStatusline",
  pattern = "term://*toggleterm#*",
  callback = function()
    vim.opt_local.laststatus = 0           -- hide status line
    vim.opt_local.statusline = "%#Normal#" -- empty content, just applying Normal highlight
  end,
})

-- Set indentation to use two spaces for C/C++ files
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "cpp", "c", "h", "hpp", "txt" },
  callback = function()
    vim.bo.shiftwidth = 2   -- Indent size for << and >>
    vim.bo.tabstop = 2      -- Number of spaces per tab
    vim.bo.softtabstop = 2  -- Number of spaces for <Tab> in insert mode
    vim.bo.expandtab = true -- Use spaces instead of tabs
  end,
})

-- Disable mouse integration
-- This is important for enabling features such as copy-and-paste into/out of the terminal
vim.opt.mouse = ""