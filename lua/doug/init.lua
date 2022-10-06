require("doug.packer")
require("doug.set")
require("doug.remap")

require('lualine').setup()

require("mason").setup({
    ui = {
        icons = {
            package_installed = "✓",
            package_pending = "➜",
            package_uninstalled = "✗"
        }
    }
})
require("mason-lspconfig").setup()

require("rust-tools").setup({
  server = {
    settings = {
      on_attach = function(_, bufnr)
        -- Hover actions
        vim.keymap.set("n", "<C-space>", rt.hover_actions.hover_actions, { buffer = bufnr })
        -- Code action groups
        vim.keymap.set("n", "<Leader>a", rt.code_action_group.code_action_group, { buffer = bufnr })
        require 'illuminate'.on_attach(client)
      end,
      ["rust-analyzer"] = {
          checkOnSave = {
              command = "clippy"
          },
      },
    }
  },
})

require("nvim-tree").setup()

require('nvim-autopairs').setup({})

require("nvim-treesitter.configs").setup({
  ensure_installed = { "lua", "rust", "toml", "javascript", "typescript", "c", "cpp", "make" },
  auto_install = true,
  highlight = {
    enable = true,
    additional_vim_regex_highlighting=false,
  },
  ident = { enable = true },
  rainbow = {
    enable = true,
    extended_mode = true,
    max_file_lines = nil,
  },
  nt_cpp_tools = {
      enable = true,
      preview = {
          quit = 'q', -- optional keymapping for quit preview
          accept = '<tab>' -- optional keymapping for accept preview
      },
      header_extension = 'h', -- optional
      source_extension = 'cxx', -- optional
      custom_define_class_function_commands = { -- optional
          TSCppImplWrite = {
              output_handle = require'nvim-treesitter.nt-cpp-tools.output_handlers'.get_add_to_cpp()
          }
          --[[
          <your impl function custom command name> = {
              output_handle = function (str, context) 
                  -- string contains the class implementation
                  -- do whatever you want to do with it
              end
          }
          ]]
      }
  }
})
require("treesitter-context").setup({
    enable = true, -- Enable this plugin (Can be enabled/disabled later via commands)
    max_lines = 0, -- How many lines the window should span. Values <= 0 mean no limit.
    trim_scope = 'outer', -- Which context lines to discard if `max_lines` is exceeded. Choices: 'inner', 'outer'
    min_window_height = 0, -- Minimum editor window height to enable context. Values <= 0 mean no limit.
    patterns = { -- Match patterns for TS nodes. These get wrapped to match at word boundaries.
        -- For all filetypes
        -- Note that setting an entry here replaces all other patterns for this entry.
        -- By setting the 'default' entry below, you can control which nodes you want to
        -- appear in the context window.
        default = {
            'class',
            'function',
            'method',
            'for',
            'while',
            'if',
            'switch',
            'case',
            'func',
            'fn'
        },
        -- Patterns for specific filetypes
        -- If a pattern is missing, *open a PR* so everyone can benefit.
        tex = {
            'chapter',
            'section',
            'subsection',
            'subsubsection',
        },
        rust = {
            'impl_item',
            'struct',
            'enum',
        },
        scala = {
            'object_definition',
        },
        vhdl = {
            'process_statement',
            'architecture_body',
            'entity_declaration',
        },
        markdown = {
            'section',
        },
        elixir = {
            'anonymous_function',
            'arguments',
            'block',
            'do_block',
            'list',
            'map',
            'tuple',
            'quoted_content',
        },
        json = {
            'pair',
        },
        yaml = {
            'block_mapping_pair',
        },
    },
    exact_patterns = {
        -- Example for a specific filetype with Lua patterns
        -- Treat patterns.rust as a Lua pattern (i.e "^impl_item$" will
        -- exactly match "impl_item" only)
        -- rust = true,
    },

    -- [!] The options below are exposed but shouldn't require your attention,
    --     you can safely ignore them.

    zindex = 20, -- The Z-index of the context window
    mode = 'cursor',  -- Line used to calculate context. Choices: 'cursor', 'topline'
    -- Separator between context and content. Should be a single character string, like '-'.
    -- When separator is set, the context will only show up when there are at least 2 lines above cursorline.
    separator = nil,
})

-- Run rust formatter on save
vim.api.nvim_exec([[ autocmd BufWritePre *.rs :silent! lua vim.lsp.buf.formatting_sync(nil, 200) ]], false)

-- Run c++ formaterr on save
vim.api.nvim_exec([[ autocmd BufWritePre *.cpp :silent! lua vim.lsp.buf.formatting_sync(nil, 200) ]], false)
vim.api.nvim_exec([[ autocmd BufWritePre *.cc :silent! lua vim.lsp.buf.formatting_sync(nil, 200) ]], false)
vim.api.nvim_exec([[ autocmd BufWritePre *.cxx :silent! lua vim.lsp.buf.formatting_sync(nil, 200) ]], false)
vim.api.nvim_exec([[ autocmd BufWritePre *.h :silent! lua vim.lsp.buf.formatting_sync(nil, 200) ]], false)

require('go').setup()
-- Run gofmt + goimport on save
vim.api.nvim_exec([[ autocmd BufWritePre *.go :silent! lua require('go.format').goimport() ]], false)




---
-- LSP config
---

local lsp_defaults = {
  flags = {
    debounce_text_changes = 150,
  },
  capabilities = require('cmp_nvim_lsp').update_capabilities(
    vim.lsp.protocol.make_client_capabilities()
  ),
  on_attach = function(client, bufnr)
    vim.api.nvim_exec_autocmds('User', {pattern = 'LspAttached'})
  end
}

local lspconfig = require('lspconfig')

lspconfig.util.default_config = vim.tbl_deep_extend(
  'force',
  lspconfig.util.default_config,
  lsp_defaults
)

---
-- LSP opts
---

--Set completeopt to have a better completion experience
-- :help completeopt
-- menuone: popup even when there's only one match
-- noinsert: Do not insert text until a selection is made
-- noselect: Do not select, force to select one from the menu
-- shortness: avoid showing extra messages when using completion
-- updatetime: set updatetime for CursorHold
vim.opt.completeopt = {'menuone', 'noselect', 'noinsert'}
vim.opt.shortmess = vim.opt.shortmess + { c = true}
vim.api.nvim_set_option('updatetime', 300) 

-- Fixed column for diagnostics to appear
-- Show autodiagnostic popup on cursor hover_range
-- Goto previous / next diagnostic warning / error 
-- Show inlay_hints more frequently 
vim.cmd([[
set signcolumn=yes
autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
]])

---
-- LSP servers
---
local null_ls = require("null-ls")

null_ls.setup({
  -- on_attach = function(client, bufnr)
  --   if client.server_capabilities.documentFormattingProvider then
  --     vim.cmd("nnoremap <silent><buffer> <Leader>f :lua vim.lsp.buf.formatting()<CR>")
  --
  --     -- format on save
  --     vim.cmd("autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting()")
  --   end
  --
  --   if client.server_capabilities.documentRangeFormattingProvider then
  --     vim.cmd("xnoremap <silent><buffer> <Leader>f :lua vim.lsp.buf.range_formatting({})<CR>")
  --   end
  -- end,
  on_attach = function(client, bufnr)
    if client.supports_method("textDocument/formatting") then
        vim.api.nvim_clear_autocmds({ group = augroup, buffer = bufnr })
        vim.api.nvim_create_autocmd("BufWritePre", {
            group = augroup,
            buffer = bufnr,
            callback = function()
                -- on 0.8, you should use vim.lsp.buf.format({ bufnr = bufnr }) instead
                vim.lsp.buf.formatting_sync()
            end,
        })
    end
  end,
})

local prettier = require("prettier")

prettier.setup({

  bin = 'prettierd', -- or `prettierd`
  filetypes = {
    "css",
    "graphql",
    "html",
    "javascript",
    "javascriptreact",
    "json",
    "less",
    "markdown",
    "scss",
    "typescript",
    "typescriptreact",
    "yaml",
  },
  ["null-ls"] = {
    runtime_condition = function(params)
      -- return false to skip running prettier
      return true
    end,
    timeout = 5000,
  }
})


---
-- LSP servers
---

local on_attach_ts = function(client, bufnr)
  if client.name == "tsserver" then
     client.resolved_capabilities.document_formatting  =  false
  end
end

lspconfig.tsserver.setup({
  on_attach = on_attach_ts
})
lspconfig.eslint.setup({})
-- lspconfig.eslint.setup({
--   on_attach = function(client)
--       vim.api.nvim_create_autocmd("BufWritePre", {
--         pattern = { "*.js", "*.jsx", "*.ts", "*.tsx" },
--         callback = function()
--           vim.cmd("EslintFixAll")
--           vim.cmd("Prettier")
--       end,
--       group = autogroup_eslint_lsp,
--     })
--   end
-- })
lspconfig.html.setup({})
lspconfig.cssls.setup({})
lspconfig.sumneko_lua.setup({})
lspconfig.zls.setup({})
lspconfig.rust_analyzer.setup({})
lspconfig.clangd.setup({})
lspconfig['gopls'].setup({})
lspconfig['golangci_lint_ls'].setup({})

---
-- Keybindings
---

vim.api.nvim_create_autocmd('User', {
  pattern = 'LspAttached',
  desc = 'LSP actions',
  callback = function()
  --   local bufmap = function(mode, lhs, rhs)
  --     local opts = {buffer = true}
  --     vim.keymap.set(mode, lhs, rhs, opts)
  --   end
  --
  --   bufmap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>')
  --   bufmap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>')
  --   bufmap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>')
  --   bufmap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>')
  --   bufmap('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>')
  --   bufmap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>')
  --   bufmap('n', '<leader>gk', '<cmd>lua vim.lsp.buf.signature_help()<cr>')
  --   bufmap('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>')
  --   bufmap('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>')
  --   bufmap('x', '<F4>', '<cmd>lua vim.lsp.buf.range_code_action()<cr>')
  --   bufmap('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>')
  --   bufmap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>')
  --   bufmap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>')
  end
})

    vim.api.nvim_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<cr>', { noremap = false })
    vim.api.nvim_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<cr>', { noremap = false })
    vim.api.nvim_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<cr>', { noremap = false })
    vim.api.nvim_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<cr>', { noremap = false })
    vim.api.nvim_set_keymap('n', 'go', '<cmd>lua vim.lsp.buf.type_definition()<cr>', { noremap = false })
    vim.api.nvim_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<cr>', { noremap = false })
    vim.api.nvim_set_keymap('n', '<leader>gk', '<cmd>lua vim.lsp.buf.signature_help()<cr>', { noremap = false })
    vim.api.nvim_set_keymap('n', '<F2>', '<cmd>lua vim.lsp.buf.rename()<cr>', { noremap = false })
    vim.api.nvim_set_keymap('n', '<F4>', '<cmd>lua vim.lsp.buf.code_action()<cr>', { noremap = false })
    vim.api.nvim_set_keymap('x', '<F4>', '<cmd>lua vim.lsp.buf.range_code_action()<cr>', { noremap = false })
    vim.api.nvim_set_keymap('n', 'gl', '<cmd>lua vim.diagnostic.open_float()<cr>', { noremap = false })
    vim.api.nvim_set_keymap('n', '[d', '<cmd>lua vim.diagnostic.goto_prev()<cr>', { noremap = false })
    vim.api.nvim_set_keymap('n', ']d', '<cmd>lua vim.diagnostic.goto_next()<cr>', { noremap = false })


---
-- Diagnostics
---

local sign = function(opts)
  vim.fn.sign_define(opts.name, {
    texthl = opts.name,
    text = opts.text,
    numhl = ''
  })
end

sign({name = 'DiagnosticSignError', text = '✘'})
sign({name = 'DiagnosticSignWarn', text = '▲'})
sign({name = 'DiagnosticSignHint', text = '⚑'})
sign({name = 'DiagnosticSignInfo', text = ''})

vim.diagnostic.config({
  virtual_text = false,
  signs = true,
  update_in_insert = true,
  underline = true,
  severity_sort = false,
  float = {
    border = 'rounded',
    source = 'always',
    header = '',
    prefix = '',
  },
})

vim.cmd([[
set signcolumn=yes
autocmd CursorHold * lua vim.diagnostic.open_float(nil, { focusable = false })
]])

---
-- Autocomplete
---

require('luasnip.loaders.from_vscode').lazy_load()

local cmp = require('cmp')
local luasnip = require('luasnip')

local select_opts = {behavior = cmp.SelectBehavior.Select}

cmp.setup({
  snippet = {
    expand = function(args)
      --luasnip.lsp_expand(args.body)
      vim.fn["vsnip#anonymous"](args.body)
    end
  },
  sources = {
    {name = 'path'},
    {name = 'nvim_lsp', keyword_length = 3},
    {name = 'nvim_lsp_signature_help'},            -- display function signatures with current parameter emphasized
    {name = 'nvim_lua', keyword_length = 2},       -- complete neovim's Lua runtime API such vim.lsp.*
    {name = 'buffer', keyword_length = 3},
    --{name = 'luasnip', keyword_length = 2},
    {name = 'vsnip', keyword_length = 2 },         -- nvim-cmp source for vim-vsnip 
    {name = 'calc'},                               -- source for math calculation
  },
  window = {
    completion = cmp.config.window.bordered(),
    documentation = cmp.config.window.bordered(),
  },
  formatting = {
    fields = {'menu', 'abbr', 'kind'},
    format = function(entry, item)
      local menu_icon = {
        nvim_lsp = 'λ',
        luasnip = '⋗',
        buffer = 'Ω',
        path = '🖫',
      }

      item.menu = menu_icon[entry.source.name]
      return item
    end,
  },
  mapping = {
    ['<Up>'] = cmp.mapping.select_prev_item(select_opts),
    ['<Down>'] = cmp.mapping.select_next_item(select_opts),

    ['<C-p>'] = cmp.mapping.select_prev_item(select_opts),
    ['<C-n>'] = cmp.mapping.select_next_item(select_opts),

    ['<C-u>'] = cmp.mapping.scroll_docs(-4),
    ['<C-f>'] = cmp.mapping.scroll_docs(4),

    ['<C-e>'] = cmp.mapping.abort(),
    ['<CR>'] = cmp.mapping.confirm({select = true}),

    ['<C-d>'] = cmp.mapping(function(fallback)
      if luasnip.jumpable(1) then
        luasnip.jump(1)
      else
        fallback()
      end
    end, {'i', 's'}),

    ['<C-b>'] = cmp.mapping(function(fallback)
      if luasnip.jumpable(-1) then
        luasnip.jump(-1)
      else
        fallback()
      end
    end, {'i', 's'}),

    ['<Tab>'] = cmp.mapping(function(fallback)
      local col = vim.fn.col('.') - 1

      if cmp.visible() then
        cmp.select_next_item(select_opts)
      elseif col == 0 or vim.fn.getline('.'):sub(col, col):match('%s') then
        fallback()
      else
        cmp.complete()
      end
    end, {'i', 's'}),

    ['<S-Tab>'] = cmp.mapping(function(fallback)
      if cmp.visible() then
        cmp.select_prev_item(select_opts)
      else
        fallback()
      end
    end, {'i', 's'}),
  },
})

-- You dont need to set any of these options. These are the default ones. Only
-- the loading is important
require('telescope').setup {
  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                       -- the default case_mode is "smart_case"
    }
  }
}
-- To get fzf loaded and working with telescope, you need to call
-- load_extension, somewhere after setup function:
require('telescope').load_extension('fzf')
