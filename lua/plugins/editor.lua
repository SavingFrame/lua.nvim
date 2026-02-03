require("persistence").setup({
	dir = vim.fn.stdpath("state") .. "/sessions/",
})

require("mini.surround").setup({

	mappings = {
		add = "gsa", -- Add surrounding in Normal and Visual modes
		delete = "gsd", -- Delete surrounding
		find = "gsf", -- Find surrounding (to the right)
		find_left = "gsF", -- Find surrounding (to the left)
		highlight = "gsh", -- Highlight surrounding
		replace = "gsr", -- Replace surrounding
		update_n_lines = "gsn", -- Update `n_lines`
	},
})

require("nvim-autopairs").setup()

-- git signs
require("gitsigns").setup({
	on_attach = function(bufnr)
		local gitsigns = require("gitsigns")

		local function map(mode, l, r, opts)
			opts = opts or {}
			opts.buffer = bufnr
			vim.keymap.set(mode, l, r, opts)
		end

		-- Navigation
		map("n", "]h", function()
			if vim.wo.diff then
				vim.cmd.normal({ "]h", bang = true })
			else
				gitsigns.nav_hunk("next")
			end
		end, { desc = "Jump to next git [c]hange" })

		map("n", "[h", function()
			if vim.wo.diff then
				vim.cmd.normal({ "[h", bang = true })
			else
				gitsigns.nav_hunk("prev")
			end
		end, { desc = "Jump to previous git [c]hange" })

		-- Actions
		-- visual mode
		map("v", "<leader>ghs", function()
			gitsigns.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, { desc = "git [s]tage hunk" })
		map("v", "<leader>ghr", function()
			gitsigns.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
		end, { desc = "git [r]eset hunk" })
		-- normal mode
		map("n", "<leader>ghr", gitsigns.reset_hunk, { desc = "git [r]eset hunk" })
		map("n", "<leader>ghu", gitsigns.stage_hunk, { desc = "git [u]ndo stage hunk" })
		map("n", "<leader>gR", gitsigns.reset_buffer, { desc = "git [R]eset buffer" })
		map("n", "<leader>ghp", gitsigns.preview_hunk, { desc = "git [p]review hunk" })
		-- Toggles
	end,
})

-- folds
--
local function customizeSelector(bufnr)
	local function handleFallbackException(err, providerName)
		if type(err) == "string" and err:match("UfoFallbackException") then
			return require("ufo").getFolds(bufnr, providerName)
		else
			return require("promise").reject(err)
		end
	end

	return require("ufo")
		.getFolds(bufnr, "lsp")
		:catch(function(err)
			return handleFallbackException(err, "treesitter")
		end)
		:catch(function(err)
			return handleFallbackException(err, "indent")
		end)
end

local ft_providers = {
	vim = "indent",
	python = { "treesitter" },
	git = "",
	help = "",
	qf = "",
	fugitive = "",
	fugitiveblame = "",
	["neo-tree"] = "",
}

vim.o.foldcolumn = "1" -- '0' is not bad
vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
vim.o.foldlevelstart = 99
vim.o.foldenable = true
vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]

require("ufo").setup({

	close_fold_kinds_for_ft = {
		default = { "imports", "comment" },
		json = { "array" },
		python = { "imports", "comment" },
	},
	preview = {
		win_config = {
			border = { "", "─", "", "", "", "─", "", "" },
			winhighlight = "Normal:Folded",
			winblend = 10,
		},
		mappings = {
			scrollU = "<C-u>",
			scrollD = "<C-d>",
			jumpTop = "[",
			jumpBot = "]",
		},
	},

	-- Select the fold provider.
	provider_selector = function(_, filetype, _)
		return ft_providers[filetype] or customizeSelector
	end,

	-- Display text for folded lines.
	---@param virtText table
	---@param lnum integer
	---@param endLnum integer
	---@param width integer
	---@param truncate function
	---@return table
	fold_virt_text_handler = function(virtText, lnum, endLnum, width, truncate)
		local newVirtText = {}
		local suffix = (" 󰁂 %d "):format(endLnum - lnum)
		local sufWidth = vim.fn.strdisplaywidth(suffix)
		local targetWidth = width - sufWidth
		local curWidth = 0

		for _, chunk in ipairs(virtText) do
			local chunkText = chunk[1]
			local chunkWidth = vim.fn.strdisplaywidth(chunkText)
			if targetWidth > curWidth + chunkWidth then
				table.insert(newVirtText, chunk)
			else
				chunkText = truncate(chunkText, targetWidth - curWidth)
				local hlGroup = chunk[2]
				table.insert(newVirtText, { chunkText, hlGroup })
				chunkWidth = vim.fn.strdisplaywidth(chunkText)
				-- str width returned from truncate() may less than 2nd argument, need padding
				if curWidth + chunkWidth < targetWidth then
					suffix = suffix .. (" "):rep(targetWidth - curWidth - chunkWidth)
				end
				break
			end
			curWidth = curWidth + chunkWidth
		end
		table.insert(newVirtText, { suffix, "MoreMsg" })
		return newVirtText
	end,
})

require("trouble").setup()
require("guess-indent").setup()
