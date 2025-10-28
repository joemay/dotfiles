-- ~/.config/nvim/lua/config/mappings.lua
-- Centralized keymaps configuration

-- ============================================================================
-- GENERAL MAPPINGS
-- ============================================================================

-- Save file
vim.keymap.set('n', 'ww', ':w<CR>', { noremap = true, silent = true, desc = "Save file" })

-- ============================================================================
-- TELESCOPE MAPPINGS (<leader>f = Find/Search)
-- ============================================================================

local telescope_builtin = function()
  return require('telescope.builtin')
end

-- File operations
vim.keymap.set('n', '<leader>ff', function() telescope_builtin().find_files() end, { desc = "Find files" })
vim.keymap.set('n', '<leader>fr', function() telescope_builtin().oldfiles() end, { desc = "Recent files" })
vim.keymap.set('n', '<leader>fb', function() telescope_builtin().buffers() end, { desc = "Search buffers" })

-- Text search
vim.keymap.set('n', '<leader>fg', function() telescope_builtin().live_grep() end, { desc = "Live grep (search text)" })
vim.keymap.set('n', '<leader>fw', function()
  local save_iskeyword = vim.bo.iskeyword
  vim.bo.iskeyword = vim.bo.iskeyword .. ",-"
  telescope_builtin().grep_string()
  vim.bo.iskeyword = save_iskeyword
end, { desc = "Search word under cursor" })

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
  telescope_builtin().grep_string({ search = search_text })
end, { desc = "Search selected text" })

vim.keymap.set('n', '<leader>fW', function()
  local input = vim.fn.input("Search: ")
  if input ~= "" then
    telescope_builtin().grep_string({ search = input })
  end
end, { desc = "Manual text search" })

vim.keymap.set('n', '<leader>fS', function()
  local input = vim.fn.input("Buscar texto (con espacios): ")
  if input ~= "" then
    local escaped_input = vim.fn.escape(input, '\\')
    telescope_builtin().grep_string({ search = escaped_input })
  end
end, { desc = "Search text with spaces" })

-- Vim/Neovim search
vim.keymap.set('n', '<leader>fh', function() telescope_builtin().help_tags() end, { desc = "Search help" })
vim.keymap.set('n', '<leader>fk', function() telescope_builtin().keymaps() end, { desc = "Search keymaps" })
vim.keymap.set('n', '<leader>fc', function() telescope_builtin().commands() end, { desc = "Search commands" })
vim.keymap.set('n', '<leader>fq', function() telescope_builtin().quickfix() end, { desc = "Search quickfix list" })
vim.keymap.set('n', '<leader>fm', function() telescope_builtin().marks() end, { desc = "Search marks" })

-- LSP symbols
vim.keymap.set('n', '<leader>fs', function() telescope_builtin().lsp_document_symbols() end, { desc = "Search LSP symbols" })

-- HTML IDs and Classes
vim.keymap.set("n", "<leader>fi", function()
  require("html_ids_classes").grep_ids_classes()
end, { desc = "Search HTML IDs/classes" })

-- Harpoon marks via Telescope
vim.keymap.set("n", "<leader>fH", ":Telescope harpoon marks<CR>", { desc = "Search Harpoon marks" })

-- Filetype switcher
vim.keymap.set('n', '<leader>ft', function()
  local pickers = require('telescope.pickers')
  local finders = require('telescope.finders')
  local conf = require('telescope.config').values
  local actions = require('telescope.actions')
  local action_state = require('telescope.actions.state')

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
end, { desc = "Change filetype" })

-- ============================================================================
-- FILE ACTIONS (<leader>a = Actions)
-- ============================================================================

-- Duplicate file
vim.keymap.set('n', '<leader>ad', function()
  local current_dir = vim.fn.expand('%:h')
  local name_without_ext = vim.fn.expand('%:t:r')
  local extension = vim.fn.expand('%:e')
  local default_name = name_without_ext .. "-copy." .. extension
  local new_name = vim.fn.input("Duplicate file as: ", default_name)

  if new_name ~= "" then
    local full_path = current_dir .. "/" .. new_name
    vim.cmd('saveas ' .. full_path)
    vim.notify("File duplicated as: " .. full_path, vim.log.levels.INFO)
  end
end, { desc = "Duplicate file" })

-- Rename file
vim.keymap.set('n', '<leader>ar', function()
  local current_name = vim.fn.expand('%:t')
  local new_name = vim.fn.input("Rename file as: ", current_name)
  if new_name ~= "" and new_name ~= current_name then
    vim.cmd('file ' .. new_name)
    vim.notify("File renamed as: " .. new_name, vim.log.levels.INFO)
  end
end, { desc = "Rename file" })

-- ============================================================================
-- HARPOON (<leader>a for add, <leader>m for menu, <leader>1-9 for navigation)
-- ============================================================================

vim.keymap.set("n", "<leader>aa", function()
  require("harpoon.mark").add_file()
end, { desc = "Harpoon: Add file" })

vim.keymap.set("n", "<leader>m", function()
  require("harpoon.ui").toggle_quick_menu()
end, { desc = "Harpoon: Toggle menu" })

vim.keymap.set("n", "<leader>1", function()
  require("harpoon.ui").nav_file(1)
end, { desc = "Harpoon: Go to file 1" })

vim.keymap.set("n", "<leader>2", function()
  require("harpoon.ui").nav_file(2)
end, { desc = "Harpoon: Go to file 2" })

vim.keymap.set("n", "<leader>3", function()
  require("harpoon.ui").nav_file(3)
end, { desc = "Harpoon: Go to file 3" })

vim.keymap.set("n", "<leader>4", function()
  require("harpoon.ui").nav_file(4)
end, { desc = "Harpoon: Go to file 4" })

-- ============================================================================
-- SNIPPETS (<leader>s = Snippets)
-- ============================================================================

vim.keymap.set("n", "<leader>sn", ":Snippets<CR>", { desc = "Open snippets picker" })

-- ============================================================================
-- WRAP WITH TAG (<leader>w)
-- ============================================================================

vim.keymap.set("v", "<leader>w", ":WrapWithTag<CR>", { noremap = true, silent = true, desc = "Wrap selection with HTML tag" })
