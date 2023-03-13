local util = require('modes.util')
local default_config = require('modes.config')

local M = {}

M.options = {}
M.default_highlights = {}

local palette = {}
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

	vim.api.nvim_create_autocmd('InsertEnter', {
		pattern = '*',
		callback = function()
			util.highlight('CursorLine', {
				fg = M.default_highlights.CursorLine.fg,
				bg = util.get_hl_by_name(
					'ModesInsert',
					M.options.highlights.ModesInsert
				).bg,
			})
		end,
	})

	vim.api.nvim_create_autocmd('ModeChanged', {
		pattern = '[vV\x16]:n',
		callback = M.reset_highlights,
	})

	vim.api.nvim_create_autocmd(
		{ 'CmdlineLeave', 'InsertLeave', 'TextYankPost', 'WinLeave' },
		{
			pattern = '*',
			callback = M.reset_highlights,
		}
	)
end

M.reset_highlights = function()
	util.highlight('CursorLine', M.default_highlights.CursorLine)
	operator_started = false
end

-- TODO: Update config priority
-- current: theme -> default config
-- desired: user config -> theme -> default config
M.define_highlight_groups = function()
	palette = {
		copy = util.get_hl_by_name('ModesCopy', M.options.highlights.ModesCopy),
		delete = util.get_hl_by_name(
			'ModesDelete',
			M.options.highlights.ModesDelete
		),
		insert = util.get_hl_by_name(
			'ModesInsert',
			M.options.highlights.ModesInsert
		),
		visual = util.get_hl_by_name(
			'ModesVisual',
			M.options.highlights.ModesVisual
		),
	}

	util.highlight('ModesCopy', palette.copy)
	util.highlight('ModesCopyCursor', {
		bg = util.get_hl_by_name('ModesCopy', M.options.highlights.ModesCopy).fg,
	})
	util.highlight('ModesDelete', palette.delete)
	util.highlight('ModesDeleteCursor', {
		bg = util.get_hl_by_name(
			'ModesDelete',
			M.options.highlights.ModesDelete
		).fg,
	})
	util.highlight('ModesInsert', palette.insert)
	util.highlight('ModesInsertCursor', {
		bg = util.get_hl_by_name(
			'ModesInsert',
			M.options.highlights.ModesInsert
		).fg,
	})
	util.highlight('ModesOperator', {})
	util.highlight('ModesOperatorCursor', {})
	util.highlight('ModesVisual', palette.visual)
	util.highlight('ModesVisualCursor', {
		bg = util.get_hl_by_name(
			'ModesVisual',
			M.options.highlights.ModesVisual
		).fg,
	})
	util.highlight('Visual', {
		fg = palette.visual.fg,
		bg = util.get_hl_by_name(
			'ModesVisual',
			M.options.highlights.ModesVisual
		).bg,
	})

	M.default_highlights = {
		CursorLine = util.get_hl_by_name('CursorLine'),
		Visual = util.get_hl_by_name('Visual'),
	}
end

M.apply_highlights = function()
	-- Block cursor shape
	-- TODO: Respect custom cursor shapes
	if vim.api.nvim_get_option('guicursor') == '' then
		vim.opt.guicursor:append('v-sm:block-ModesVisualCursor')
		vim.opt.guicursor:append('i-ci-ve:block-ModesInsertCursor')
		vim.opt.guicursor:append('r-cr-o:block-ModesOperatorCursor')
	else
		-- Default cursor shapes
		vim.opt.guicursor:append('v-sm:block-ModesVisualCursor')
		vim.opt.guicursor:append('i-ci-ve:ver25-ModesInsertCursor')
		vim.opt.guicursor:append('r-cr-o:hor20-ModesOperatorCursor')
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
				util.highlight('CursorLine', {
					fg = palette.copy.fg,
					bg = util.get_hl_by_name(
						'ModesCopy',
						M.options.highlights.ModesCopy
					).bg,
				})
				util.highlight('ModesOperatorCursor', {
					bg = util.get_hl_by_name(
						'ModesCopy',
						M.options.highlights.ModesCopy
					).fg,
				})
				operator_started = true
				return
			end

			if key == 'd' then
				util.highlight('CursorLine', {
					fg = palette.delete.fg,
					bg = util.get_hl_by_name(
						'ModesDelete',
						M.options.highlights.ModesDelete
					).bg,
				})
				util.highlight('ModesOperatorCursor', {
					bg = util.get_hl_by_name(
						'ModesDelete',
						M.options.highlights.ModesDelete
					).fg,
				})
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
