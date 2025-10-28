-- lua/plugins/which-key.lua

return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  opts = {
    preset = "modern",
    delay = 500, -- delay antes de mostrar which-key
    win = {
      border = "rounded",
      padding = { 1, 2 },
    },
    icons = {
      mappings = true,
      keys = {
        Up = "↑",
        Down = "↓",
        Left = "←",
        Right = "→",
        C = "⌃",
        M = "⌥",
        D = "⌘",
        S = "⇧",
        CR = "↵",
        Esc = "⎋",
        ScrollWheelDown = "↓",
        ScrollWheelUp = "↑",
        NL = "↵",
        BS = "⌫",
        Space = "␣",
        Tab = "⇥",
        F1 = "F1",
        F2 = "F2",
        F3 = "F3",
        F4 = "F4",
        F5 = "F5",
        F6 = "F6",
        F7 = "F7",
        F8 = "F8",
        F9 = "F9",
        F10 = "F10",
        F11 = "F11",
        F12 = "F12",
      },
    },
  },
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)

    -- Registrar grupos de teclas para que which-key las muestre organizadas
    wk.add({
      { "<leader>f", group = "Find/Search (Telescope)" },
      { "<leader>a", group = "Actions/Add" },
      { "<leader>s", group = "Snippets" },
      { "<leader>l", group = "LSP" },
      { "<leader>g", group = "Git" },
    })
  end,
}
