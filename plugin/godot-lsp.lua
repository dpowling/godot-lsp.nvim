-- godot-lsp.nvim plugin entry point
-- This file is automatically sourced by Neovim

if vim.g.loaded_godot_lsp then
  return
end
vim.g.loaded_godot_lsp = 1

-- Create user commands
vim.api.nvim_create_user_command('GodotLspStart', function()
  require('godot-lsp').start()
end, { desc = 'Manually start Godot LSP' })

vim.api.nvim_create_user_command('GodotLspStatus', function()
  require('godot-lsp').status()
end, { desc = 'Check Godot LSP status' })

vim.api.nvim_create_user_command('GodotLspReset', function()
  require('godot-lsp').reset()
end, { desc = 'Reset Godot LSP tracking' })