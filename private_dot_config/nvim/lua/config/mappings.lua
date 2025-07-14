-- ~/.config/nvim/lua/config/mappings.lua

-- Save
vim.api.nvim_set_keymap('n', 'ww', ':w<CR>', { noremap = true, silent = true })

-- Harpoon
vim.keymap.set("n", "<leader>a", function()
  require("harpoon.mark").add_file()
end)

vim.keymap.set("n", "<leader>m", function()
  require("harpoon.ui").toggle_quick_menu()
end)

vim.keymap.set("n", "<leader>1", function()
  require("harpoon.ui").nav_file(1)
end)

vim.keymap.set("n", "<leader>2", function()
  require("harpoon.ui").nav_file(2)
end)

vim.keymap.set("n", "<leader>fh", ":Telescope harpoon marks<CR>")

vim.keymap.set("n", "<leader>sn", ":Snippets<CR>", { desc = "Open snippets picker" })
