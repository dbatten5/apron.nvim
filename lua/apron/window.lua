---@class GitProvider
---@field create_pr fun(content: string) Create a PR with the given content

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

	-- Create PR on pressing "S"
	vim.keymap.set("n", "S", function()
		-- Get buffer contents
		local lines = vim.api.nvim_buf_get_lines(bufnr, 0, -1, false)
		local content = table.concat(lines, "\n")

		git_provider.create_pr(content)
	end, { buffer = bufnr, nowait = true, desc = "Submit PR" })

	-- Start in insert mode
	vim.cmd("startinsert")

	return bufnr, winnr
end

return M
