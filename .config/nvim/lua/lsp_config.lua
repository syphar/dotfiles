local cfg = {}

function cfg.lsp_on_attach(client, bufnr) 
  -- generic on_attach, should be passed to all language servers. 
  -- rust-tools get it in `plugins` in its custom `config` method
  local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end

  local opts = { noremap=true, silent=true }
  buf_set_keymap("n", "K", "<Cmd>lua vim.lsp.buf.hover()<CR>", opts)
  buf_set_keymap("n", "<F2>", "<Cmd>lua vim.lsp.buf.rename()<CR>", opts)
  buf_set_keymap("n", "<leader>gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
  buf_set_keymap("n", "<leader>n", "<Cmd>lua vim.lsp.buf.references()<CR>", opts)

  if client.resolved_capabilities.document_formatting then
    vim.cmd [[augroup Format]]
    vim.cmd [[autocmd! * <buffer>]]
    vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync(nil, 1000)]]
    vim.cmd [[augroup END]]
  end

  require "lsp_signature".on_attach({
      bind = true,
  })  
end

function cfg.lsp_setup()
  local lsp = require('lspconfig')

  lsp.pylsp.setup({
      on_attach = cfg.lsp_on_attach,
      settings = {
          pylsp = {
              configurationSources = {"flake8", "pycodestyle"},
              plugins = {
                  pydocstyle = {
                      enabled = true
                  },
                  pycodestyle = {
                      enabled = true
                  },
                  pyflakes = {
                      enabled = true
                  },
                  jedi_signature_help = {
                      enabled = false
                  },
                  pylsp_mypy = {
                      enabled = true, 
                      live_mode = false,
                      dmypy = true,
                  }
              },
          },
      }
  })
end

return cfg
