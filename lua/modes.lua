local util = require('modes.util')
local default_config = require('modes.config')

local M = {}

M.options = {}
M.default_highlights = {}

local operator_started = false

---@param options Config|nil
M.setup = function(options)
	M.options = vim.tbl_deep_extend('force', {}, default_config, options or {})

	M.define_highlight_groups()
	M.apply_highlights()

	-- Refresh default highlight groups when colorscheme is changed
	vim.api.nvim_create_autocmd('ColorScheme', {
		pattern = '*',
		callback = M.define_highlight_groups,
	})
end

M.reset_highlights = function()
	util.highlight('CursorLine', M.default_highlights.CursorLine)
	operator_started = false
end

-- TODO: Use theme definitions if available
M.define_highlight_groups = function()
	util.highlight('ModesCopy', M.options.highlight_groups.ModesCopy)
	util.highlight('ModesDelete', M.options.highlight_groups.ModesDelete)
	util.highlight('ModesInsert', M.options.highlight_groups.ModesInsert)
	util.highlight('ModesVisual', M.options.highlight_groups.ModesVisual)
	util.highlight('Visual', M.options.highlight_groups.ModesVisual)

	M.default_highlights = {
		CursorLine = util.get_hl_by_name('CursorLine'),
		Visual = util.get_hl_by_name('Visual'),
	}
end

M.apply_highlights = function()
	-- Block cursor shape
	-- TODO: Respect custom cursor shapes
	if vim.api.nvim_get_option('guicursor') == '' then
		vim.opt.guicursor:append('v-sm:block-ModesVisual')
		vim.opt.guicursor:append('i-ci-ve:block-ModesInsert')
		vim.opt.guicursor:append('r-cr-o:block-ModesOperator')
	else
		-- Default cursor shapes
		vim.opt.guicursor:append('v-sm:block-ModesVisual')
		vim.opt.guicursor:append('i-ci-ve:ver25-ModesInsert')
		vim.opt.guicursor:append('r-cr-o:hor20-ModesOperator')
	end

	vim.on_key(function(key)
		local ok, current_mode = pcall(vim.fn.mode)
		if not ok then
			M.reset_highlights()
			return
		end

		if current_mode == 'n' then
			-- Reset if coming back from operator pending mode
			if operator_started then
				M.reset_highlights()
				return
			end

			if key == 'y' then
				util.highlight(
					'CursorLine',
					M.options.highlight_groups.ModesCopy
				)
				util.highlight(
					'ModesOperator',
					{ bg = M.options.highlight_groups.ModesCopy.fg }
				)
				operator_started = true
				return
			end

			if key == 'd' then
				util.highlight(
					'CursorLine',
					M.options.highlight_groups.ModesDelete
				)
				util.highlight(
					'ModesOperator',
					{ bg = M.options.highlight_groups.ModesDelete.fg }
				)
				operator_started = true
				return
			end
		end

		if key == util.replace_termcodes('<esc>') then
			M.reset_highlights()
			return
		end
	end)
end

return M
