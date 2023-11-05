local api = require('Comment.api')
local config = {
	padding = false,
	sticky = true,
	ignore = nil,
	toggler = { line = 'gcc', block = 'gbc' }, -- can't turn it off. So just a note to follow the good practice of doing 'Vgc' and 'Vgb' instead.
	opleader = { line = 'gc', block = 'gb' },
	extra = { above = 'gcO', below = 'gco', eol = 'gcA' },
	mappings = { basic = true, extra = false }, -- reimplementing `extra` myself, to have padding on these and not on others
	pre_hook = nil,
	post_hook = nil,
}
require('Comment').setup(config)
--# Linewise
--
--`gcw` - Toggle from the current cursor position to the next word
--`gc$` - Toggle from the current cursor position to the end of line
--`gc}` - Toggle until the next blank line
--`gc5j` - Toggle 5 lines after the current cursor position
--`gc8k` - Toggle 8 lines before the current cursor position
--`gcip` - Toggle inside of paragraph
--`gca}` - Toggle around curly brackets
--
--# Blockwise
--
--`gb2}` - Toggle until the 2 next blank line
--`gbaf` - Toggle comment around a function (w/ LSP/treesitter support)
--`gbac` - Toggle comment around a class (w/ LSP/treesitter support)

-- -- `extra` reimplementation
local function commentExtraReimplementation(insert_leader)
	return function()
		F(insert_leader)
		F(Cs() .. ' ')
	end
end

K('n', 'gcO', commentExtraReimplementation('O'), { desc = "comment: reimplement `gcO`" })
K('n', 'gco', commentExtraReimplementation('o'), { desc = "comment: reimplement `gco`" })
K('n', 'gcA', commentExtraReimplementation('A '), { desc = "comment: reimplement `gcA`" })
--

-- -- Code Section comment
function OutlineCodeSection()
	local cs = Cs()
	F('o' .. cs)
	Ft('<Esc>`<')
	F('O' .. cs .. ' ' .. cs .. ' ')
end

K("v", "gsc", "<esc>`><cmd>lua OutlineCodeSection()<cr>", { desc = "outline semantic code section" }) -- s for surround
--


-- -- Draw a line thingie
function DrawABigBeautifulLine(symbol)
	local cs = Cs()
	local prefix = (#cs == 1 and cs .. symbol or cs)
	local line = string.rep(symbol, 77)
	F(prefix .. line)
	Ft('<Esc>0')
end

K('n', 'gc-i', "i<cmd>lua DrawABigBeautifulLine('-')<cr>", { desc = "comment: draw a '-' line here" })
K('n', 'gc=i', "i<cmd>lua DrawABigBeautifulLine('=')<cr>", { desc = "comment: draw a '=' line here" })
K('n', 'gc-o', "o<cmd>lua DrawABigBeautifulLine('-')<cr>", { desc = "comment: draw a '-' line below" })
K('n', 'gc-O', "O<cmd>lua DrawABigBeautifulLine('-')<cr>", { desc = "comment: draw a '-' line above" })
K('n', 'gc=o', "o<cmd>lua DrawABigBeautifulLine('=')<cr>", { desc = "comment: draw a '=' line below" })
K('n', 'gc=O', "O<cmd>lua DrawABigBeautifulLine('=')<cr>", { desc = "comment: draw a '=' line above" })
--


-- -- Remove end of line comment
local function removeEndOfLineComment()
	local save_cursor = vim.api.nvim_win_get_cursor(0)
	Ft("$?" .. " " .. Cs() .. "<cr>")
	Ft("vg_d")
	vim.defer_fn(function() vim.cmd([[s/\s\+$//e]]) end, 1)
	vim.defer_fn(function() vim.api.nvim_win_set_cursor(0, save_cursor) end, 2)
	vim.defer_fn(function() vim.cmd.noh() end, 3)
end
-- Note that if no `<space>{comment_string}` found on the current line, it will go searching through the rest of the file with `?`
K('n', 'gcr', function() removeEndOfLineComment() end, { desc = "comment: remove end-of-line comment" })
--

-- -- `//dbg` Commments
local function debugComment(action)
	local cs = Cs()
	if action == 'add' then
		PersistCursor(Ft, 'A ' .. cs .. 'dbg' .. '<esc>')
	elseif action == 'remove' then
		vim.cmd("g/" .. " " .. cs .. "dbg$/d")
		vim.cmd.noh()
	end
end
K('n', 'gcda', function() debugComment('add') end, { desc = "comment: add dbg comment" })
K('n', 'gcdr', function() debugComment('remove') end, { desc = "comment: remove all debug lines" })
--


-- -- `TODO{!*n}` Comments
function AddTodoComment(n)
	F('O' .. Cs() .. 'TODO' .. string.rep('!', n) .. ': ')
end

K("n", "!", [[v:count == 0 ? '!' : ':lua AddTodoComment(' . v:count . ')<cr>']],
	{ noremap = true, expr = true, silent = true })
K('n', '<space>1', '<cmd>lua AddTodoComment(0)<cr>')

local function escape(buffer)
	return string.gsub(buffer, "[%(%)%.%%%+%-%*%?%[%^%$%]]", "%%%1")
end

local function split(s, delimiter)
	local result = {};
	for match in (s .. escape(delimiter)):gmatch("(.-)" .. delimiter) do
		table.insert(result, match);
	end
	return result;
end

function FindTodo()
	local regex = vim.fn.shellescape(Cs() .. "TODO")
	local results = vim.fn.systemlist(
		"rg -rn -- " .. regex
		.. " | awk -F: -v OFS=: '{print gsub(/!/, \"&\"), $0}'"
		.. " | sort -rn")
	if vim.v.shell_error > 0 then
		print("No TODOs found")
		return
	end
	local qflist = vim.fn.map(results, function(_, x)
		local parts = split(x, ":")
		return {
			filename = parts[2],
			lnum = parts[3],
			text = table.concat(parts, ":", 4)
		}
	end)
	vim.fn.setqflist(qflist)
end

K('n', 'gct', function()
	FindTodo()
	vim.cmd.copen()
end, { desc = "comment: find and sort project's TODOs" })

--
