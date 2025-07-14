local pickers = require("telescope.pickers")
local finders = require("telescope.finders")
local conf = require("telescope.config").values
local entry_display = require("telescope.pickers.entry_display")

local function grep_ids_classes()
  -- Usa grep para buscar id= o class= en el archivo actual
  local filename = vim.api.nvim_buf_get_name(0)
  -- print("Buscando en archivo: " .. filename)
  local results = {}
  local handle = io.popen("grep -nE 'id\\s*=|class\\s*=' " .. vim.fn.shellescape(filename))
  if handle then
    for line in handle:lines() do
      -- print("Línea encontrada: " .. line)
      -- line: "6:  <body class=\"dsd dsd\" id=\"main-body\">"
      local lineno, text = line:match("^(%d+):(.*)$")
      if lineno and text then
        -- Busca todos los id y class en la línea
        for attr, value in text:gmatch('(%w+)%s*=%s*["\']([^"\']+)["\']') do
          if attr == "id" then
            table.insert(results, {attr = "id", value = value, line = tonumber(lineno)})
          elseif attr == "class" then
            for class in value:gmatch("%S+") do
              -- print("Clase encontrada:", class)
              table.insert(results, {attr = "class", value = class, line = tonumber(lineno)})
              -- print(vim.inspect(results[#results]))
            end
          end
        end
        -- print(vim.inspect(results[#results]))
      end
    end
    handle:close()
  end

  if #results == 0 then
    vim.notify("No se encontraron IDs o clases en este archivo", vim.log.levels.INFO)
    return
  end

  local displayer = entry_display.create({
    separator = " ",
    items = {
      { width = 6 },
      { remaining = true },
      { width = 6 },
    },
  })

  local function make_display(entry)
    return displayer({
      { tostring(entry.value.attr), "TelescopeResultsClass" },
      { tostring(entry.value.value) },
      { tostring(entry.value.line), "TelescopeResultsLineNr" },
    })
  end

  pickers.new({}, {
    prompt_title = "IDs y clases (grep)",
    finder = finders.new_table({
      results = results,
      entry_maker = function(entry)
        return {
          value = entry,
          display = make_display,
          ordinal = entry.attr .. " " .. entry.value,
          line = entry.line,
        }
      end,
    }),
    sorter = conf.generic_sorter({}),
    attach_mappings = function(prompt_bufnr)
      local actions = require("telescope.actions")
      local action_set = require("telescope.actions.set")

      action_set.select:replace(function()
        local selection = require("telescope.actions.state").get_selected_entry()
        actions.close(prompt_bufnr)
        if selection and selection.line then
          vim.api.nvim_win_set_cursor(0, { selection.line, 0 })
          vim.cmd("normal! zz")
        end
      end)

      return true
    end,
  }):find()
end

return {
  grep_ids_classes = grep_ids_classes,
}