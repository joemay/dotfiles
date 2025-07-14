return {
  {
    "othree/html5.vim",
    ft = { "html", "htmldjango" }, -- carga en ambos
    config = function()
      -- Forzar indentexpr de HTML en htmldjango
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "htmldjango",
        callback = function()
          vim.bo.indentexpr = "HtmlIndent()"
        end,
      })
    end,
  },
}

