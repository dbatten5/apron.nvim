local config = require("apron.config")

local M = {}

---Set up the plugin with optional user configuration.
---
---@param opts? ApronConfig
function M.setup(opts)
	config.setup(opts)
end

return M
