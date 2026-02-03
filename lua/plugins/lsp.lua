require("mason").setup({})
require("mason-lspconfig").setup({
	ensure_installed = {
		"lua_ls",
		"rust_analyzer",
		"copilot",
		"ty",
		"docker_compose_language_service",
		"docker_language_server",
	},
})
require("lazydev").setup({
	library = {
		-- See the configuration section for more details
		-- Load luvit types when the `vim.uv` word is found
		{ path = "${3rd}/luv/library", words = { "vim%.uv" } },
	},
})

require("blink-copilot").setup({
	debounce = 50,
	max_completions = 2,
})

require("blink.cmp").setup({
	fuzzy = { implementation = "prefer_rust_with_warning" },
	signature = { enabled = true },
	keymap = {
		preset = "default",
	},

	appearance = {
		-- use_nvim_cmp_as_default = true,
		nerd_font_variant = "normal",
	},

	completion = {
		ghost_text = {
			enabled = true,
		},
		documentation = {
			auto_show = true,
			auto_show_delay_ms = 200,
		},
	},

	sources = {
		default = { "lazydev", "lsp", "path", "snippets", "buffer", "copilot" },
		providers = {
			lazydev = { module = "lazydev.integrations.blink", score_offset = 100, name = "LazyDev" },
			copilot = {
				name = "copilot",
				module = "blink-copilot",
				score_offset = 100,
				async = true,
			},
		},
	},
})

require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		python = { "ruff_fix", "ruff_format" },
	},
})

vim.diagnostic.config({
	update_in_insert = false,
	severity_sort = true,
	float = { border = "rounded", source = "if_many" },
	virtual_text = true, -- Text shows up at the end of the line
	virtual_lines = false, -- Teest shows up underneath the line, with virtual lines
	underline = { severity = vim.diagnostic.severity.ERROR },
	jump = { float = true },
})
