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

" Deoplete {{{
" ______________________________________________________________________

" don't enable at startup, enable on insert
"let g:deoplete#enable_at_startup = 0
"autocmd InsertEnter * call deoplete#enable()

"" disable some deoplete sources. (aka all default ones + ale)
"" _ = all file types, but more can be added per type
""
"" all default sources
"" https://github.com/Shougo/deoplete.nvim/blob/0901b1886208a32880b92f22bf8f38a17e95045a/doc/deoplete.txt#L625-L759
"call deoplete#custom#option('ignore_sources', {
"  \ '_': ['tag', 'buffer', 'ale', 'around', 'file', 'member', 'omni']
"  \ })

"call deoplete#custom#source('tabnine', 'rank', 10)
"call deoplete#custom#source('ultisnips', 'rank', 100)
"call deoplete#custom#source('LanguageClient', 'rank', 1000)

"" parallel execution, one process per source
"call deoplete#custom#option('num_processes', 0)

" }}}

" ALE {{{
" ______________________________________________________________________

let g:ale_set_loclist = 1
let g:ale_set_quickfix = 0
let g:ale_virtualtext_cursor = 1
let g:ale_set_signs = 1


" filetype specific fixers and linters in ftplugin
let g:ale_fixers = { '*': ['remove_trailing_lines', 'trim_whitespace']}
let g:ale_fix_on_save = 1

" only lint on safe
let g:ale_lint_on_enter            = 0
let g:ale_lint_on_filetype_changed = 0
let g:ale_lint_on_insert_leave     = 0
let g:ale_lint_on_save             = 1
let g:ale_lint_on_text_changed     = 'never'


" }}}

" treesitter {{{
lua <<EOF
require'nvim-treesitter.configs'.setup {
  ensure_installed = "maintained", -- one of "all", "maintained" (parsers with maintainers), or a list of languages
  ignore_install = {}, -- List of parsers to ignore installing
  highlight = {
    enable = true, -- false will disable the whole extension
    disable = {},  -- list of language that will be disabled
  },
}
EOF
" }}}

" indentline {{{
" let g:indentLine_char = '│'
" let g:indentLine_enabled = 1
" }}}

" Notational {{{

let g:nv_search_paths = ['~/Dropbox/notes/']
let g:nv_create_note_window = 'split'

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

" vim: et ts=2 sts=2 sw=2 foldmethod=marker foldlevel=0
