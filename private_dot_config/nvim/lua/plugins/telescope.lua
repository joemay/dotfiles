-- lua/plugins/telescope.lua

return {
  'nvim-telescope/telescope.nvim',
  tag = '0.1.8',
  dependencies = { 'nvim-lua/plenary.nvim' },
  -- Note: Keymaps are now centralized in lua/config/mappings.lua
}
