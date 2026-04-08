local config = require("apron.config")

local M = {}

---Set up the plugin with optional user configuration.
---
---Example:
---  require("apron").setup({
---    option1 = "my_value",
---  })
---
---@param opts? ApronConfig
function M.setup(opts)
  config.setup(opts)
end

return M
