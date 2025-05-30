return {
  name = 'auto run build',
  builder = function()
    local file = vim.fn.expand '%:p'
    local cmd = { file }
    if vim.bo.filetype == 'go' then
      cmd = { 'go', 'build', '.' }
    end
    return {
      cmd = cmd,
      components = {
        { 'on_output_quickfix', set_diagnostics = true },
        'on_result_diagnostics',
        'default',
      },
    }
  end,
  condition = {
    filetype = { 'go' },
  },
}
