vim.g.rustaceanvim = {
  server = {
    on_attach = function(_, bufnr)
      vim.keymap.set('n', '<leader>cR', function()
        vim.cmd.RustLsp('codeAction')
      end, { desc = 'Code Action', buffer = bufnr })

      vim.keymap.set('n', '<leader>dr', function()
        vim.cmd.RustLsp('debuggables')
      end, { desc = 'Rust Debuggables', buffer = bufnr })

      vim.keymap.set('n', 'K', function()
        vim.cmd.RustLsp({ 'hover', 'actions' })
      end, { desc = 'Rust Hover Actions', silent = true, buffer = bufnr })
    end,
    default_settings = {
      ['rust-analyzer'] = {
        cargo = {
          allFeatures = true,
          loadOutDirsFromCheck = true,
          buildScripts = {
            enable = true,
          },
        },
        checkOnSave = true,
        diagnostics = {
          enable = true,
        },
        procMacro = {
          enable = true,
        },
        files = {
          exclude = {
            '.direnv',
            '.git',
            '.jj',
            '.github',
            '.gitlab',
            'bin',
            'node_modules',
            'target',
            'venv',
            '.venv',
          },
          watcher = 'client',
        },
      },
    },
  },
}

if vim.fn.executable('rust-analyzer') == 0 then
  vim.notify('rust-analyzer not found in PATH, please install it.\nhttps://rust-analyzer.github.io/', vim.log.levels.ERROR, { title = 'rustaceanvim' })
end
