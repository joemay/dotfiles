-- ~/.config/nvim/lua/plugins/harpoon.lua
return {
  {
    "ThePrimeagen/harpoon",
    dependencies = { "nvim-lua/plenary.nvim" },
    config = function()
      require("harpoon").setup()
    end,
  },
}


