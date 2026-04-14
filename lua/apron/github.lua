local M = {}

---Create a pull request on GitHub
---@param title string PR title
---@param description string PR description
---@return boolean success Whether PR was created successfully
---@return string|nil result PR URL if success, error message if failed
function M.create_pr(title, description)
	-- Escape single quotes in body for shell
	local escaped_title = title:gsub("'", "'\\''")
	local escaped_description = description:gsub("'", "'\\''")

	local cmd = string.format("gh pr create --title '%s' --body '%s' 2>&1", escaped_title, escaped_description)

	local handle = io.popen(cmd)
	if not handle then
		return false, "Failed to execute gh command"
	end

	local output = handle:read("*a")
	local success = handle:close()

	if success then
		-- Extract PR URL from output
		local url = output:match("(https://[^\n]+)")
		if url then
			return true, url
		else
			return true, "PR created successfully"
		end
	else
		-- Return the error message from gh
		return false, output:gsub("^%s+", ""):gsub("%s+$", "")
	end
end

return M
