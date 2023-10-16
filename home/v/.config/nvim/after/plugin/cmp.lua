local cmp = require('cmp')
local cmp_format = require('lsp-zero').cmp_format()
--local cmp_select = { behavior = cmp.SelectBehavior.Select }
local cmp_action = require('lsp-zero').cmp_action()


vim.opt.completeopt = { "menu", "menuone", "noselect" }

cmp.setup({
	sources = cmp.config.sources({
		{ name = 'nvim_lsp' },
		{ name = 'luasnip' },
	}, {
		{ name = 'buffer' },
	}),
	-- Show source name in completion menu.
	formatting = cmp_format,
	snippet = {
		expand = function(args)
			require('luasnip').lsp_expand(args.body)
		end,
	},
	window = {
		completion = cmp.config.window.bordered(),
		documentation = cmp.config.window.bordered(),
	},
	mapping = cmp.mapping.preset.insert({
		['<Tab>'] = cmp_action.luasnip_supertab(),
		['<S-Tab>'] = cmp_action.luasnip_shift_supertab(),
		['<Esc>'] = cmp.mapping.abort(),                  -- if esc in insert mode is not instantenious, change this (my estimation is this thing takes about 40ms)
		['<CR>'] = cmp.mapping.confirm({ select = false }), -- `select = false` to only confirm explicitly selected items.

		['<C-t>'] = cmp.mapping(function()
			if cmp.visible() then
				cmp.scroll_docs(4)
			else
				vim.api.nvim_command('cprev')
				vim.api.nvim_command('normal zz')
			end
		end, {
			"i",
			"s",
		}),
		['<C-n>'] = cmp.mapping(function()
			if cmp.visible() then
				cmp.scroll_docs(-4)
			else
				vim.api.nvim_command('cprev')
				vim.api.nvim_command('normal zz')
			end
		end, {
			"i",
			"s",
		}),

	}),
})
cmp.setup.filetype('gitcommit', {
	sources = cmp.config.sources({
		{ name = 'git' }, -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
	}, {
		{ name = 'buffer' },
	})
})