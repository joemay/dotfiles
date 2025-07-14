return {
  {
    "nvim-treesitter/nvim-treesitter-textobjects",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    config = function()
      require("nvim-treesitter.configs").setup({
        textobjects = {
          select = {
            enable = true,
            lookahead = true,
            keymaps = {
              ["at"] = "@tag.outer",   -- <div>contenido</div>
              ["it"] = "@tag.inner",   -- contenido
            },
          },
        },
      })
    end,
  },
}

