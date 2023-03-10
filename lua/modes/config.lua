local M = {}

---@class Color
---@field fg string
---@field bg string
---@field sp string
---@field link string
---@field blend number between 0 and 100

---@class Config
---@field highlight_groups table<Color>
local defaults = {
	highlight_groups = {
		ModesCopy = { fg = '#f5c359', bg = '#f5c359', blend = 15 },
		ModesDelete = { fg = '#c75c6a', bg = '#c75c6a', blend = 15 },
		ModesInsert = { fg = '#78ccc5', bg = '#78ccc5', blend = 15 },
		ModesVisual = { fg = '#9745be', bg = '#9745be', blend = 15 },
	},

	-- ignore_filetypes = { 'NvimTree', 'TelescopePrompt' },
}

return defaults
