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

---@param color Color
util.blend = function(color)
	local fg = to_rgb(color.fg)
	local bg = to_rgb(color.bg)
	local alpha = color.blend > 1 and color.blend / 100 or color.blend

	local function blend_channel(i)
		local ret = (alpha * fg[i] + ((1 - alpha) * bg[i]))
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
	local fg = color.fg
	local bg = color.bg

	if color.blend ~= nil and color.bg ~= nil then
		bg = util.blend({
			fg = color.bg,
			bg = util.get_hl_by_name('Normal').bg,
			blend = color.blend,
		})
	end

	vim.api.nvim_set_hl(0, group, { fg = fg, bg = bg })
end

---@param name string
---@return Color
util.get_hl_by_name = function(name)
	local id = vim.api.nvim_get_hl_id_by_name(name)
	if not id then
		print('Unable to find to highlight group: ' .. name)
		return { fg = '', bg = '' }
	end

	local foreground = vim.fn.synIDattr(id, 'fg') or ''
	local background = vim.fn.synIDattr(id, 'bg') or ''

	return { fg = foreground, bg = background }
end

---Replace terminal keycodes
---@param key string like '<esc>'
---@return string
util.replace_termcodes = function(key)
	return vim.api.nvim_replace_termcodes(key, true, true, true)
end

return util
