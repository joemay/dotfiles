-- ~/.config/nvim/lua/plugins/formatting.lua
return {
  {
    "MunifTanjim/prettier.nvim",
    dependencies = { "jose-elias-alvarez/null-ls.nvim" },
    config = function()
      require("prettier").setup({
        bin = 'prettier',
        filetypes = {
          "javascript", "typescript", "javascriptreact", "typescriptreact",
          "json", "css", "scss", "less", "yaml", "markdown"
        },
      })
    end
  }
}

