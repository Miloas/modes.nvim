local util = {}

local function byte(value, offset)
	return bit.band(bit.rshift(value, offset), 0xFF)
end

---@param color string
---@return string[]
local function to_rgb(color)
	local result = vim.api.nvim_get_color_by_name(color)

	if result == -1 then
		result = vim.opt.background:get() == 'dark' and 000 or 255255255
	end

	return { byte(result, 16), byte(result, 8), byte(result, 0) }
end

---@param fg string
---@param bg string
---@param alpha number
---@return string
util.blend = function(fg, bg, alpha)
	local fg_rgb = to_rgb(fg)
	local bg_rgb = to_rgb(bg)
	alpha = alpha > 1 and alpha / 100 or alpha

	local function blend_channel(i)
		local ret = (alpha * fg_rgb[i] + ((1 - alpha) * bg_rgb[i]))
		return math.floor(math.min(math.max(0, ret), 255) + 0.5)
	end

	return string.format(
		'#%02X%02X%02X',
		blend_channel(1),
		blend_channel(2),
		blend_channel(3)
	)
end

---@param group string
---@param color Color
util.highlight = function(group, color)
	local fg = color.fg or ''
	local bg = color.bg or ''
	local sp = color.sp or ''

	local normal_bg = util.get_hl_by_name('Normal').bg

	if color.fg_blend ~= nil and color.fg ~= nil then
		fg = util.blend(color.fg, normal_bg, color.fg_blend)
	end

	if color.bg_blend ~= nil and color.bg ~= nil then
		bg = util.blend(color.bg, normal_bg, color.bg_blend)
	end

	vim.api.nvim_set_hl(0, group, { fg = fg, bg = bg, sp = sp })
end

---@param group string
---@param fallback Color|nil
---@return Color
util.get_hl_by_name = function(group, fallback)
	local id = vim.api.nvim_get_hl_id_by_name(group)
	if not id then
		return fallback or { fg = '', bg = '' }
	end

	local fg = vim.fn.synIDattr(id, 'fg') or ''
	local bg = vim.fn.synIDattr(id, 'bg') or ''
	local fg_blend = nil
	local bg_blend = nil

	-- Normlise modes colours
	if
		bg ~= ''
		and fg == ''
		and (
			group == 'ModesCopy'
			or group == 'ModesDelete'
			or group == 'ModesInsert'
			or group == 'ModesVisual'		-- or group == 'Visual'

		)
	then
		fg = bg
		fg_blend = 50
		bg_blend = 15
	end

	return { fg = fg, bg = bg, fg_blend = fg_blend, bg_blend = bg_blend }
end

---Replace terminal keycodes
---@param key string like '<esc>'
---@return string
util.replace_termcodes = function(key)
	return vim.api.nvim_replace_termcodes(key, true, true, true)
end

return util
