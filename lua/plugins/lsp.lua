require('mason').setup({})
require('mason-lspconfig').setup({
  ensure_installed = {
    'lua_ls',
    'rust_analyzer',
    'copilot',
    'ty',
    'docker_compose_language_service',
    'docker_language_server',
  },
})
require('lazydev').setup({
  library = {
    -- See the configuration section for more details
    -- Load luvit types when the `vim.uv` word is found
    { path = '${3rd}/luv/library', words = { 'vim%.uv' } },
  },
})

require('blink-copilot').setup({
  debounce = 50,
  max_completions = 2,
})

require('blink.cmp').setup({
  -- fuzzy = { implementation = 'prefer_rust_with_warning' },
  fuzzy = { implementation = 'prefer_rust_with_warning' },
  signature = { enabled = true },
  appearance = {
    -- use_nvim_cmp_as_default = true,
    nerd_font_variant = 'normal',
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
    default = { 'lazydev', 'lsp', 'path', 'snippets', 'buffer', 'copilot' },
    providers = {
      lazydev = { module = 'lazydev.integrations.blink', score_offset = 100, name = 'LazyDev' },
      copilot = {
        name = 'copilot',
        module = 'blink-copilot',
        score_offset = 100,
        async = true,
      },
    },
  },
  keymap = {
    preset = 'default',
    ['<C-y>'] = {
      function() -- sidekick next edit suggestion
        return require('sidekick').nes_jump_or_apply()
      end,
      'select_and_accept',
      'fallback',
    },
  },
})

require('conform').setup({
  notify_on_error = true,
  format_on_save = function(bufnr)
    -- Disable "format_on_save lsp_fallback" for languages that don't
    -- have a well standardized coding style. You can add additional
    -- languages here or re-enable it for the disabled ones.
    local disable_filetypes = { c = true, cpp = true }
    if disable_filetypes[vim.bo[bufnr].filetype] then
      return nil
    else
      return {
        timeout_ms = 500,
        lsp_format = 'fallback',
      }
    end
  end,
  formatters_by_ft = {
    lua = { 'stylua' },
    python = { 'ruff_fix', 'ruff_format' },
    markdown = { 'markdownlint-cli2', 'markdown-toc' },
    ['markdown.mdx'] = { 'markdownlint-cli2', 'markdown-toc' },
  },
})

vim.diagnostic.config({
  update_in_insert = false,
  severity_sort = true,
  float = { border = 'rounded', source = 'if_many' },
  virtual_text = true,   -- Text shows up at the end of the line
  virtual_lines = false, -- Teest shows up underneath the line, with virtual lines
  underline = { severity = vim.diagnostic.severity.ERROR },
  jump = { float = true },
})

vim.lsp.config('gopls', {
  settings = {
    ['gopls'] = {
      gofumpt = true,
      codelenses = {
        gc_details = false,
        generate = true,
        regenerate_cgo = true,
        run_govulncheck = true,
        test = true,
        tidy = true,
        upgrade_dependency = true,
        vendor = true,
      },
      hints = {
        assignVariableTypes = true,
        compositeLiteralFields = true,
        compositeLiteralTypes = true,
        constantValues = true,
        functionTypeParameters = true,
        parameterNames = true,
        rangeVariableTypes = true,
      },
      analyses = {
        nilness = true,
        unusedparams = true,
        unusedwrite = true,
        useany = true,
      },
      usePlaceholders = true,
      completeUnimported = true,
      staticcheck = true,
      directoryFilters = { '-.git', '-.vscode', '-.idea', '-.vscode-test', '-node_modules' },
      semanticTokens = true,
    },
  },
})
