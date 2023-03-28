--- Conceal classes in html code ---
--- https://gist.github.com/mactep/430449fd4f6365474bfa15df5c02d27b
-- should get bufnr from autocmd or something
-- conceal only accepts one character
-- thanks to u/Rafat913 for many suggestions and tips

local namespace = vim.api.nvim_create_namespace("class_conceal")
local group = vim.api.nvim_create_augroup("class_conceal", { clear = true })

local conceal_html_class = function(bufnr)
	local language_tree = vim.treesitter.get_parser(bufnr, "html")
	local syntax_tree = language_tree:parse()
	local root = syntax_tree[1]:root()

	local query = vim.treesitter.parse_query(
		"html",
		[[
    ((attribute
        (attribute_name) @att_name (#eq? @att_name "class")
        (quoted_attribute_value (attribute_value) @class_value) (#set! @class_value conceal "…")))
    ]]
	) -- using single character for conceal thanks to u/Rafat913

	for _, captures, metadata in
		query:iter_matches(root, bufnr, root:start(), root:end_())
	do
		local start_row, start_col, end_row, end_col = captures[2]:range()
		vim.api.nvim_buf_set_extmark(bufnr, namespace, start_row, start_col, {
			end_line = end_row,
			end_col = end_col,
			conceal = metadata[2].conceal,
		})
	end
end

vim.api.nvim_create_autocmd(
	{ "BufEnter", "BufWritePost", "TextChanged", "InsertLeave" },
	{
		group = group,
		pattern = "*.html",
		callback = function()
			conceal_html_class(vim.api.nvim_get_current_buf())
		end,
	}
)
