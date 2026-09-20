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
end

--- alterna aba do netrw
function NetrwToggle()
	if vim.o.ft == "netrw" then
		vim.cmd.bd()
	else
		vim.cmd.Ex()
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

---@param opts? { type?: string, exclusive?: boolean, eol?: boolean }
---@return string[]? lines, table[]? regions
local function get_visual(opts)
	opts = opts or {}

	local regtype = opts.type or vim.fn.mode():match("[vV\22]")
	if not regtype then
		return
	end

	local vpos = vim.fn.getpos("v")
	local cpos = vim.fn.getpos(".")

	local reg_opts = { type = regtype, exclusive = opts.exclusive }
	local lines = vim.fn.getregion(vpos, cpos, reg_opts)

	local regpos_opts =
		{ type = regtype, exclusive = opts.exclusive, eol = opts.eol }
	local line_regs = vim.fn.getregionpos(vpos, cpos, regpos_opts)

	return lines, line_regs
end

-- replaces selection in the buffer
function ReplaceSel()
	local lines = get_visual()

	if not lines or #lines == 0 or (#lines == 1 and lines[1] == "") then
		return
	end

	-- \V (very nomagic): only `\` and the `/` delimiter stay special
	local pattern = table.concat(
		vim.tbl_map(function(line)
			return vim.fn.escape(line, [[\/]])
		end, lines),
		[[\n]]
	)

	-- on the replacement side `&` and `~` expand, and a newline is \r
	local replacement = table.concat(
		vim.tbl_map(function(line)
			return vim.fn.escape(line, [[\/&~]])
		end, lines),
		[[\r]]
	)

	-- termcodes are built apart from the selection so its text is never parsed
	local esc = vim.api.nvim_replace_termcodes("<esc>", true, false, true)
	local left = vim.api.nvim_replace_termcodes("<left>", true, false, true)
	local flags = "gcI"

	vim.api.nvim_feedkeys(
		esc
		.. [[:%s/\V]]
		.. pattern
		.. "/"
		.. replacement
		.. "/"
		.. flags
		.. string.rep(left, #flags + 1),
		"n",
		false
	)
end

--- places command output in a buffer
-- example: `:Redir !echo hello`
vim.api.nvim_create_user_command("Redir", function(ctx)
	local output = vim.api.nvim_exec2(ctx.args, { output = true }).output
	local lines = vim.split(output or "", "\n", { plain = true })
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
	local checked = checkboxes[ft]
	if not checked then
		return
	end
	checked = checked:sub(-1)

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

-- joins lines while removing comments
---@param separator string separator when joining lines
function JoinLines(separator)
	separator = separator or " "
	local view = vim.fn.winsaveview()
	local mode = vim.api.nvim_get_mode()["mode"]
	local line = vim.api.nvim_get_current_line()
	local comment = require("SingleComment").GetComment()[1]
	local cmd

	-- insert mode can't use ´:´
	if mode == "i" then
		cmd = "<cmd>"
	else
		cmd = ":"
	end

	-- don't delete comment if current line is not commented
	if not line:find(vim.pesc(comment)) then
		comment = ""
	end

	if comment == "" then
		-- prevent error on \%[] with nothing inside
		comment = " "
	end

	local input = vim.api.nvim_replace_termcodes(
		cmd
		.. [[s/\n\s*\%[]]
		.. comment
		.. [[]\s*/]]
		.. separator
		.. [[/<cr><end><esc>==]],
		true,
		false,
		true
	)
	vim.api.nvim_feedkeys(input, "n", false)
	vim.fn.winrestview(view)
end

function SummarizeCommit()
	local win = vim.api.nvim_get_current_win()
	local buf = vim.api.nvim_win_get_buf(win)
	local output = vim.fn.systemlist("git diff --cached")

	if #output > 1000 then
		return
	end

	local prompt = "Give me commit message from git diff output below using conventional commits format, capitalize the first letter."
	vim.api.nvim_buf_set_lines(buf, -1, -1, false, { "# " .. prompt })

	for _, line in ipairs(output) do
		vim.api.nvim_buf_set_lines(buf, -1, -1, false, { "# " .. line })
	end
end
