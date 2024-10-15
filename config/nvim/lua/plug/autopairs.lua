local feedkeys = require('user.util').feedkeys

return {
  'windwp/nvim-autopairs',
  event = 'InsertEnter',
  config = function()
    local npairs = require 'nvim-autopairs'
    npairs.setup {
      map_cr = false,
      map_c_h = true,
      map_c_w = true,
      enable_bracket_in_quote = false,
      ignored_next_char = '[^])}> ]',
    }

    local cmp_autopairs = require 'nvim-autopairs.completion.cmp'
    local ok, cmp = pcall(require, 'cmp')
    if ok then cmp.event:on('confirm_done', cmp_autopairs.on_confirm_done()) end

    -- add_char_after_closing_bracket_completed_by_cr のための準備
    local function prepare_adding_char()
      vim.b.bracket_cr_done = true
      return true
    end
    npairs.add_rules {
      npairs.get_rule('('):with_cr(prepare_adding_char),
      npairs.get_rule('{'):with_cr(prepare_adding_char),
      npairs.get_rule('['):with_cr(prepare_adding_char),
    }

    local group_oc = vim.api.nvim_create_augroup('AutoPairsObserveComma', {})
    local function observe_after_cr_done(bufnr)
      vim.api.nvim_clear_autocmds { group = group_oc, buffer = bufnr }
      vim.api.nvim_create_autocmd({
        'InsertLeave',
        'TextChangedI',
        'CursorMovedI',
      }, {
        callback = function()
          vim.b.bracket_cr_done = false
          vim.api.nvim_clear_autocmds { group = group_oc, buffer = bufnr }
        end,
        group = group_oc,
        buffer = bufnr,
      })
    end

    local group_cd = vim.api.nvim_create_augroup('AutoPairsCrDone', {})
    vim.api.nvim_clear_autocmds { group = group_cd, buffer = vim.fn.bufnr() }
    vim.api.nvim_create_autocmd('TextChangedI', {
      callback = function()
        if vim.b.bracket_cr_done then observe_after_cr_done(vim.fn.bufnr()) end
      end,
      group = group_cd,
    })

    local function add_char_after_closing_bracket_completed_by_cr(char)
      if vim.b.bracket_cr_done then
        -- n is the absolute row number of the next row (0-base)
        local n = vim.api.nvim_win_get_cursor(0)[1]
        local next_line_content =
          vim.api.nvim_buf_get_lines(0, n, n + 1, false)[1]
        if next_line_content then
          vim.api.nvim_buf_set_lines(
            0,
            n,
            n + 1,
            true,
            { next_line_content .. char }
          )
        end
      else
        feedkeys(char, 'in')
      end
    end

    vim.keymap.set(
      'i',
      '<Plug>(autopairs-comma)',
      function() add_char_after_closing_bracket_completed_by_cr ',' end,
      { remap = true }
    )
    vim.keymap.set(
      'i',
      '<Plug>(autopairs-semicolon)',
      function() add_char_after_closing_bracket_completed_by_cr ';' end,
      { remap = true }
    )
  end,
}
