local builtin = require('telescope.builtin')
local gs = { hidden = true, no_ignore = false }

require("which-key").register({
	f = { function() builtin.find_files(gs) end, "search files" },
	z = { function() builtin.live_grep(gs) end, "live grep" },
	s = {
		name = "Telescope",
		s = { function() builtin.grep_string(gs) end, "grep visual selection or word under cursor", mode = { "n", "v" } },
		m = { function() builtin.keymaps(gs) end, "keymaps" },
		g = { function() builtin.git_files(gs) end, "git files" },
		p = { "<cmd>Telescope persisted<cr>", "persisted: sessions" },
		b = { function() builtin.buffers(gs) end, "find buffers" },
		h = { function() builtin.help_tags(gs) end, "neovim documentation" },
		n = { function() builtin.find_files({ hidden = true, no_ignore_parent = true }) end, "no_ignore_parent" },
		t = { function()
			FindTodo()
			require('telescope.builtin').quickfix({ wrap_results = true, fname_width = 999 })
		end, "Project's TODOs" },
	},
}, { prefix = "<space>" })
K("n", "<C-f>", "<cmd>Telescope current_buffer_fuzzy_find sorting_strategy=ascending prompt_position=top<CR>",
	{ desc = "Ctrl+f remake" })


require('telescope').load_extension('media_files')
require("telescope").setup {
	extensions = {
		media_files = {
			filetypes = { "png", "webp", "jpg", "jpeg" },
			find_cmd = "rg"
		},
	},
}
--

-- Default mappings reference {{{
--<C-n>/<Down>	Next item
--<C-p>/<Up>	Previous item
--j/k	Next/previous (in normal mode)
--<cr>	Confirm selection
--<C-q>	Confirm selection and open quickfix window
--<C-x>	Go to file selection as a split
--<C-v>	Go to file selection as a vsplit
--<C-t>	Go to a file in a new tab
--<C-u>	Scroll up in preview window
--<C-d>	Scroll down in preview window
--<C-/>/?	Show picker mappings (in insert & normal mode, respectively)
--<C-c>	Close telescope
--<Esc>	Close telescope (in normal mode)
-- }}}
