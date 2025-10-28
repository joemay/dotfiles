return {
  {
    "neovim/nvim-lspconfig",
    config = function()
      -- Use the new vim.lsp.config API for Neovim 0.11+
      -- Reference: :help lspconfig-nvim-0.11

      -- Check Neovim version and use appropriate API
      local nvim_version = vim.version()
      local use_new_api = nvim_version.major > 0 or (nvim_version.major == 0 and nvim_version.minor >= 11)

      if use_new_api then
        -- New API for Neovim 0.11+

        -- Emmet Language Server
        vim.lsp.config('emmet_ls', {
          cmd = { 'emmet-ls', '--stdio' },
          filetypes = {
            "html", "css", "scss", "javascript", "javascriptreact",
            "typescript", "typescriptreact", "vue", "svelte", "htmldjango"
          },
          root_markers = { ".git", "package.json" },
          init_options = {
            html = {
              options = {
                ["bem.enabled"] = true,
              },
            },
          },
        })

        -- CSS Language Server
        vim.lsp.config('cssls', {
          cmd = { 'vscode-css-language-server', '--stdio' },
          filetypes = { "css", "scss", "less" },
          root_markers = { ".git", "package.json" },
        })

        -- Go Language Server
        vim.lsp.config('gopls', {
          cmd = { "gopls" },
          filetypes = { "go", "gomod", "gowork", "gotmpl" },
          root_markers = { "go.work", "go.mod", ".git" },
        })

        -- Enable LSP servers for configured filetypes
        vim.lsp.enable({ 'emmet_ls', 'cssls', 'gopls' })

      else
        -- Fallback to old API for Neovim < 0.11
        local lspconfig = require("lspconfig")

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

        lspconfig.cssls.setup({
          filetypes = { "css", "scss", "less" },
        })

        lspconfig.gopls.setup({
          cmd = {"gopls"},
          filetypes = {"go", "gomod", "gowork", "gotmpl"},
          root_dir = require("lspconfig/util").root_pattern("go.work", "go.mod", ".git"),
        })
      end
    end,
  },
}
