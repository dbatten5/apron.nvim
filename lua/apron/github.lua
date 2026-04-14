local M = {}

---Get the content of a PR template by template name
---@param template_name? string The template name. If not provided and there are
---available templates then return the first one.
---@return string|nil the PR template if found or nil otherwise
function M.get_pr_template(template_name)
	local cmd = "gh repo view --json pullRequestTemplates"
	local output = vim.fn.system(cmd)

	if vim.v.shell_error ~= 0 or output == "" then
		return nil
	end

	local ok, data = pcall(vim.json.decode, output)
	if not ok or not data.pullRequestTemplates then
		return nil
	end

	if not template_name and #data.pullRequestTemplates > 0 then
		return data.pullRequestTemplates[1].body
	end

	local selected_template = nil
	for _, item in ipairs(data.pullRequestTemplates) do
		if item.filename == template_name then
			selected_template = item.body
			break
		end
	end

	return selected_template
end

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
