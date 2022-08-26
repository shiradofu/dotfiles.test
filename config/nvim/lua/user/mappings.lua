-- stylua: ignore start
local util = require 'user.util'
local win = require 'user.win'
local function k(mode, lhs, rhs, ...)
  local opts = { silent = true }
  if select('#', ...) > 0 then
    opts = vim.tbl_extend('force', { silent = true }, ...)
  end
  vim.keymap.set(mode, lhs, rhs, opts)
end

local S = { silent = false }
local r = { remap = true }
local b = { buffer = true }
local e = { expr = true }

local M = {}

vim.g.mapleader = ' '

function M.misc()
  k('n', '<Leader>w', '<Cmd>w<CR>')
  k('n', '<Leader>W', '<Cmd>wall<CR>')
  k('n', '<Leader>q', '<Cmd>botright copen<CR>')
  k('n', '<BS>', win.close)
  k('n', '<Del>', '<Cmd>bp<bar>sp<bar>bn<bar>bd<CR>')
  k('n', 'g<BS>', '<Cmd>call user#win#tabclose()<CR>')
  k('n', 'gy', "<Cmd>let @+=expand('%')<CR>")
  k('n', 'gY', "<Cmd>let @+=expand('%:p')<CR>'%')<CR>")
  k('n', 'zp', '<Cmd>call print_debug#print_debug()<CR>')
  k('n', 'cl', '"_cl')
  k('n', 'ch', '"_ch')
  k('n', 'Y', 'y$', r)
  k('n', 'gh', '<Cmd>call user#win#focus_float()<CR>')
  k({'n', 'v'}, 'gx', '<Plug>(openbrowser-smart-search)')
  k({'n', 'v'}, 'gX', ':OpenGithubFile<CR>')
  k('n', '<Leader>-', require'user.readonly')
end
M.misc()

function M.fzf()
  local fzf = 'fzf-lua'
  k('n', '<Leader>o', function()require('plug.fzf-project-mru')()end)
  k('n', '<Leader>t', function()require('plug.fzf-templates')()end)
  k('n', '<Leader>i', function()require(fzf).files{fd_opts = util.fzf_fd_noignore}end)
  k('n', '<Leader>u', function()require(fzf).git_status()end)
  k('n', '<Leader>f', function()require(fzf).live_grep_resume()end)
  k('n', '<Leader>F', function()require(fzf).live_grep_resume{rg_opts = util.fzf_rg_noignore}end)
  k('v', '<Leader>f', function()require(fzf).grep_visual()end)
  k('v', '<Leader>F', function()require(fzf).grep_visual{rg_opts = util.fzf_rg_noignore}end)
  k('n', '<Leader>g', function()require(fzf).grep_cword()end)
  k('n', '<Leader>G', function()require(fzf).grep_cword{rg_opts = util.fzf_rg_noignore}end)
  k('n', '<Leader>y', function()require(fzf).lsp_document_symbols()end)
  k('n', '<Leader>:', function()require(fzf).command_history()end)
  k('n', '<Leader>e', function()require(fzf).lsp_workspace_diagnostics()end)
end
M.fzf()

function M.diffview()
  k('n', '<Leader>d', '<Cmd>DiffviewOpen -- %<CR>')
  -- k('n', '<Leader>s', "<Cmd>call user#win#goto_or('Git status', 'DiffviewOpen')<CR>")
  k('n', '<Leader>s', function()win.reuse('is_git_status', 'DiffviewOpen')end)
  k('n', '<Leader>S', '<Cmd>DiffviewOpen main<CR>')
  k('n', '<Leader>h', '<Cmd>DiffviewFileHistory %<CR>')
  k('v', '<Leader>h', ':DiffviewFileHistory<CR>')
  k('n', '<Leader>H', '<Cmd>DiffviewFileHistory<CR>')
end
M.diffview()

function M.door2note()
  k('n', '<Leader>n', '<Cmd>Door2NoteOpen<CR>')
end
M.door2note()

function M.fern()
  k('n', '<Leader>r', '<Cmd>Fern . -reveal=%<CR>')
  k('n', '<Leader><C-r>', '<Cmd>vs<CR><Cmd>Fern . -reveal=%<CR>')
end
M.fern()

function M.git()
  k('n', '<Leader>,', function()require'user.git'.commit()end)
  k('n', '<Leader>.', function()require'user.git'.push()end)
end
M.git()

function M.neotest()
  local m = 'neotest'
  k('n', '<Leader>j', function()require(m).run.run()end)
  k('n', '<Leader>J', function()require(m).run.run(vim.fn.expand '%')end)
  k('n', '<Leader><C-j>', function()require(m).summary.toggle()end)
end
M.neotest()

function M.lsp_diagnostic()
  local n = 'nice-scroll'
  k('n', '[e', function() require(n).hook(vim.diagnostic.goto_prev)end)
  k('n', ']e', function() require(n).hook(vim.diagnostic.goto_next)end)
end
function M.lsp_jump()
  k('n', 'gd', vim.lsp.buf.definition, b)
  k('n', 'gD', '<Cmd>vs|lua vim.lsp.buf.definition()<CR>', b)
  k('n', 'gr', vim.lsp.buf.references, b)
end
function M.lsp_format(fn)
  k('n', '=', fn, b)
  k('n', '<Leader>=', '<Cmd>AutoFormatToggleGlobal<CR>')
end
local hover = require 'user.lsp-hover'
function M.lsp_hover()
  k('n', 'K', hover, b)
end
function M.lsp_rename() k('n', 'gn', vim.lsp.buf.rename, b) end
function M.lsp_action() k('n', 'ga', vim.lsp.buf.code_action, b) end

function M.tab_move()
  k('n', '<C-n>', 'gt')
  k('n', '<C-p>', 'gT')
  k('n', 'go', '<Cmd>call user#win#move(v:count)<CR>')
end
M.tab_move()

function M.win_move()
  k('n', '<C-h>', '<C-w>h')
  k('n', '<C-j>', '<C-w>j')
  k('n', '<C-k>', '<C-w>k')
  k('n', '<C-l>', '<C-w>l')
end
M.win_move()

function M.win_resize()
  k('n', '<C-w><C-h>', "<Cmd>call user#win#resize('h')<CR><Plug>(wr)", r)
  k('n', '<C-w><C-j>', "<Cmd>call user#win#resize('j')<CR><Plug>(wr)", r)
  k('n', '<C-w><C-k>', "<Cmd>call user#win#resize('k')<CR><Plug>(wr)", r)
  k('n', '<C-w><C-l>', "<Cmd>call user#win#resize('l')<CR><Plug>(wr)", r)
  k('n', '<Plug>(wr)<C-h>', "<Cmd>call user#win#resize('h')<CR><Plug>(wr)", r)
  k('n', '<Plug>(wr)<C-j>', "<Cmd>call user#win#resize('j')<CR><Plug>(wr)", r)
  k('n', '<Plug>(wr)<C-k>', "<Cmd>call user#win#resize('k')<CR><Plug>(wr)", r)
  k('n', '<Plug>(wr)<C-l>', "<Cmd>call user#win#resize('l')<CR><Plug>(wr)", r)
  k('n', '<Plug>(wr)', '<Nop>', r)
  k('n', '<C-g>', '<Cmd>ZenMode<CR>')
end
M.win_resize()

function M.motion()
  local n = 'nice-scroll'
  k({'n', 'x'}, ';',  '<Cmd>Pounce<CR>')
  k({'n', 'x'}, '*',  "<Plug>(asterisk-z*):<C-u>lua require('hlslens').start()<CR>")
  k({'n', 'x'}, 'g*', "<Plug>(asterisk-gz*):<-u>lua require('hlslens').start()<CR>")
  k({'n', 'x'}, '#',  "<Plug>(asterisk-z#):<C-u>lua require('hlslens').start()<CR>")
  k({'n', 'x'}, 'g#', "<Plug>(asterisk-gz#):<C-u>lua require('hlslens').start()<CR>")
  k('n', ']q', function()require(n).hook('<Cmd>cnext<CR>', { countable = true })end)
  k('n', '[q', function()require(n).hook('<Cmd>cprev<CR>', { countable = true })end)
  k('n', 'g;', function()require(n).hook('g;', { countable = true })end)
  k('n', 'g,', function()require(n).hook('g,', { countable = true })end)
  k('n', 'n',  function()require(n).hook('n')end)
  k('n', 'N',  function()require(n).hook('N')end)
  k('n', 'zh', function()require(n).adjust()end)
  k('n', 'zl', function()require(n).adjust('r')end)
end
M.motion()

function M.treesitter()
  return {
    textobjects = {
        ['af'] = '@function.outer',
        ['if'] = '@function.inner',
    },
    motion = {
      next = {
        [']f'] = '@function.outer',
        [']]'] = '@class.outer',
      },
      prev =  {
        ['[f'] = '@function.outer',
        ['[['] = '@class.outer',
      },
    }
  }
end

function M.gitsigns(gitsigns)
  k('n', ']c', function()
    if vim.wo.diff then return ']c' end
    vim.schedule(function()gitsigns.next_hunk()end)
    return '<Ignore>'
  end, e)
  k('n', '[c', function()
    if vim.wo.diff then return '[c' end
    vim.schedule(function()gitsigns.prev_hunk()end)
    return '<Ignore>'
  end, e)
  k({'n', 'v'}, 'g<', ':Gitsigns stage_hunk<CR>')
  k('n', 'g>', gitsigns.undo_stage_hunk)
  k({ 'o', 'x' }, 'ig', ':<C-u>Gitsigns select_hunk<CR>')
  k({ 'o', 'x' }, 'ag', ':<C-u>Gitsigns select_hunk<CR>')
  k('n', '<leader>b', gitsigns.toggle_current_line_blame)
end

function M.clever_f()
  k({'n', 'x', 'o'}, 'f', '<Plug>(clever-f-f)')
  k({'n', 'x', 'o'}, 'F', '<Plug>(clever-f-F)')
  k({'x', 'o'},      't', '<Plug>(clever-f-t)')
  k({'x', 'o'},      'T', '<Plug>(clever-f-T)')
end
M.clever_f()

function M.quickhl()
  k('n', 'gl',     '<Plug>(quickhl-manual-this-whole-word)')
  k('x', 'gl',     '<Plug>(quickhl-manual-this)')
  k('n', 'gL',     '<Plug>(quickhl-manual-reset)')
  k('n', 'g<C-l>', '<Plug>(quickhl-cword-toggle)')
end
M.quickhl()

function M.luasnip()
  local mod = 'luasnip'
  k({ 'i', 's' }, '<C-j>', function() require(mod).jump(1) end)
  k({ 'i', 's' }, '<C-k>', function()
    if require(mod).jumpable(-1) then
      require(mod).jump(-1)
    else
      util.feedkeys('<C-o>D', 'in')
    end
  end)
end
-- M.luasnip() --

function M.cmp_selection(cmp)
  return {
    ['<Tab>'] = cmp.mapping.confirm { select = true },
    ['<C-n>'] = function(fallback)
      if cmp.visible() then
        if cmp.core.view.custom_entries_view:is_direction_top_down() then
          cmp.select_next_item()
        else
          cmp.select_prev_item()
        end
      else
        fallback()
      end
    end,
    ['<C-p>'] = function(fallback)
      if cmp.visible() then
        if cmp.core.view.custom_entries_view:is_direction_top_down() then
          cmp.select_prev_item()
        else
          cmp.select_next_item()
        end
      else
        fallback()
      end
    end,
    ['<C-l>'] = cmp.mapping.abort(),
  }
end
-- M.cmp_selection() --

function M.textcase()
  local mod = 'textcase'
  k('n', 'gc', '<Nop>')
  for mode, fn in pairs { n = 'current_word', x = 'visual' } do
    k(mode, 'gcu', function() require(mod)[fn]('to_upper_case')end)
    k(mode, 'gcl', function() require(mod)[fn]('to_lower_case')end)
    k(mode, 'gcc', function() require(mod)[fn]('to_camel_case')end)
    k(mode, 'gcs', function() require(mod)[fn]('to_snake_case')end)
    k(mode, 'gck', function() require(mod)[fn]('to_dash_case')end)
    k(mode, 'gcn', function() require(mod)[fn]('to_constant_case')end)
    k(mode, 'gcd', function() require(mod)[fn]('to_dot_case')end)
    k(mode, 'gcp', function() require(mod)[fn]('to_pascal_case')end)
  end
end
M.textcase()

function M.substitute()
  k('n', 't', function()require('substitute').operator()end)
  k('x', 'T', function()require('substitute').visual()end)
  k('n', 'T', function()require('substitute').eol()end)
  k('n', 'X', function()require('substitute.exchange').operator()end)
  k('x', 'X', function()require('substitute.exchange').visual()end)
  k('n', 'XX',function()require('substitute.exchange').cancel()end)
end
M.substitute()

function M.sandwich()
  k({'n', 'x', 'o'}, 'gs', '<Plug>(sandwich-add)')
  k('n', 'ds', '<Plug>(sandwich-delete)')
  k('n', 'cs', '<Plug>(sandwich-replace)')
end
M.sandwich()

function M.autopairs()
  k('i', ',', '<Cmd>call plug#autopairs#comma()<CR>')
  k('i', ';', '<Cmd>call plug#autopairs#semi()<CR>')
end
M.autopairs()

function M.newline()
  k('n', 'o', "o<Cmd>lua require('user.newline').next()<CR>")
  k('n', 'O', "O<Cmd>lua require('user.newline').prev()<CR>")
  k('i', '<CR>', function()
    local p = require('nvim-autopairs').autopairs_cr()
    return p .. "<Cmd>lua require('user.newline').next()<CR>"
  end, e)
end
M.newline()

function M.neogen()
  k('n', 'ss', '<Cmd>Neogen<CR>')
end
M.neogen()

function M.commentary()
  -- invert selected comments
  k('x', 'S', function ()
    vim.cmd[[exe "normal! \<Esc>"]]
    local v_start = vim.fn.getpos("'<")[2]
    local v_end = vim.fn.getpos("'>")[2]
    if v_start > v_end then
      v_start, v_end = v_end, v_start
    end
    for i = v_start, v_end do
      vim.cmd(string.format('normal! %dG', i))
      local ctx = require('ts_context_commentstring.internal')
      pcall(ctx.update_commentstring)
      vim.cmd[[Commentary]]
    end
  end)

  return {
    Commentary = 's',
    CommentaryUndo = 'S',
    CommentaryLine = false,
    ChangeCommentary = false,
  }
end

function M.insert_ctrl()
  k('!', '<C-b>', '<Left>',  S)
  k('!', '<C-f>', '<Right>', S)
  k('!', '<C-a>', '<Home>',  S)
  k('!', '<C-e>', '<End>',   S)
  k('!', '<C-d>', '<Del>',   S)
  k('!', '<C-y>', '<C-r>+',  S)
  k('i', '<C-n>', '<Down>',  S)
  k('i', '<C-p>', '<Up>',    S)
  k('c', '<C-j>', '<Down>',  S)
  k('c', '<C-k>', '<Up>',    S)
  k('c', '<C-x>', "<C-r>=expand('%:p')<CR>", S)
  k('s', '<BS>', '<BS>i')
  k('s', '<C-h>', '<C-h>i')
end
M.insert_ctrl()

function M.fern_local()
  k('n', '<BS>',  win.close,                             b)
  k('n', '<C-c>', '<Plug>(fern-action-cancel)',          b)
  k('n', 'yy',    '<Plug>(fern-action-clipboard-copy)',  b)
  k('n', 'Y',     '<Plug>(fern-action-clipboard-copy)',  b)
  k('n', 'cc',    '<Plug>(fern-action-clipboard-move)',  b)
  k('n', 'C',     '<Plug>(fern-action-clipboard-move)',  b)
  k('n', 'p',     '<Plug>(fern-action-clipboard-paste)', b)
  k('n', 'h',     '<Plug>(fern-action-collapse)',        b)
  k('n', 'D',     '<Plug>(fern-action-copy)',            b)
  k('n', 'gu',    '<Plug>(fern-action-leave)',           b)
  k('n', 'v',     '<Plug>(fern-action-mark)',            b)
  k('n', 'v',     '<Plug>(fern-action-mark)',            b)
  k('n', '<C-c>', '<Plug>(fern-action-mark:clear)',      b)
  k('n', '<Esc>', '<Plug>(fern-action-mark:clear)',      b)
  k('n', 'o',     '<Plug>(fern-action-new-path)',        b)
  k('n', '<CR>',  '<Plug>(fern-action-open-or-enter)',   b)
  k('n', 'l',     '<Plug>(fern-action-open-or-expand)',  b)
  k('n', 'i',     '<Plug>(fern-action-open)',            b)
  k('n', '<C-r>', '<Plug>(fern-action-reload)',          b)
  k('n', 'dd',    '<Plug>(fern-action-remove)',          b)
  k('n', 'r',     '<Plug>(fern-action-rename)',          b)
  k('n', '<C-v>', '<Plug>(fern-action-open:vsplit)',     b)
  k('n', '<C-x>', '<Plug>(fern-action-open:split)',      b)
  k('n', '<C-t>', '<Plug>(fern-action-open:tabedit)',    b)
  k('n', 'gy',    '<Plug>(fern-action-yank:label)',      b)
  k('n', 'gY',    '<Plug>(fern-action-yank:bufname)',    b)

  local fzf_fern = require 'plug.fzf-fern'
  k('n', '<Leader>f', function()fzf_fern()end, b)
  k('n', '<Leader>F', function()fzf_fern(true)end, b)
end

function M.bqf()
  return {
    open = 'l',
    openc = '<CR>',
    tab = 't',
    tabc = '<C-t>',
    split = '<C-x>',
    vsplit = '<C-v>',
    prevfile = '<C-p>',
    nextfile = '<C-n>',
    stogglevm = '<Tab>',
    pscrollup = '<C-y>',
    pscrolldown = '<C-e>',
    ptogglemode = '<C-g>',
    ptoggleitem = '',
    ptoggleauto = 'p',
  }
end

function M.ft_quickfix()
  k('n', 'dd', '<Cmd>call user#quickfix#del()<CR>', b)
  k('n', 'u',  '<Cmd>call user#quickfix#undo_del()<CR>', b)
  k('n', 'R',  '<Cmd>Qfreplace topleft split<CR>', b)
  k('n', 'F',  '<Cmd>FzfLua quickfix<CR>', b)
  -- k('n', '<C-g>', '<Nop>', b)
end
local qf = vim.api.nvim_create_augroup('MapQuickfix', {})
vim.api.nvim_create_autocmd('FileType',
  { group = qf, pattern = 'qf', callback = M.ft_quickfix })

function M.ft_markdown()
  k('n', '<Leader><CR>', '<Plug>MarkdownPreviewToggle', b)
  k('n', 'sh', '<Cmd>call plug#checkbox#toggle()<CR>', b)
  k('i', '<C-x>', '<Cmd>call plug#checkbox#toggle()<CR>', b)
end
local markdown = vim.api.nvim_create_augroup('MapMarkdown', {})
vim.api.nvim_create_autocmd('FileType',
  { group = markdown, pattern = 'markdown', callback = M.ft_markdown })

function M.ft_http()
  k('n', '<Leader><CR>', '<Plug>RestNvim', b)
end
local http = vim.api.nvim_create_augroup('MapHttp', {})
vim.api.nvim_create_autocmd('FileType',
  { group = http, pattern = 'http', callback = M.ft_http })

return M
