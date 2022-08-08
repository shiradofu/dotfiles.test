local cmp = require 'cmp'
local luasnip = require 'luasnip'
local maps = require('user.mappings').cmp_selection(cmp)

local view = {
  entries = {
    name = 'custom',
    selection_order = 'near_cursor',
  },
}

cmp.setup {
  snippet = {
    -- REQUIRED - you must specify a snippet engine
    expand = function(args)
      luasnip.lsp_expand(args.body)
    end,
  },
  window = {
    completion = cmp.config.window.bordered { border = 'single' },
    documentation = cmp.config.window.bordered { border = 'single' },
  },
  mapping = {
    ['<Tab>'] = { i = maps['<Tab>'] },
    ['<C-n>'] = { i = maps['<C-n>'] },
    ['<C-p>'] = { i = maps['<C-p>'] },
    ['<C-l>'] = { i = maps['<C-l>'] },
  },
  view = view,
  sources = cmp.config.sources {
    { name = 'luasnip' },
    { name = 'nvim_lsp' },
    { name = 'path' },
    -- {
    --   name = 'buffer',
    --   option = {
    --     -- https://github.com/hrsh7th/cmp-buffer#performance-on-large-text-files
    --     get_bufnrs = function()
    --       local bufs = {}
    --       local all = vim.api.nvim_list_bufs()
    --       for _, buf in ipairs(all) do
    --         local byte_size =
    --           vim.api.nvim_buf_get_offset(buf, vim.api.nvim_buf_line_count(buf))
    --         if byte_size <= 1024 * 1024 then -- 1 Megabyte max
    --           bufs[#bufs + 1] = buf
    --         end
    --       end
    --       return bufs
    --     end,
    --   },
    -- },
    { name = 'rg' },
  },
}

cmp.setup.cmdline('/', {
  mapping = {
    ['<Tab>'] = { c = maps['<Tab>'] },
    ['<C-n>'] = { c = maps['<C-n>'] },
    ['<C-p>'] = { c = maps['<C-p>'] },
    ['<C-l>'] = { c = maps['<C-l>'] },
  },
  sources = cmp.config.sources {
    { name = 'buffer' },
  },
})

cmp.setup.cmdline(':', {
  mapping = {
    ['<Tab>'] = { c = maps['<Tab>'] },
    ['<C-n>'] = { c = maps['<C-n>'] },
    ['<C-p>'] = { c = maps['<C-p>'] },
    ['<C-l>'] = { c = maps['<C-l>'] },
  },
  sources = cmp.config.sources {
    { name = 'cmdline' },
    { name = 'path' },
  },
})

cmp.setup.filetype('gitcommit', {
  sources = cmp.config.sources {
    { name = 'conventionalcommits' },
    { name = 'buffer' },
  },
})