return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      local lspconfig = require("lspconfig")

      -- Configurar Emmet Language Server
      lspconfig.emmet_ls.setup({
        filetypes = {
          "html", "css", "scss", "javascript", "javascriptreact",
          "typescript", "typescriptreact", "vue", "svelte", "htmldjango"
        },
        init_options = {
          html = {
            options = {
              ["bem.enabled"] = true,
            },
          },
        },
      })

      -- CSS
      lspconfig.cssls.setup({
        filetypes = { "css", "scss", "less" },
      })

      lspconfig.gopls.setup({
        cmd = {"gopls"},
        filetypes = {"go", "gomod", "gowork", "gotmpl"},
        root_dir = require("lspconfig/util").root_pattern("go.work", "go.mod", ".git"),
      })
    
    end,
  },
}
