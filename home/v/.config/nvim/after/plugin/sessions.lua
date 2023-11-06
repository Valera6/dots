-- "<space>sp" to search for session with Telescope
require("persisted").setup({
	save_dir = vim.fn.expand(vim.fn.stdpath("data") .. "/sessions/"),
	silent = true,
	autosave = false,
	autoload = false,
	follow_cwd = true,
	allowed_dirs = nil,
	ignored_dirs = { "tmp", "s", ".config" },
	telescope = {
		reset_prompt_after_deletion = true,
	},
})

require("which-key").register({
	name = "Session",
	l = { "<cmd>SessionLoad<cr>", "Load" },
	s = { "<cmd>SessionSave<cr>", "Save" },
}, { prefix = "<space>se" })
