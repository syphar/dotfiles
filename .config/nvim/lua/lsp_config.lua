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

function cfg.updated_capabilities() 
  local capabilities = vim.lsp.protocol.make_client_capabilities()
  return require('cmp_nvim_lsp').update_capabilities(capabilities)
end

function cfg.lsp_setup()
  local lsp = require('lspconfig')


  lsp.pylsp.setup({
      capabilities = cfg.updated_capabilities(),
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

function cfg.cmp_setup() 
    local cmp = require'cmp'

    cmp.setup({
      completion = {
        completeopt = 'menu,menuone,noselect',
      },
      mapping = {
        ['<C-d>'] = cmp.mapping(cmp.mapping.scroll_docs(-4), { 'i', 'c' }),
        ['<C-f>'] = cmp.mapping(cmp.mapping.scroll_docs(4), { 'i', 'c' }),
        ['<C-Space>'] = cmp.mapping(cmp.mapping.complete(), { 'i', 'c' }),
        ['<C-y>'] = cmp.config.disable, -- If you want to remove the default `<C-y>` mapping, You can specify `cmp.config.disable` value.
        ['<C-e>'] = cmp.mapping({
          i = cmp.mapping.abort(),
          c = cmp.mapping.close(),
        }),
        ['<CR>'] = cmp.mapping.confirm({ select = true }),
        ['<Tab>'] = cmp.mapping(cmp.mapping.select_next_item(), { 'i', 's' }),
        ['<S-Tab>'] = cmp.mapping(cmp.mapping.select_prev_item(), { 'i', 's' }),
      },
      sources = cmp.config.sources({
        { name = 'nvim_lsp' },
       	{ name = 'cmp_tabnine' },
      }, {
        { name = 'buffer' },
      })
    })

    -- Use buffer source for `/`.
    cmp.setup.cmdline('/', {
      sources = {
        { name = 'buffer' }
      }
    })

    -- Use cmdline & path source for ':'.
    cmp.setup.cmdline(':', {
      sources = cmp.config.sources({
        { name = 'path' }
      }, {
        { name = 'cmdline' }
      })
    })

    -- Add additional capabilities supported by nvim-cmp
    -- local capabilities = vim.lsp.protocol.make_client_capabilities()
    -- capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

    -- -- Enable some language servers with the additional completion capabilities offered by nvim-cmp
    -- local lspconfig = require('lspconfig')
    -- local servers = { 'pylsp', 'rust_analyzer'}
    -- for _, lsp in ipairs(servers) do
    --   lspconfig[lsp].setup {
    --     capabilities = capabilities,
    --   }
    -- end
end

return cfg
