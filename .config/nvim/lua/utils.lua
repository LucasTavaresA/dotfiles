local vc = vim.cmd
local vo = vim.opt
local vol = vim.opt_local
local vf = vim.fn
local va = vim.api

--- Executar e lembrar um commando
function Compile()
  vim.ui.input({ prompt = "Compile with> ", default = Compile_cmd }, function(input)
    Compile_cmd = input
    if Compile_cmd ~= nil then
      vc(":! " .. Compile_cmd)
    end
  end)
end

--- Ativa/Desativa o terminal
local lua_terminal_window = nil
local lua_terminal_buffer = nil
local terminal_split_size = tonumber(va.nvim_exec("echo &lines", true)) / 2.5

function TerminalToggle()
  if vf.win_gotoid(lua_terminal_window) == 1 then
    if vf.win_gotoid(lua_terminal_window) == 1 then
      vc("hide")
    end
  else
    if vf.bufexists(lua_terminal_buffer) == 0 then
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
    else
      if vf.win_gotoid(lua_terminal_window) == 0 then
        vc("sp")
        vc("wincmd J")
        vc("resize " .. terminal_split_size)
        vc("buffer Terminal 1")
        lua_terminal_window = vf.win_getid()
      end
    end
    vc("startinsert")
  end
end

--- Marcar e desmarcar checkboxes markdown
vc([[
    function Marcar()
        let l:line=getline('.')
        let l:curs=winsaveview()
        if l:line=~?'\s*-\s*\[\s*\].*'
            s/\[.\]/[X]/
        elseif l:line=~?'\s*-\s*\[X\].*'
            s/\[X\]/[ ]/
        endif
        call winrestview(l:curs)
    endfunction
]])

--- mudar leadmultispace dependendo do filetype
function ListChars()
  local indicator = "│"
  local width = va.nvim_buf_get_option(0, "shiftwidth") - 1
  vol.listchars:append("leadmultispace:" .. indicator .. string.rep(".", width))
end
