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

function Update_cwd()
  local HOME = os.getenv("HOME")

  if vim.fn.getcwd() == HOME then
    vim.env.GIT_DIR = HOME .. "/.dotfiles"
    vim.env.GIT_WORK_TREE = HOME
  else
    vim.env.GIT_DIR = nil
    vim.env.GIT_WORK_TREE = nil
  end

  if vim.fn.getcwd() == HOME then
    Autocmd(
      "BufWritePost",
      { "*.lua" },
      "!stylua --config-path $HOME/.config/nvim/stylua.toml %"
    )
  else
    Autocmd(
      "BufWritePost",
      { "*.lua" },
      "!stylua --config-path $(fd -t f -d 4 --max-results 1 stylua.toml .) %"
    )
  end
end
