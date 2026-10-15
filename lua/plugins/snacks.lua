require('snacks').setup({
  indent = {
    enabled = true,
    chunk = {
      enabled = true,
    },
  },
  lazygit = {
    enabled = true,
    config = {
      os = {
        edit = [[nvim --server "$NVIM" --remote-send "q"; nvim --server "$NVIM" --remote {{filename}}]],
        editAtLine = [[nvim --server "$NVIM" --remote-send "q"; nvim --server "$NVIM" --remote {{filename}}; nvim --server "$NVIM" --remote-send ":{{line}}<CR>"]],
        editInTerminal = false,
      },
    },
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
    enabled = true,
  },
  quickfile = { enabled = true },
  scope = { enabled = true },
  statuscolumn = { enabled = false },
  words = { enabled = false },
})
