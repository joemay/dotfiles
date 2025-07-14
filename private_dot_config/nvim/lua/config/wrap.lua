-- lua/config/wrap.lua

vim.api.nvim_create_user_command("WrapWithTag", function(opts)
  local input = vim.fn.input("Wrap with tag (e.g. strong, span.highlight): ")
  if input == "" then return end

  local tag = input:match("^[^.#]+") or "span"

  -- Extraer todas las clases
  local class_matches = {}
  for class in input:gmatch("%.([%w%-_]+)") do
    table.insert(class_matches, class)
  end
  local class_attr = #class_matches > 0 and ' class="' .. table.concat(class_matches, " ") .. '"' or ""

  -- Extraer el ID
  local id_attr = ""
  local id = input:match("#([%w%-_]+)")
  if id then
    id_attr = ' id="' .. id .. '"'
  end

  local open_tag = "<" .. tag .. class_attr .. id_attr .. ">"
  local close_tag = "</" .. tag .. ">"

  -- Obtener la selección exacta
  local start_pos = vim.fn.getpos("'<")
  local end_pos = vim.fn.getpos("'>")
  local line_start = start_pos[2]
  local col_start = start_pos[3]
  local line_end = end_pos[2]
  local col_end = end_pos[3]

  if line_start == line_end then
    local line = vim.fn.getline(line_start)
    local before = line:sub(1, col_start - 1)
    local selected = line:sub(col_start, col_end)
    local after = line:sub(col_end + 1)
    vim.fn.setline(line_start, before .. open_tag .. selected .. close_tag .. after)
  else
    -- Caso multilinea (comportamiento anterior)
    local lines = vim.fn.getline(line_start, line_end)
    lines[1] = open_tag .. lines[1]
    lines[#lines] = lines[#lines] .. close_tag
    vim.fn.setline(line_start, lines)
  end
end, { range = true })

-- Mapeo en modo visual: <leader>w para envolver
vim.keymap.set("v", "<leader>w", ":WrapWithTag<CR>", { noremap = true, silent = true })

