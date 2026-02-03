-- require("rose-pine").setup({})
-- vim.cmd.colorscheme("rose-pine")
vim.cmd("colorscheme koda")

require("neo-tree").setup({
	event_handlers = {
		{
			event = "file_open_requested",
			handler = function()
				-- auto close
				-- vim.cmd("Neotree close")
				-- OR
				require("neo-tree.command").execute({ action = "close" })
			end,
		},
	},
	filesystem = {
		window = {
			mappings = {
				["\\"] = "close_window",
				["/"] = "noop",
				["<space>"] = "noop",
				["Y"] = function(state)
					local node = state.tree:get_node()
					local filepath = node:get_id()
					local filename = node.name
					local modify = vim.fn.fnamemodify

					local vals = {
						["FILENAME"] = filename,
						["PATH (CWD)"] = modify(filepath, ":."),
						["BASENAME"] = modify(filename, ":r"),
						["EXTENSION"] = modify(filename, ":e"),
						["PATH (HOME)"] = modify(filepath, ":~"),
						["PATH"] = filepath,
						["URI"] = vim.uri_from_fname(filepath),
					}

					local options = vim.tbl_filter(function(val)
						return vals[val] ~= ""
					end, vim.tbl_keys(vals))
					if vim.tbl_isempty(options) then
						vim.notify("No values to copy", vim.log.levels.WARN)
						return
					end
					table.sort(options)
					vim.ui.select(options, {
						prompt = "Choose to copy to clipboard:",
						format_item = function(item)
							return ("%s: %s"):format(item, vals[item])
						end,
					}, function(choice)
						local result = vals[choice]
						if result then
							vim.notify(("Copied: `%s`"):format(result))
							vim.fn.setreg("+", result)
						end
					end)
				end,
				["h"] = function(state)
					local node = state.tree:get_node()
					if node.type == "directory" and node:is_expanded() then
						require("neo-tree.sources.filesystem").toggle_directory(state, node)
					else
						require("neo-tree.ui.renderer").focus_node(state, node:get_parent_id())
					end
				end,
				["l"] = function(state)
					local node = state.tree:get_node()
					if node.type == "directory" then
						if not node:is_expanded() then
							require("neo-tree.sources.filesystem").toggle_directory(state, node)
						elseif node:has_children() then
							require("neo-tree.ui.renderer").focus_node(state, node:get_child_ids()[1])
						end
					end
				end,
				["g"] = function(state)
					local node = state.tree:get_node()
					local path = node:get_id()
					Snacks.picker.grep({ dirs = { path }, hidden = true, ignored = true })
				end,
			},
		},
	},
})

local function neotest_status()
	local ok, neotest = pcall(require, "neotest")
	if not ok or not neotest.state then
		return ""
	end

	local ok_config, config = pcall(require, "neotest.config")
	local icons = ok_config and config.icons
		or { running = "", failed = "", passed = "", skipped = "", test = "󰙨" }

	local adapters = neotest.state.adapter_ids()
	if not adapters or vim.tbl_isempty(adapters) then
		return ""
	end

	local summary = { failed = 0, running = 0, passed = 0, skipped = 0, total = 0 }
	local bufnr = vim.api.nvim_get_current_buf()
	for _, adapter_id in ipairs(adapters) do
		local counts = neotest.state.status_counts(adapter_id, { buffer = bufnr })
		if counts then
			for key, value in pairs(counts) do
				summary[key] = (summary[key] or 0) + value
			end
		end
	end

	if summary.total == 0 then
		return ""
	end

	local parts = {}
	if summary.running > 0 then
		table.insert(parts, icons.running .. " " .. summary.running)
	end
	if summary.failed > 0 then
		table.insert(parts, icons.failed .. " " .. summary.failed)
	end
	if summary.passed > 0 then
		table.insert(parts, icons.passed .. " " .. summary.passed)
	end
	if summary.skipped > 0 then
		table.insert(parts, icons.skipped .. " " .. summary.skipped)
	end
	if vim.tbl_isempty(parts) then
		return icons.test .. " " .. summary.total
	end

	return table.concat(parts, " ")
end

require("lualine").setup({
	options = {
		section_separators = "",
		component_separators = "",
		-- theme = "rose-pine",
		disabled_filetypes = { -- Filetypes to disable lualine for.
			statusline = { "neo-tree" }, -- only ignores the ft for statusline.
		},
	},
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "branch", "diff", "diagnostics" },
		lualine_c = {
			{
				"filename",
				file_status = true, -- Displays file status (readonly status, modified status)
				newfile_status = false, -- Display new file status (new file means no write after created)
				path = 1,

				shorting_target = 20, -- Shortens path to leave 40 spaces in the window
				-- for other components. (terrible name, any suggestions?)
				symbols = {
					modified = "[+]", -- Text to show when the file is modified.
					readonly = "[-]", -- Text to show when the file is non-modifiable or readonly.
					unnamed = "[No Name]", -- Text to show for unnamed buffers.
					newfile = "[New]", -- Text to show for newly created file before first write
				},
			},
		},
		lualine_x = { neotest_status, "encoding", "fileformat", "filetype" },
		lualine_y = { "progress" },
		lualine_z = { "location" },
	},
	winbar = {
		lualine_c = {
			{
				"filename",
				file_status = true, -- Displays file status (readonly status, modified status)
				newfile_status = false, -- Display new file status (new file means no write after created)
				path = 1,

				shorting_target = 20, -- Shortens path to leave 40 spaces in the window
				-- for other components. (terrible name, any suggestions?)
				symbols = {
					modified = "[+]", -- Text to show when the file is modified.
					readonly = "[-]", -- Text to show when the file is non-modifiable or readonly.
					unnamed = "[No Name]", -- Text to show for unnamed buffers.
					newfile = "[New]", -- Text to show for newly created file before first write
				},
			},
			{
				"navic",
				color_correction = nil,
				navic_opts = nil,
			},
		},
	},

	inactive_winbar = {
		lualine_c = {
			{
				"filename",
				file_status = true, -- Displays file status (readonly status, modified status)
				newfile_status = false, -- Display new file status (new file means no write after created)
				path = 1,
				shorting_target = 20, -- Shortens path to leave 40 spaces in the window
				-- for other components. (terrible name, any suggestions?)
				symbols = {
					modified = "[+]", -- Text to show when the file is modified.
					readonly = "[-]", -- Text to show when the file is non-modifiable or readonly.
					unnamed = "[No Name]", -- Text to show for unnamed buffers.
					newfile = "[New]", -- Text to show for newly created file before first write
				},
			},
			{
				"navic",
				color_correction = nil,
				navic_opts = nil,
			},
		},
	},
})

require("which-key").setup({
	preset = "helix",
	-- delay between pressing a key and opening which-key (milliseconds)
	-- this setting is independent of vim.opt.timeoutlen
	delay = 250,
	icons = {
		-- set icon mappings to true if you have a Nerd Font
		mappings = true,
		-- If you are using a Nerd Font: set icons.keys to an empty table which will use the
		-- default which-key.nvim defined Nerd Font icons, otherwise define a string table
	},

	-- Document existing key chains
	spec = {
		{ "<leader>s", group = "[S]earch" },
		{ "<leader>b", group = "[B]uffers" },
		{ "<leader>f", group = "[F]ind" },
		{ "<leader>s", group = "[S]earch" },
		{ "<leader>u", group = "[U]I" },
		{ "<leader>c", group = "[C]ode" },
		{ "<leader>gh", group = "Git [H]unk", mode = { "n", "v" } },
	},
})

require("fidget").setup()

require("todo-comments").setup({
	signs = true,
})

require("window-picker").setup({
	hint = "floating-big-letter",
	show_prompt = true,
	filter_rules = {
		include_current_win = true,
	},
})

require("statuscol").setup()
require("noice").setup({
	cmdline = {
		format = {
			cmdline = { lang = "" },
			search_down = { lang = "" },
			search_up = { lang = "" },
			filter = { lang = "" },
			lua = { lang = "" },
		},
	},
})
