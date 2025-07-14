-- lua/plugins/telescope.lua

return {
    'nvim-telescope/telescope.nvim', 
    tag = '0.1.8',
    config = function()
    local builtin = require('telescope.builtin')
    -- Atajos con <leader>
    vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "Buscar archivos" })
    vim.keymap.set('n', '<leader>fg', builtin.live_grep,  { desc = "Buscar texto (live grep)" })
    vim.keymap.set('n', '<leader>fb', builtin.buffers,    { desc = "Buscar buffers" })
    vim.keymap.set('n', '<leader>fh', builtin.help_tags,  { desc = "Buscar ayuda" })

    vim.keymap.set('n', '<leader>fr', builtin.oldfiles, { desc = "Buscar archivos recientes" })
    vim.keymap.set('n', '<leader>fq', builtin.quickfix, { desc = "Buscar en quickfix list" })
    vim.keymap.set('n', '<leader>fm', builtin.marks,    { desc = "Buscar marcas" })
    vim.keymap.set('n', '<leader>fc', builtin.commands, { desc = "Buscar comandos" })
    vim.keymap.set('n', '<leader>fk', builtin.keymaps,  { desc = "Buscar keymaps" })

    -- Símbolos del archivo con LSP
    vim.keymap.set('n', '<leader>fs', builtin.lsp_document_symbols, { desc = "Buscar símbolos LSP en el documento" })

    -- Buscar palabra bajo el cursor (con guiones)
    vim.keymap.set('n', '<leader>fw', function()
      local save_iskeyword = vim.bo.iskeyword
      vim.bo.iskeyword = vim.bo.iskeyword .. ",-"
      builtin.grep_string()
      vim.bo.iskeyword = save_iskeyword
    end, { desc = "Buscar palabra bajo el cursor (con guiones)" })

    vim.keymap.set('v', '<leader>fw', function()
      local start_pos = vim.fn.getpos("'<")
      local end_pos = vim.fn.getpos("'>")
      local lines = vim.fn.getline(start_pos[2], end_pos[2])

      if #lines == 0 then return end

      if #lines == 1 then
        lines[1] = string.sub(lines[1], start_pos[3], end_pos[3] - 1)
      else
        lines[1] = string.sub(lines[1], start_pos[3])
        lines[#lines] = string.sub(lines[#lines], 1, end_pos[3] - 1)
      end

      local search_text = table.concat(lines, " ")
      search_text = vim.fn.escape(search_text, '\\')

      require('telescope.builtin').grep_string({ search = search_text })
    end, { desc = "Buscar texto seleccionado" })

    -- Pedir texto para buscar
    vim.keymap.set('n', '<leader>fW', function()
      local input = vim.fn.input("Buscar: ")
      if input ~= "" then
        builtin.grep_string({ search = input })
      end
    end, { desc = "Buscar texto ingresado" })

  end,
}
