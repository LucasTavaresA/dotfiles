local vc = vim.cmd
local vo = vim.opt
local vf = vim.fn
local va = vim.api

local lua_terminal_window = nil
local lua_terminal_buffer = nil
local terminal_split_size = tonumber(va.nvim_exec("echo &lines", true)) / 2.5
--- Ativa/Desativa o terminal
function TerminalToggle()
  if vf.win_gotoid(lua_terminal_window) == 1 then
    if vf.win_gotoid(lua_terminal_window) == 1 then
      vc("hide")
    end
  elseif vf.bufexists(lua_terminal_buffer) == 0 then
    vc("new lua_terminal")
    vc("wincmd J")
    vc("resize " .. terminal_split_size)
    vf.termopen(os.getenv("SHELL"), {
      detach = 1,
    })
    vc("silent file Terminal 1")
    lua_terminal_window = vf.win_getid()
    lua_terminal_buffer = vf.bufnr("%")
    vo.buflisted = false
  elseif vf.win_gotoid(lua_terminal_window) == 0 then
    vc("sp")
    vc("wincmd J")
    vc("resize " .. terminal_split_size)
    vc("buffer Terminal 1")
    lua_terminal_window = vf.win_getid()
  end
end

--- Facilita a criação de autocmds
---@param event string
---@param pattern table
---@param cmd string|function
function Autocmd(event, pattern, cmd)
  if type(cmd) == "string" then
    vim.api.nvim_create_autocmd(event, { pattern = pattern, command = cmd })
  elseif type(cmd) == "function" then
    vim.api.nvim_create_autocmd(event, { pattern = pattern, callback = cmd })
  end
end

--- atualiza cwd
function Update_cwd()
  local HOME = os.getenv("HOME")

  if vim.fn.getcwd() == HOME then
    vim.env.GIT_DIR = HOME .. "/etc/.dotfiles"
    vim.env.GIT_WORK_TREE = HOME
  else
    vim.env.GIT_DIR = nil
    vim.env.GIT_WORK_TREE = nil
  end

  local group = vim.api.nvim_create_augroup("stylua", {})

  if vim.fn.getcwd() == HOME then
    vim.api.nvim_create_autocmd("BufWritePost", {
      group = group,
      pattern = "*.lua",
      command = "!stylua --config-path $HOME/.config/nvim/stylua.toml %",
    })
  else
    vim.api.nvim_create_autocmd("BufWritePost", {
      group = group,
      pattern = "*.lua",
      command = "!stylua --config-path $(fd -t f -d 4 --max-results 1 stylua.toml .) %",
    })
  end
end

--- alterna aba do netrw
function NetrwToggle()
  if vim.o.ft == "netrw" then
    vim.cmd.Ex()
    vim.opt.signcolumn = "yes:9"
  else
    vim.opt.signcolumn = "no"
    vim.cmd.Ex()
    vim.opt.signcolumn = "yes"
  end
end

--- alterna indicadores de pesquisa
local ns = vim.api.nvim_create_namespace("toggle_hlsearch")
local function toggle_hlsearch(char)
  if vim.fn.mode() == "n" then
    local keys = { "<CR>", "n", "N", "*", "#", "?", "/" }
    local new_hlsearch = vim.tbl_contains(keys, vim.fn.keytrans(char))
    if vim.opt.hlsearch:get() ~= new_hlsearch then
      vim.opt.hlsearch = new_hlsearch
    end
  end
end
vim.on_key(toggle_hlsearch, ns)

local function get_visual_selection(nl_literal)
  local sr, sc, er, ec
  local mode = vim.fn.mode()

  if mode == "v" or mode == "V" or mode == "" then
    -- use the live position
    _, sr, sc, _ = unpack(vim.fn.getpos("."))
    _, er, ec, _ = unpack(vim.fn.getpos("v"))

    -- visual line doesn't provide columns
    if mode == "V" then
      sc, ec = 0, 999
    end
  else
    -- use the last known visual position
    _, sr, sc, _ = unpack(vim.fn.getpos("'<"))
    _, er, ec, _ = unpack(vim.fn.getpos("'>"))
  end

  -- swap back reverse selection
  if er < sr then
    sr, er = er, sr
  end
  if ec < sc then
    sc, ec = ec, sc
  end

  local lines = vim.fn.getline(sr, er)
  local n = #lines

  if n <= 0 then
    return ""
  end

  -- does support multi-line selections
  if n > 1 then
    return nil
  end

  lines[n] = lines[n]:sub(1, ec)
  lines[1] = lines[1]:sub(sc)

  return table.concat(lines, nl_literal and "\\n" or "\n")
end

-- replaces selection in the buffer
function ReplaceSel()
  local visual_selection = get_visual_selection()

  if visual_selection == nil or visual_selection == "" then
    return
  end

  local backspace_keypresses = string.rep("\\<backspace>", 5)
  local left_keypresses = string.rep("\\<Left>", string.len("gcI") + 1)
  local escape_characters = '"\\/.*$^~[]'

  vim.cmd(
    ':call feedkeys(":'
      .. backspace_keypresses
      .. "%s/"
      .. vim.fn.escape(
        vim.fn.escape(visual_selection, escape_characters),
        escape_characters
      )
      .. "/"
      .. vim.fn.escape(
        vim.fn.escape(visual_selection, escape_characters),
        escape_characters
      )
      .. "/"
      .. "gcI"
      .. left_keypresses
      .. '")'
  )
end

--- places command output in a buffer
vim.api.nvim_create_user_command("Redir", function(ctx)
  local lines =
    vim.split(vim.api.nvim_exec(ctx.args, true), "\n", { plain = true })
  vim.cmd("new")
  vim.api.nvim_buf_set_lines(0, 0, -1, false, lines)
  vim.opt_local.modified = false
  vim.bo.filetype = "qf"
end, { nargs = "+", complete = "command" })

--- Marca/Desmarca checkboxes
function ToggleCheckbox()
  local line = vim.api.nvim_get_current_line()
  local ft = vim.o.ft
  ---@type table<string, string>
  local checkboxes = {
    org = " X",
    neorg = " x",
    markdown = " x",
  }
  local checked = checkboxes[ft]:sub(-1)

  line = line:gsub(
    "^(%s*[%-%+%*]?[%w]*[%)%.]? %[)([" .. checkboxes[ft] .. "])(%])",
    function(left, state, right)
      if state == checked then
        state = " "
      elseif state == " " then
        state = checked
      end

      return left .. state .. right
    end
  )

  vim.api.nvim_set_current_line(line)
end

--- Abre o netrw na pasta do arquivo atual
function NetrwCurrent()
  local dir = vim.fn.expand("%:h")

  if dir == "" then
    dir = vim.fn.getcwd()
  end

  vim.cmd.Ex(dir)
end

function SearchCount()
  if vim.v.hlsearch == 0 then
    return ""
  end

  local result = vim.fn.searchcount({ maxcount = 999, timeout = 250 })

  if result.incomplete == 1 or next(result) == nil then
    return ""
  end

  return string.format(
    "[%d/%d]",
    result.current,
    math.min(result.total, result.maxcount)
  )
end
