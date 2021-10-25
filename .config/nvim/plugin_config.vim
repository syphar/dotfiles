" {{{ rust 
lua <<EOF
local opts = {
    tools = { -- rust-tools options
        -- automatically set inlay hints (type hints)
        -- There is an issue due to which the hints are not applied on the first
        -- opened file. For now, write to the file to trigger a reapplication of
        -- the hints or just run :RustSetInlayHints.
        -- default: true
        autoSetHints = true,

        -- whether to show hover actions inside the hover window
        -- this overrides the default hover handler
        -- default: true
        hover_with_actions = true,

        runnables = {
            -- whether to use telescope for selection menu or not
            -- default: true
            use_telescope = true

            -- rest of the opts are forwarded to telescope
        },

        inlay_hints = {
            -- wheter to show parameter hints with the inlay hints or not
            -- default: true
            show_parameter_hints = true,

            -- prefix for parameter hints
            -- default: "<-"
            parameter_hints_prefix = "<-",

            -- prefix for all the other hints (type, chaining)
            -- default: "=>"
            other_hints_prefix  = "=>",

            -- whether to align to the lenght of the longest line in the file
            max_len_align = false,

            -- padding from the left if max_len_align is true
            max_len_align_padding = 1,

            -- whether to align to the extreme right or not
            right_align = false,

            -- padding from the right if right_align is true
            right_align_padding = 7,
        },

        hover_actions = {
            -- the border that is used for the hover window
            -- see vim.api.nvim_open_win()
            border = {
              {"╭", "FloatBorder"},
              {"─", "FloatBorder"},
              {"╮", "FloatBorder"},
              {"│", "FloatBorder"},
              {"╯", "FloatBorder"},
              {"─", "FloatBorder"},
              {"╰", "FloatBorder"},
              {"│", "FloatBorder"}
            },
        }
    },

    -- all the opts to send to nvim-lspconfig
    -- these override the defaults set by rust-tools.nvim
    -- see https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#rust_analyzer
    server = {
      settings = {
        ["rust-analyzer"] = {
          checkOnSave = {
              command = "clippy"
          },
        }
      }
    }, 
}

require('rust-tools').setup(opts)
EOF
" }}}

" compe {{{
lua <<EOF
require'compe'.setup {
  enabled = true;
  autocomplete = true;
  debug = false;
  min_length = 1;
  preselect = 'enable';
  throttle_time = 80;
  source_timeout = 200;
  resolve_timeout = 800;
  incomplete_delay = 400;
  max_abbr_width = 100;
  max_kind_width = 100;
  max_menu_width = 100;
  documentation = {
    border = { '', '' ,'', ' ', '', '', '', ' ' }, -- the border option is the same as `|help nvim_open_win|`
    winhighlight = "NormalFloat:CompeDocumentation,FloatBorder:CompeDocumentationBorder",
    max_width = 120,
    min_width = 60,
    max_height = math.floor(vim.o.lines * 0.3),
    min_height = 1,
  };
  source = {
    path = true,
    buffer = false,
    calc = true,
    nvim_lsp = true,
    nvim_lua = true,
    vsnip = false,
    ultisnips = false,
    luasnip = false,
    tabnine = {
      max_line = 1000,
      max_num_results = 6,
      priority = 10,
      sort = false, -- setting sort to false means compe will leave tabnine to sort the completion items
      show_prediction_strength = true,
      ignore_pattern = '',
    },
  };
}

-- based on https://github.com/hrsh7th/nvim-compe#how-to-use-tab-to-navigate-completion-menu
local t = function(str)
  return vim.api.nvim_replace_termcodes(str, true, true, true)
end

local check_back_space = function()
    local col = vim.fn.col('.') - 1
    return col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') ~= nil
end

-- Use (s-)tab to:
--- move to prev/next item in completion menuone
--- jump to prev/next snippet's placeholder
_G.tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-n>"
  elseif check_back_space() then
    return t "<Tab>"
  else
    return vim.fn['compe#complete']()
  end
end
_G.s_tab_complete = function()
  if vim.fn.pumvisible() == 1 then
    return t "<C-p>"
  else
    -- If <S-Tab> is not working in your terminal, change it to <C-h>
    return t "<S-Tab>"
  end
end

vim.api.nvim_set_keymap("i", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<Tab>", "v:lua.tab_complete()", {expr = true})
vim.api.nvim_set_keymap("i", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})
vim.api.nvim_set_keymap("s", "<S-Tab>", "v:lua.s_tab_complete()", {expr = true})

EOF
" }}}


" treesitter {{{
lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  ignore_install = {}, -- List of parsers to ignore installing
  highlight = {
    enable = true, -- false will disable the whole extension
    disable = {},  -- list of language that will be disabled
  }
}
EOF
" }}}

" github theme {{{
lua <<EOF
require("github-theme").setup({
  theme_style="light",
  transparent=true,
  comment_style="italic",
  keyword_style="bold",
  function_style="NONE",
  variable_style="NONE"
})
EOF
" }}}

" vim-test {{{
let g:test#strategy = "dispatch"
let g:test#preserve_screen = 0
let g:test#python#runner = 'pytest'


" }}}

" dispatch {{{
"
let g:dispatch_quickfix_height = 20
let g:dispatch_tmux_height = 20

" }}}


" context {{{
lua <<EOF
require'treesitter-context.config'.setup{
    enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
}
EOF

hi! link TreesitterContext Folded

" }}}


" vinegar / netwrk {{{
" CTRL-6 should go back to the last file, not netrw/vinegar
let g:netrw_altfile = 1

let g:netrw_banner = 0 " disable banner
let g:netrw_liststyle = 3 " tree view
let g:netrw_altv = 1 " open split on the right

" let g:netrw_list_hide=netrw_gitignore#Hide()

" }}}


" wordmotion {{{
" let g:wordmotion_prefix = '<Leader>'
"
let g:wordmotion_uppercase_spaces = ['.', ',', '(', ')', '[', ']', '{', '}', ' ', '<', '>', ':']


" }}}

" requirements.txt {{{

let g:requirements#detect_filename_pattern = '\vrequirement?s\_.*\.(txt|in)$'

" }}}

" trouble {{{ 

lua << EOF
  require("trouble").setup {
    mode = "lsp_document_diagnostics"
  }
EOF
" }}}

" telescope {{{
lua << EOF 
require('telescope').setup {
  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true, -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                       -- the default case_mode is "smart_case"
    }
  }
}
-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require('telescope').load_extension('fzf')
EOF 
" }}}

" lightbulb LSP {{{
autocmd CursorHold,CursorHoldI * lua require'nvim-lightbulb'.update_lightbulb()
" }}} 

" GitSigns {{{
lua << EOF 
require('gitsigns').setup()
EOF 
" }}} 

" focus {{{
lua << EOF 
require("focus").setup()
EOF 
" }}} 

" treesitter-textsubjects {{{
lua << EOF 
require'nvim-treesitter.configs'.setup {
    textsubjects = {
        enable = true,
        keymaps = {
            ['.'] = 'textsubjects-smart',
            [';'] = 'textsubjects-container-outer',
        }
    },
}
EOF 
" }}} 

" vim: et ts=2 sts=2 sw=2 foldmethod=marker foldlevel=0
"
