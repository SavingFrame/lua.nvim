return {
  {
    'neovim/nvim-lspconfig',
    opts = {
      capabilities = {
        textDocument = {
          foldingRange = {
            dynamicRegistration = false,
            lineFoldingOnly = true,
          },
        },
      },
    },
  },
  {
    'kevinhwang91/nvim-ufo',
    dependencies = {
      'kevinhwang91/promise-async',
      'nvim-treesitter/nvim-treesitter',
      'neovim/nvim-lspconfig',
      'luukvbaal/statuscol.nvim',
    },
    event = 'BufRead',
    keys = {
      {
        'zR',
        function()
          require('ufo').openAllFolds()
        end,
        desc = 'Open all folds',
      },
      {
        'zM',
        function()
          require('ufo').closeAllFolds()
        end,
        desc = 'Close all folds',
      },
      {
        'zZ',
        function()
          require('ufo').peekFoldedLinesUnderCursor()
        end,
        desc = 'Peek folded lines under cursor',
      },
    },
    opts = function()
      -- lsp->treesitter->indent
      ---@param bufnr number
      ---@return table
      local function customizeSelector(bufnr)
        local function handleFallbackException(err, providerName)
          if type(err) == 'string' and err:match 'UfoFallbackException' then
            return require('ufo').getFolds(bufnr, providerName)
          else
            return require('promise').reject(err)
          end
        end

        return require('ufo')
          .getFolds(bufnr, 'lsp')
          :catch(function(err)
            return handleFallbackException(err, 'treesitter')
          end)
          :catch(function(err)
            return handleFallbackException(err, 'indent')
          end)
      end

      local ft_providers = {
        vim = 'indent',
        python = { 'treesitter' },
        git = '',
        help = '',
        qf = '',
        fugitive = '',
        fugitiveblame = '',
        ['neo-tree'] = '',
      }

      vim.o.foldcolumn = '1' -- '0' is not bad
      vim.o.foldlevel = 99 -- Using ufo provider need a large value, feel free to decrease the value
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true
      vim.o.fillchars = [[eob: ,fold: ,foldopen:,foldsep: ,foldclose:]]
      return {

        close_fold_kinds_for_ft = {
          default = { 'imports', 'comment' },
          json = { 'array' },
          python = { 'imports', 'comment' },
        },
        preview = {
          win_config = {
            border = { '', '─', '', '', '', '─', '', '' },
            winhighlight = 'Normal:Folded',
            winblend = 10,
          },
          mappings = {
            scrollU = '<C-u>',
            scrollD = '<C-d>',
            jumpTop = '[',
            jumpBot = ']',
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
          local suffix = (' 󰁂 %d '):format(endLnum - lnum)
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
                suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
              end
              break
            end
            curWidth = curWidth + chunkWidth
          end
          table.insert(newVirtText, { suffix, 'MoreMsg' })
          return newVirtText
        end,
      }
    end,
  },
}
