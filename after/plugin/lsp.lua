local lsp = require('lsp-zero').preset({})

lsp.on_attach(function(client, bufnr)
    lsp.default_keymaps({ buffer = bufnr })
    lsp.buffer_autoformat()
end)

lsp.ensure_installed({
    -- Replace these with whatever servers you want to install
    'eslint',
    'bashls',
    'clangd',
    'pylsp',
    'html',
    'cssls',
    'rust_analyzer',
    'texlab',
    'tsserver'
})

-- (Optional) Configure lua language server for neovim
require('lspconfig').lua_ls.setup(lsp.nvim_lua_ls())

lsp.setup()

-- Make sure you setup `cmp` after lsp-zero

local cmp = require('cmp')
local handlers = require('nvim-autopairs.completion.handlers')
local cmp_action = require('lsp-zero').cmp_action()
local cmp_autopairs = require('nvim-autopairs.completion.cmp')

cmp.setup({
    sources = {
        { name = 'nvim_lsp' },
        { name = 'nvim_lua' },
    },
    mapping = {
        ['<Tab>'] = cmp_action.luasnip_supertab(),
        ['<S-Tab>'] = cmp_action.luasnip_shift_supertab(),
        ['<C-f>'] = cmp_action.luasnip_jump_forward(),
        ['<C-b>'] = cmp_action.luasnip_jump_backward(),
        ['<CR>'] = cmp.mapping.confirm({ select = false }),
    }
})

cmp.event:on(
    'confirm_done',
    cmp_autopairs.on_confirm_done({
        filetypes = {
            -- "*" is a alias to all filetypes
            ["*"] = {
                ["("] = {
                    kind = {
                        cmp.lsp.CompletionItemKind.Function,
                        cmp.lsp.CompletionItemKind.Method,
                    },
                    handler = handlers["*"]
                }
            },
            lua = {
                ["("] = {
                    kind = {
                        cmp.lsp.CompletionItemKind.Function,
                        cmp.lsp.CompletionItemKind.Method
                    },
                    ---@param char string
                    ---@param item table item completion
                    ---@param bufnr number buffer number
                    ---@param rules table
                    ---@param commit_character table<string>
                    handler = function(char, item, bufnr, rules, commit_character)
                        -- Your handler function. Inpect with print(vim.inspect{char, item, bufnr, rules, commit_character})
                    end
                }
            },
            -- Disable for tex
            tex = false
        }
    })
)
