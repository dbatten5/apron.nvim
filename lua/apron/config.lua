local M = {}

---@class ApronConfig
local defaults = {}

---@type ApronConfig
M.options = vim.deepcopy(defaults)

---Merge user-provided options with the defaults and store them.
---@param opts? ApronConfig
function M.setup(opts)
	M.options = vim.tbl_deep_extend("force", {}, defaults, opts or {})
end

---Return the current config value for the given key, or the full config table
---when no key is provided.
---@param key? string
---@return any
function M.get(key)
	if key then
		return M.options[key]
	end
	return M.options
end

return M
