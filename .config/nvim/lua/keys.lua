--- Variáveis
local vg = vim.g
local nv = { "n", "v" }
local nvi = { "n", "v", "i" }
local vi = { "v", "i" }
local ni = { "n", "i" }
vg.mapleader = " "
vg.maplocalleader = " "

function Keymaps(maps)
	for i, _ in pairs(maps) do
		if maps[i][4] == nil then
			maps[i][4] = {}
		end
		vim.keymap.set(maps[i][1], maps[i][2], maps[i][3], maps[i][4])
	end
end

Keymaps({
	{
		nvi,
		"<C-h>",
		vim.lsp.buf.signature_help,
		{ noremap = true, silent = true },
	},
	-- switch buffers
	{ nvi, "<C-Tab>", vim.cmd.bn },
	-- WHY THIS RETARDED BINDING EXISTS?
	{ nvi, "<C-z>", "" },
	-- join lines
	{ ni, "<C-j>", function() JoinLines(" ") end },
	{ "v", "<C-j>", function() JoinLines("") end },
	-- colar na linha de baixo
	{ nv, "P", "<cmd>norm o<cr>p" },
	-- trocar de split
	{ nvi, "<A-w>", "<esc><C-w>w" },
	-- toggle netrw
	{ nvi, "<A-f>", NetrwToggle },
	-- formatar buffer
	{
		nv,
		"<leader>I",
		function()
			vim.lsp.buf.format({ async = true })
		end,
		{ noremap = true, silent = true }
	},
	-- formatar paragrafo
	{ nv, "<leader>ii", "{=}<C-o>" },
	-- alinhar texto
	{ "v", "<leader>A", ":!column -t -o ' '<cr>", { silent = true } },
	-- mudar o typo de arquivo
	{ nv, "<leader>ft", ":setlocal filetype=" },
	-- Fechar neovim completamente
	{ nv, "<leader>qq", "<cmd>qa!<cr>" },
	-- salvar e fechar buffer
	{ nv, "ZX", "<cmd>wq<cr>" },
	-- salvar buffer
	{ nv, "ZZ", "<cmd>w<cr><cmd>e<cr>" },
	-- deletar buffer
	{ nv, "<leader>k", "<cmd>bd<cr>" },
	-- abre o buffer de mensagens
	{ nv, "<leader>m", "<cmd>message<cr>" },
	-- carregar buffer
	{ "n", "<leader>eb", "<cmd>source %<cr>" },
	-- divide a tela abaixo
	{ nvi, "<A-s>", "<esc><cmd>sp<cr>" },
	-- divide a tela do lado
	{ nvi, "<A-S-s>", "<esc><cmd>vs<cr>" },
	-- copiar buffer
	{ nv, "<leader>bc", "ggVGy<C-o>zz" },
	-- ativa/desativa números de linha
	{ nv, "zn", "<cmd>setlocal number! relativenumber!<cr>" },
	-- ativa/desativa indicação de linha
	{ nv, "zl", "<cmd>setlocal cursorline!<cr>" },
	-- ativa/desativa o corretor ortográfico
	{ nv, "zs", "<cmd>setlocal spell!<cr>" },
	-- procura palavra no cursor
	{ nv, [[?]], "*", { remap = true } },
	-- substitui seleção
	{ "v", "<leader>S", ReplaceSel },
	-- procura e substitui no arquivo
	{ "n", "<leader>ss", ":%s//gc<left><left><left>" },
	-- procura e substitui na região selecionada
	{ "v", "<leader>ss", ":s//gc<left><left><left>" },
	-- deleta linhas
	{ nv, "<leader>sd", ":G//d<left><left>" },
	-- abre terminal do sistema no local do arquivo atual
	{ "n", "<leader><return>", "<cmd>!sh -c 'term_open' &<cr><cr>" },
	-- vai para diagnostico
	-- { "n", "[d", vim.diagnostic.goto_prev },
	-- { "n", "]d", vim.diagnostic.goto_next },
	-- abre snippets
	{ "n", "<leader>S", ":e ~/.config/nvim/snippets/" },
	-- move linhas
	{ "n", "<A-j>", "<cmd>m .+1<CR>==" },
	{ "n", "<A-k>", "<cmd>m .-2<CR>==" },
	{ "i", "<A-j>", "<cmd>m .+1<CR>" },
	{ "i", "<A-k>", "<cmd>m .-2<CR>" },
	{ "v", "<A-j>", ":m '>+1<CR>gv==-gv-gv", { silent = true } },
	{ "v", "<A-k>", ":m '<-2<CR>gv==-gv-gv", { silent = true } },
	-- marca/desmarca checkboxes
	{ "n", "cx", ToggleCheckbox },
	{
		vi,
		"<C-s>",
		"<cmd>normal! n<cr>",
	},
	{
		nvi,
		"<C-S-s>",
		"<cmd>normal! N<cr>",
	},
	{
		"i",
		"<C-c>",
		"<C-o>S",
	},
	{
		"i",
		"<A-w>",
		"<C-o>de",
	},
})

-- fecha buffers de ajuda
vim.api.nvim_create_autocmd("FileType", {
	pattern = { "help" },
	callback = function()
		vim.keymap.set(
			{ "n", "i" },
			"<esc>",
			"<cmd>bd!<cr>",
			{ buffer = true, noremap = true, silent = true }
		)
	end,
})
