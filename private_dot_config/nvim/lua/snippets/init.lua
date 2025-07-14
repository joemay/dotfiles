local M = {}

local snippets = require("snippets.snippets")
local pickers = require('telescope.pickers')
local finders = require('telescope.finders')
local actions = require('telescope.actions')
local action_state = require('telescope.actions.state')
local conf = require('telescope.config').values
local previewers = require('telescope.previewers')

local function insert_snippet(snippet)
  local bufnr = vim.api.nvim_get_current_buf()
  local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
  local lines = vim.split(snippet, "\n", { plain = true })
  vim.api.nvim_buf_set_lines(bufnr, row, row, false, lines)
end

local custom_previewer = previewers.new_buffer_previewer({
  define_preview = function(self, entry, status)
    local content = entry.value.content
    vim.api.nvim_buf_set_lines(self.state.bufnr, 0, -1, false, vim.split(content, "\n", { plain = true }))
    vim.api.nvim_buf_set_option(self.state.bufnr, 'filetype', entry.value.filetype or 'lua') -- Assuming snippets might have filetypes
  end,
})

function M.open()
  if not snippets or #snippets == 0 then
    vim.notify("No snippets found", vim.log.levels.WARN)
    return
  end
  
  pickers.new({}, {
    prompt_title = "Snippets",
    finder = finders.new_table {
      results = snippets,
      entry_maker = function(entry)
        return {
          value = entry,
          display = entry.name,
          ordinal = entry.name,
          -- Add filetype for syntax highlighting in preview
          filetype = entry.filetype -- Assuming snippets have a filetype field
        }
      end
    },
    sorter = conf.generic_sorter({}),
    previewer = custom_previewer,
    layout_strategy = 'horizontal',
    layout_config = {
      preview_width = 0.6,
    },
    attach_mappings = function(prompt_bufnr, map)
      actions.select_default:replace(function()
        local selection = action_state.get_selected_entry()
        actions.close(prompt_bufnr)
        insert_snippet(selection.value.content)
      end)
      return true
    end
  }):find()
end

return M

