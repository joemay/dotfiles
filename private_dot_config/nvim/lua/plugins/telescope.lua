-- lua/plugins/telescope.lua

return {
    'nvim-telescope/telescope.nvim', 
    tag = '0.1.8',
    config = function()
    local builtin = require('telescope.builtin')
    
    -- Telescope File Operations (Operaciones de Archivos con Telescope)
    vim.keymap.set('n', '<leader>ff', builtin.find_files, { desc = "Telescope: Find files" })
    
    -- Telescope Search Operations (Operaciones de Búsqueda con Telescope)
    vim.keymap.set('n', '<leader>fg', builtin.live_grep,  { desc = "Telescope: Search text (live grep)" })
    vim.keymap.set('n', '<leader>fb', builtin.buffers,    { desc = "Telescope: Search buffers" })
    vim.keymap.set('n', '<leader>fh', builtin.help_tags,  { desc = "Telescope: Search help" })
    vim.keymap.set('n', '<leader>fr', builtin.oldfiles, { desc = "Telescope: Search recent files" })
    vim.keymap.set('n', '<leader>fq', builtin.quickfix, { desc = "Telescope: Search quickfix list" })
    vim.keymap.set('n', '<leader>fm', builtin.marks,    { desc = "Telescope: Search marks" })
    vim.keymap.set('n', '<leader>fc', builtin.commands, { desc = "Telescope: Search commands" })
    vim.keymap.set('n', '<leader>fk', builtin.keymaps,  { desc = "Telescope: Search keymaps" })

    -- Símbolos del archivo con LSP
    vim.keymap.set('n', '<leader>fs', builtin.lsp_document_symbols, { desc = "Telescope: Search LSP symbols" })

    -- Búsqueda específica para texto con espacios
    vim.keymap.set('n', '<leader>fS', function()
      local input = vim.fn.input("Buscar texto (con espacios): ")
      if input ~= "" then
        -- Escapar caracteres especiales para grep
        local escaped_input = vim.fn.escape(input, '\\')
        builtin.grep_string({ search = escaped_input })
      end
    end, { desc = "Telescope: Search text with spaces" })

    -- Buscar palabra bajo el cursor (con guiones)
    vim.keymap.set('n', '<leader>fw', function()
      local save_iskeyword = vim.bo.iskeyword
      vim.bo.iskeyword = vim.bo.iskeyword .. ",-"
      builtin.grep_string()
      vim.bo.iskeyword = save_iskeyword
    end, { desc = "Telescope: Search word under cursor" })

    -- Búsqueda de texto seleccionado (modo visual)
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
      -- Escapar caracteres especiales para grep
      search_text = vim.fn.escape(search_text, '\\')

      require('telescope.builtin').grep_string({ search = search_text })
    end, { desc = "Telescope: Search selected text" })

    -- Pedir texto para buscar
    vim.keymap.set('n', '<leader>fW', function()
      local input = vim.fn.input("Search: ")
      if input ~= "" then
        builtin.grep_string({ search = input })
      end
    end, { desc = "Telescope: Manual text search" })

    -- File Operations (Operaciones de Archivos)
    -- Duplicar archivo actual
    vim.keymap.set('n', '<leader>ad', function()
      local current_dir = vim.fn.expand('%:h')
      local current_name = vim.fn.expand('%:t')
      local name_without_ext = vim.fn.expand('%:t:r')
      local extension = vim.fn.expand('%:e')
      
      -- Pre-rellenar solo con el nombre del archivo + "-copy"
      local default_name = name_without_ext .. "-copy." .. extension
      local new_name = vim.fn.input("Duplicate file as: ", default_name)
      
      if new_name ~= "" then
        -- Construir la ruta completa en el mismo directorio
        local full_path = current_dir .. "/" .. new_name
        
        vim.cmd('saveas ' .. full_path)
        vim.notify("File duplicated as: " .. full_path, vim.log.levels.INFO)
      end
    end, { desc = "Duplicate current file in same directory" })
    
    -- Renombrar archivo actual
    vim.keymap.set('n', '<leader>ar', function()
      local current_name = vim.fn.expand('%:t')
      local new_name = vim.fn.input("Rename file as: ", current_name)
      if new_name ~= "" and new_name ~= current_name then
        vim.cmd('file ' .. new_name)
        vim.notify("File renamed as: " .. new_name, vim.log.levels.INFO)
      end
    end, { desc = "Rename current file" })

    -- Cambiar filetype del buffer actual usando Telescope
    vim.keymap.set('n', '<leader>ft', function()
      local pickers = require('telescope.pickers')
      local finders = require('telescope.finders')
      local conf = require('telescope.config').values
      local actions = require('telescope.actions')
      local action_state = require('telescope.actions.state')

      -- Lista de filetypes comunes para archivos de template/HTML
      local filetypes = {
        { name = "html",        desc = "HTML estándar" },
        { name = "htmldjango",  desc = "HTML + Django/Jinja2" },
        { name = "jinja",       desc = "Jinja2 templates" },
        { name = "jinja.html",  desc = "Jinja2 + HTML" },
        { name = "htmljinja",   desc = "HTML + Jinja" },
        { name = "twig",        desc = "Twig templates" },
        { name = "liquid",      desc = "Liquid templates" },
      }

      pickers.new({}, {
        prompt_title = "Cambiar Filetype",
        finder = finders.new_table({
          results = filetypes,
          entry_maker = function(entry)
            return {
              value = entry.name,
              display = entry.name .. " - " .. entry.desc,
              ordinal = entry.name .. " " .. entry.desc,
            }
          end,
        }),
        sorter = conf.generic_sorter({}),
        attach_mappings = function(prompt_bufnr, map)
          actions.select_default:replace(function()
            actions.close(prompt_bufnr)
            local selection = action_state.get_selected_entry()
            vim.bo.filetype = selection.value
            vim.notify("Filetype cambiado a: " .. selection.value, vim.log.levels.INFO)
          end)
          return true
        end,
      }):find()
    end, { desc = "Telescope: Change filetype" })

  end,
}
