local config = require("apron.config")
local window = require("apron.window")
local github = require("apron.github")

local github_interface = {
	create_pr = function(title, description)
		local success, result = github.create_pr(title, description)

		if success then
			vim.notify("[Apron] PR created: " .. result, vim.log.levels.INFO)
		else
			vim.notify("[Apron] Failed to create PR: " .. result, vim.log.levels.ERROR)
		end
	end,
}

local M = {}

---Set up the plugin with optional user configuration.
---
---@param opts? ApronConfig
function M.setup(opts)
	config.setup(opts)
end

---Open the Apron UI
function M.open_ui()
	window.open(github_interface)
end

return M
