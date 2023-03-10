# modes.nvim

> Prismatic line decorations for the adventurous vim user

**Note: This is an experimental branch. Many features are missing from the main branch. Not recommended for personal use.**

![modes.nvim](https://user-images.githubusercontent.com/1474821/127896095-6da221cf-3327-4eed-82be-ce419bdf647c.gif)

## Install

Use your favourite package manager. No setup required.

```lua
{
	'mvllow/modes.nvim',
	branch = "rancid-snake-oil"
}
```

## Usage

```lua
require('modes').setup({
	colors = {
		copy = "#f5c359",
		delete = "#c75c6a",
		insert = "#78ccc5",
		visual = "#9745be",
	},

	-- Disable modes highlights for specific filetypes
	ignore_filetypes = { 'NvimTree', 'TelescopePrompt' }
})
```

## Themes

| Highlight group | Default value   |
| --------------- | --------------- |
| `ModesCopy`     | `guibg=#f5c359` |
| `ModesDelete`   | `guibg=#c75c6a` |
| `ModesInsert`   | `guibg=#78ccc5` |
| `ModesVisual`   | `guibg=#9745be` |

## Known issues

- Some _Which Key_ presets conflict with this plugin. For example, `d` and `y` operators will not apply highlights if `operators = true` because _Which Key_ takes priority

_Workaround:_

```lua
require('which-key').setup({
	plugins = {
		presets = {
			operators = false,
		},
	},
})
```
