-- bind jk to ESC
vim.api.nvim_set_keymap('i', 'jk', '<ESC>', { noremap = true })

-- Copy cursor to end of the line
vim.api.nvim_set_keymap('n', 'Y', 'y$', { noremap = true })

-- Better tabbing
vim.api.nvim_set_keymap('v', '<', '<gv', { noremap = true })
vim.api.nvim_set_keymap('v', '>', '>gv', { noremap = true })

-- Move through splits
vim.api.nvim_set_keymap('n', '<C-h>', '<C-w>h', { noremap = false })
vim.api.nvim_set_keymap('n', '<C-j>', '<C-w>j', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-k>', '<C-w>k', { noremap = true })
vim.api.nvim_set_keymap('n', '<C-l>', '<C-w>l', { noremap = true })

-- Leader mappings
vim.api.nvim_set_keymap('n', '<leader>pv', ':NvimTreeToggle<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>w', ':write<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>q', ':q<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>x', ':xit<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader>o', ':only<CR>', { noremap = true })
vim.api.nvim_set_keymap('n', '<leader><leader>', '<C-^>', { noremap = true })

-- Copy to clipboard
vim.keymap.set({'n', 'x'}, 'cp', '"+y')
