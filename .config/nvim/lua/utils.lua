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
