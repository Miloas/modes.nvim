local M = {}

-- TODO: Fix group linking

---@class Color
---@field fg string
---@field bg string
---@field sp string
---@field link string
---@field fg_blend number between 0 and 100
---@field bg_blend number between 0 and 100

---@class Highlights
---@field ModesCopy table<Color>
---@field ModesDelete table<Color>
---@field ModesInsert table<Color>
---@field ModesVisual table<Color>

---@class Config
---@field highlights Highlights
local defaults = {
	highlights = {
		ModesCopy = {
			fg = '#f5c359',
			bg = '#f5c359',
			fg_blend = 50,
			bg_blend = 10,
		},
		ModesDelete = {
			fg = '#c75c6a',
			bg = '#c75c6a',
			fg_blend = 50,
			bg_blend = 10,
		},
		ModesInsert = {
			fg = '#78ccc5',
			bg = '#78ccc5',
			fg_blend = 50,
			bg_blend = 10,
		},
		ModesVisual = {
			fg = '#9745be',
			bg = '#9745be',
			fg_blend = 50,
			bg_blend = 10,
		},
	},

	-- ignore_filetypes = { 'NvimTree', 'TelescopePrompt' },
}

return defaults
