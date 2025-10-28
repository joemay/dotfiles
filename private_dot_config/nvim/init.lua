-- /.config/nvim/init.lua

--vim.filetype.add({
  --extension = {
    --html = "html", -- asegúrate de tener esta línea
  --},
 -- pattern = {
   -- [".*%.htmldjango"] = "html", -- fuerza htmldjango como html
  --},
-- })

require("config.lazy")
require("config.wrap")
require("config.mappings")
require("config.autocmds")

-- html_ids_classes module (keymaps are in config/mappings.lua)
require("html_ids_classes")


-- Configuración de indentación con espacios
vim.o.autoindent = true
vim.o.smartindent = true
vim.o.expandtab = true      -- Usa espacios en lugar de tabs
vim.o.tabstop = 2           -- Cada tab equivale a 2 espacios
vim.o.shiftwidth = 2        -- Indentación al usar >> o <<
vim.o.softtabstop = 2       -- Espacios al presionar Tab

-- Mostrar espacios y tabs
vim.o.list = true
vim.o.listchars = "tab:→ ,trail:·,space:·"

vim.g.mapleader = " "
vim.g.maplocalleader = "\\"
