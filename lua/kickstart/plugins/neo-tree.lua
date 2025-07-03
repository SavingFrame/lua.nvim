-- Neo-tree is a Neovim plugin to browse the file system
-- https://github.com/nvim-neo-tree/neo-tree.nvim

return {
  'nvim-neo-tree/neo-tree.nvim',
  version = '*',
  dependencies = {
    'nvim-lua/plenary.nvim',
    'nvim-tree/nvim-web-devicons', -- not strictly required, but recommended
    'MunifTanjim/nui.nvim',
  },
  lazy = false,
  keys = {
    { '<leader>e', ':Neotree toggle reveal=true<CR>', desc = 'NeoTree reveal', silent = true },
    {
      '<leader>fV',
      function()
        local site_packages_path = require('utils.path').get_venv_site_packages_path()
        if site_packages_path then
          require('neo-tree.command').execute {
            toggle = true,
            dir = site_packages_path,
            filters = {
              hide_dotfiles = false, -- Ensure dotfiles are shown
              hide_gitignored = false,
              hide_by_pattern = { '__pycache__/', '%.so', '%.dist-info/', '*.egg-info/', '*.pyc', '*dist-info/' },
            },
          }
        end
      end,
      desc = 'Explorer NeoTree (Libraries)',
    },
  },
  opts = {
    event_handlers = {

      {
        event = 'file_open_requested',
        handler = function()
          -- auto close
          -- vim.cmd("Neotree close")
          -- OR
          require('neo-tree.command').execute { action = 'close' }
        end,
      },
    },
    filesystem = {
      window = {
        mappings = {
          ['\\'] = 'close_window',
          ['/'] = 'noop',
          ['<space>'] = 'noop',
          ['Y'] = function(state)
            local node = state.tree:get_node()
            local filepath = node:get_id()
            local filename = node.name
            local modify = vim.fn.fnamemodify

            local vals = {
              ['FILENAME'] = filename,
              ['PATH (CWD)'] = modify(filepath, ':.'),
              ['BASENAME'] = modify(filename, ':r'),
              ['EXTENSION'] = modify(filename, ':e'),
              ['PATH (HOME)'] = modify(filepath, ':~'),
              ['PATH'] = filepath,
              ['URI'] = vim.uri_from_fname(filepath),
            }

            local options = vim.tbl_filter(function(val)
              return vals[val] ~= ''
            end, vim.tbl_keys(vals))
            if vim.tbl_isempty(options) then
              vim.notify('No values to copy', vim.log.levels.WARN)
              return
            end
            table.sort(options)
            vim.ui.select(options, {
              prompt = 'Choose to copy to clipboard:',
              format_item = function(item)
                return ('%s: %s'):format(item, vals[item])
              end,
            }, function(choice)
              local result = vals[choice]
              if result then
                vim.notify(('Copied: `%s`'):format(result))
                vim.fn.setreg('+', result)
              end
            end)
          end,
          ['h'] = function(state)
            local node = state.tree:get_node()
            if node.type == 'directory' and node:is_expanded() then
              require('neo-tree.sources.filesystem').toggle_directory(state, node)
            else
              require('neo-tree.ui.renderer').focus_node(state, node:get_parent_id())
            end
          end,
          ['l'] = function(state)
            local node = state.tree:get_node()
            if node.type == 'directory' then
              if not node:is_expanded() then
                require('neo-tree.sources.filesystem').toggle_directory(state, node)
              elseif node:has_children() then
                require('neo-tree.ui.renderer').focus_node(state, node:get_child_ids()[1])
              end
            end
          end,
          ['g'] = function(state)
            local node = state.tree:get_node()
            local path = node:get_id()
            Snacks.picker.grep { dirs = { path } }
          end,
        },
      },
    },
  },
}
