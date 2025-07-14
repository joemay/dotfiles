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
      vim.cmd("normal! gg=G")
    end
  end,
})

vim.api.nvim_create_autocmd("FileType", {
  pattern = "htmldjango",
  callback = function()
    vim.bo.indentexpr = "HtmlIndent()"
  end,
})

-- Define a new command to open the snippets picker
vim.api.nvim_create_user_command("Snippets", function()
  require("snippets").open()
end, { desc = "Open the snippets picker" }) 