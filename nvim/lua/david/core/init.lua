-- set leader key to space
vim.g.mapleader = " "
-- Set clipboard to include both unnamed and unnamedplus
vim.o.clipboard = "unnamedplus"

-- Window-local options
vim.wo.wrap = false -- Stop line wrapping

-- Global options
vim.o.tabstop = 4    -- Number of spaces a <Tab> in the text stands for
vim.o.shiftwidth = 4 -- Size of an <Tab> while editing
vim.o.expandtab = true -- Use spaces instead of tabs

vim.api.nvim_set_keymap('n', '<Up>', 'gk', {noremap = true, silent = true})
vim.api.nvim_set_keymap('n', '<Down>', 'gj', {noremap = true, silent = true})

-- Remap close and open
vim.api.nvim_set_keymap('n', '..', 'zc', {noremap = true, silent = true})

-- Remap 'zo' to ',,'
vim.api.nvim_set_keymap('n', ',,', 'zo', {noremap = true, silent = true})
