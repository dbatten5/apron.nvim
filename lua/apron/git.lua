local M = {}

---Check if a branch exists
---@param branch string
---@return boolean
local function branch_exists(branch)
	local handle = io.popen(string.format("git rev-parse --verify %s 2>/dev/null", branch))
	if not handle then
		return false
	end
	local result = handle:read("*a")
	handle:close()
	return result and result ~= ""
end

---Get the default branch (main or master)
---@return string
local function get_default_branch()
	if branch_exists("main") then
		return "main"
	elseif branch_exists("master") then
		return "master"
	end
	return "main" -- fallback
end

---Get the commits for the diff between two branches
---@param target_branch? string defaults to the main branch
---@param base_branch? string defaults to the current branch
---@return table[] commits List of {title: string, description: string}
function M.get_commits(target_branch, base_branch)
	target_branch = target_branch or get_default_branch()
	base_branch = base_branch or "HEAD"

	-- Use %x00 as delimiter between commits, %x01 between title and body
	local cmd = string.format("git log %s..%s --pretty=format:'%%s%%x01%%b%%x00'", target_branch, base_branch)

	local handle = io.popen(cmd)
	if not handle then
		return {}
	end

	local output = handle:read("*a")
	handle:close()

	if not output or output == "" then
		return {}
	end

	local commits = {}
	-- Split by null character (commit delimiter)
	for commit_str in output:gmatch("([^%z]+)") do
		-- Split by %x01 (title/body delimiter)
		local title, description = commit_str:match("^([^%c]*)%c?(.*)$")
		if title then
			-- Trim whitespace from description
			description = description and description:gsub("^%s+", ""):gsub("%s+$", "") or ""
			table.insert(commits, {
				title = title,
				description = description,
			})
		end
	end

	return commits
end

return M
