local actions = require("telescope.actions")
local action_layout = require("telescope.actions.layout")
local custom_actions = {}

require"telescope".setup({
  defaults = {
    sorting_strategy = 'ascending',
    cache_picker = {
      num_pickers = 1, -- default
      limit_entries = 1000, --default
    },
    layout_strategy = 'horizontal',
    layout_config = {
      horizontal = {
        prompt_position = 'top',
      }
    },
  },
  mappings = {
    i = {
      ["<Tab>"] = actions.toggle_selection + actions.move_selection_next,
      ["<C-l>"] = action_layout.toggle_preview,
      ["<C-q>"] = actions.send_selected_to_qflist,
      ["<C-g>"] = custom_actions.multi_selection_open,
      ["<CR>"] = actions.select_default + actions.center,
    },
    file_ignore_patterns = {},
  },

  extensions = {
    fzf = {
      fuzzy = true,                    -- false will only do exact matching
      override_generic_sorter = true,  -- override the generic sorter
      override_file_sorter = true,     -- override the file sorter
      case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                                       -- the default case_mode is "smart_case"
    },
    frecency = {
      db_root = os.getenv('XDG_STATE_HOME')..'/nvim',
      default_workspace = 'CWD',
      ignore_patterns = {
        "*.git/*",
        "*/tmp/*",
        "*/node_modules/*",
        "*/vendor/*",
      },
      show_scores = true,
      db_safe_mode = false,
      auto_validate = true,
    },
  },
})