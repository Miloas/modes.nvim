local M = {}

---@class Color
---@field fg string
---@field bg string
---@field sp string
---@field link string
---@field blend number between 0 and 100

---@class VimOptions
---@field cursor boolean
---@field cursorline boolean
---@field number boolean

---@class Config
---@field colors Color
---@field ignore_filetypes table<string>
---@field set_vim_options VimOptions
local defaults = {
	highlight_groups = {
		ModesCopy = { fg = '#f5c359', bg = '#f5c359', blend = 15 },
		ModesDelete = { fg = '#c75c6a', bg = '#c75c6a', blend = 15 },
		ModesInsert = { fg = '#78ccc5', bg = '#78ccc5', blend = 15 },
		ModesVisual = { fg = '#9745be', bg = '#9745be', blend = 15 },
	},

	ignore_filetypes = { 'NvimTree', 'TelescopePrompt' },

	---@deprecated Prefer set_vim_options.cursor = true|false
	set_cursor = true,
	---@deprecated Prefer set_vim_options.cursorline = true|false
	set_cursorline = true,
	---@deprecated Prefer set_vim_options.number = true|false
	set_number = true,

	set_vim_options = {
		cursor = true,
		cursorline = true,
		number = true,
	},
}

return defaults
