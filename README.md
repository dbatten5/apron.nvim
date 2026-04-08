# apron.nvim

A Neovim plugin written in Lua.

## Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  "dbatten5/apron.nvim",
  opts = {},
}
```

Using [packer.nvim](https://github.com/wbthomason/packer.nvim):

```lua
use {
  "dbatten5/apron.nvim",
  config = function()
    require("apron").setup()
  end,
}
```

## Configuration

Call `setup()` anywhere in your Neovim config to customise the plugin.  All
keys are optional – any key you omit will keep its default value.

```lua
require("apron").setup({
  option1 = "my_value",
})
```

### Defaults

```lua
{
  option1 = "default_value",
}
```

### Accessing config values at runtime

The current config can be read through the `apron.config` module:

```lua
local config = require("apron.config")

-- Retrieve a single value:
local value = config.get("option1")

-- Retrieve the full config table:
local all = config.get()
```
