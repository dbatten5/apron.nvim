---@class GitProvider
---@field create_pr fun(title: string, description: string) Create a PR with the given content

local M = {}

---Create and open a floating window with an editable buffer
---@param git_provider GitProvider
---@return integer bufnr Buffer number
---@return integer winnr Window number
function M.open(git_provider)
	-- Create a new empty buffer
	local bufnr = vim.api.nvim_create_buf(false, true)

	-- Set buffer options
	vim.bo[bufnr].bufhidden = "wipe"
	vim.bo[bufnr].filetype = "markdown"

	-- Calculate window size and position (80% of screen)
	local width = math.min(80, math.floor(vim.o.columns * 0.8))
	local height = math.min(20, math.floor(vim.o.lines * 0.8))
	local row = math.floor((vim.o.lines - height) / 2)
	local col = math.floor((vim.o.columns - width) / 2)

	-- Open floating window
	local winnr = vim.api.nvim_open_win(bufnr, true, {
		relative = "editor",
		width = width,
		height = height,
		row = row,
		col = col,
		style = "minimal",
		border = "rounded",
		title = " Create Pull Request ",
		title_pos = "center",
	})

	local ns_id = vim.api.nvim_create_namespace("Apron_UI")

	local dashes = string.rep("#", width)
	vim.api.nvim_buf_set_lines(bufnr, 1, 1, false, { dashes })

	local separator_mark_id = vim.api.nvim_buf_set_extmark(bufnr, ns_id, 1, 0, {
		line_hl_group = "Folded",
	})

	-- Create PR on pressing "S"
	vim.keymap.set("n", "S", function()
		local mark = vim.api.nvim_buf_get_extmark_by_id(bufnr, ns_id, separator_mark_id, {})
		local sep_row = mark[1] -- This is the zero-indexed line number of the dashes

		-- Everything above the separator is the Title
		local title_lines = vim.api.nvim_buf_get_lines(bufnr, 0, sep_row, false)
		local title = table.concat(title_lines, " "):gsub("^%s*(.-)%s*$", "%1") -- Join and trim

		-- Everything below the separator is the Description
		local desc_lines = vim.api.nvim_buf_get_lines(bufnr, sep_row + 1, -1, false)
		local description = table.concat(desc_lines, "\n")

		git_provider.create_pr(title, description)
	end, { buffer = bufnr, nowait = true, desc = "Submit PR" })

	-- Start in insert mode
	vim.cmd("startinsert")

	return bufnr, winnr
end

return M
