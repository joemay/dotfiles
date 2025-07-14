-- lua/plugins/treesitter.lua

return {
  {
    'nvim-treesitter/nvim-treesitter',
    build = ':TSUpdate',
    event = { "BufReadPost", "BufNewFile" },
    opts = function(_, opts)
      opts.ensure_installed = {
        "html", "css", "javascript", "lua", "json", "bash", "typescript"
      }

      opts.highlight = { enable = true }
      opts.indent = { enable = true }
      opts.incremental_selection = {
        enable = true,
        keymaps = {
          init_selection = "gnn",
          node_incremental = "grn",
          node_decremental = "grm",
          scope_incremental = "grc",
        },
      }

      vim.list_extend(opts.ensure_installed, { "htmldjango" })

      vim.api.nvim_create_autocmd({ "BufRead", "BufNewFile" }, {
        pattern = "*.html",
        callback = function()
          vim.bo.filetype = "htmldjango"
        end,
      })
    end,
  },

  {
    'windwp/nvim-ts-autotag',
    event = "VeryLazy",
    opts = {}
  },

  {
    'andymass/vim-matchup',
    event = "VeryLazy",
    config = function()
      vim.g.matchup_matchparen_offscreen = { method = 'popup' }
    end
  }
}

