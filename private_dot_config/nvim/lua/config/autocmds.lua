-- lua/config/autocmds.lua

-- Formatear con Prettier al guardar ciertos archivos
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = { "*.js", "*.ts", "*.jsx", "*.tsx", "*.json", "*.css", "*.scss", "*.less", "*.yaml", "*.md" },
  callback = function()
    vim.cmd("Prettier")
  end,
})

vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.html",
  callback = function()
    if vim.bo.filetype == "htmldjango" then
      -- Guarda la posición actual del cursor
      local pos = vim.api.nvim_win_get_cursor(0)
      -- Reindenta todo el archivo
      vim.cmd("silent normal! gg=G")
      -- Restaura la posición del cursor
      vim.api.nvim_win_set_cursor(0, pos)
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "htmldjango",
  callback = function()
    vim.bo.indentexpr = "HtmlIndent()"
  end,
})

-- Configurar archivos .hubl para usar htmldjango por defecto
vim.api.nvim_create_autocmd({"BufRead", "BufNewFile"}, {
  pattern = "*.hubl",
  callback = function()
    vim.bo.filetype = "htmldjango"
  end,
})

-- Define a new command to open the snippets picker
vim.api.nvim_create_user_command("Snippets", function()
  require("snippets").open()
end, { desc = "Open the snippets picker" }) 
