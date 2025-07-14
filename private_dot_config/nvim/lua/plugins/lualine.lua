return {
  "nvim-lualine/lualine.nvim",
  dependencies = { "nvim-tree/nvim-web-devicons" }, -- Para los íconos bonitos
  event = "VeryLazy",
  config = function()
    require("lualine").setup({
      options = {
        theme = "gruvbox",  -- Cambia por el tema que prefieras: 'tokyonight', 'dracula', 'catppuccin', etc.
        icons_enabled = true,
        section_separators = { left = '', right = '' },
        component_separators = { left = '', right = '' },
        disabled_filetypes = { "NvimTree", "neo-tree" },
      },
      sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { { "filename", path = 1 } }, -- path=1 muestra ruta relativa, 2 absoluta
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
      },
      extensions = { "nvim-tree", "quickfix", "fugitive" }
    })
  end
}

