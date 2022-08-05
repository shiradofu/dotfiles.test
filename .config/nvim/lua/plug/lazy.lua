-- 依存順序注意
vim.defer_fn(function()
  require('packer').loader(
    'nvim-web-devicons',
    'fzf-lua',
    'vim-repeat',
    'denops.vim',
    'gin.vim',
    'fuzzy-motion.vim',
    'LuaSnip',
    'nvim-cmp',
    'cmp-nvim-lsp',
    'cmp-buffer',
    'cmp-path',
    'cmp-cmdline',
    'cmp_luasnip',
    'cmp-rg',
    'cmp-conventionalcommits',
    'nvim-lspconfig',
    'null-ls.nvim',
    'nvim-lsp-installer',
    'lsp_signature.nvim',
    'nvim-code-action-menu',
    'nvim-treesitter',
    'nvim-yati',
    'nvim-treesitter-textobjects',
    'nvim-ts-context-commentstring',
    'vim-textobj-user',
    'vim-textobj-parameter',
    'vim-textobj-entire',
    'vim-textobj-indent',
    'vim-textobj-line',
    'vim-textobj-comment',
    'substitute.nvim',
    'neotest-jest',
    'neotest-vitest',
    'neotest-phpunit',
    'neotest-go',
    'neotest',
    'gitsigns.nvim',
    'git-conflict.nvim',
    'vim-mergetool',
    'vim-asterisk',
    'nvim-scrollbar',
    'nvim-hlslens',
    'nvim-colorizer.lua',
    'vim-better-whitespace',
    'open-browser.vim'
  )
end, 0)