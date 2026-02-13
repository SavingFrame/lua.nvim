require('snacks').setup({
  indent = {
    enabled = true,
    chunk = {
      enabled = true,
    },
  },
  lazygit = {
    enabled = true,
  },
  input = { enabled = true },
  picker = {
    formatters = {
      file = {
        truncate = 120,
      },
    },
    previewers = {
      git = {
        native = true,
      },
    },
  },
  notifier = {
    enabled = false,
  },
  quickfile = { enabled = true },
  scope = { enabled = true },
  statuscolumn = { enabled = true },
  words = { enabled = true },
})
