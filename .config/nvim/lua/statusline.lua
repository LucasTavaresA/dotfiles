-- gruvbox
local theme = {
  bg = '#000000',
  fg = '#ffffff',
  red = '#ff0000',
  lightgreen = '#00ff00',
  green = '#009900',
  yellow = '#ffff00',
  lightblue = '#0077ff',
  pink = '#ff00ff',
  cyan = '#00ffff',
  orange = '#ff5500',
  violet = '#9900ff',
}

local vi_mode_colors = {
  NORMAL = theme.orange,
  INSERT = theme.yellow,
  VISUAL = theme.lightblue,
  OP = theme.green,
  BLOCK = theme.lightblue,
  LINES = theme.lightblue,
  REPLACE = theme.red,
  ['V-REPLACE'] = theme.red,
  ENTER = theme.yellow,
  MORE = theme.pink,
  SELECT = theme.lightblue,
  COMMAND = theme.violet,
  SHELL = theme.green,
  TERM = theme.green,
  NONE = theme.cyan
}

local vi_mode_utils = require('feline.providers.vi_mode');

-- My components
local comps = {
  separator = { provider = ' ' },
  vi_mode = {
    left = {
      provider = function()
        local label = '  ' .. vi_mode_utils.get_vim_mode() .. ' 🭅'
        return label
      end,
      hl =
      function()
        local set_color = {
          name = vi_mode_utils.get_mode_highlight_name(),
          fg = theme.bg,
          bg = vi_mode_utils.get_mode_color(),
          style = 'bold'
        }
        return set_color
      end,
    }
  },
  macro = {
    provider = { name = 'macro' },
    hl = { bold = true, fg = theme.red },
    left_sep = ' ',
  },
  search_count = {
    provider = { name = 'search_count' },
    hl = { fg = theme.lightgreen },
    left_sep = ' ',
  },
  file = {
    info = {
      provider = {
        name = 'file_info',
        opts = {
          type = 'relative',
          file_modified_icon = ''
        }
      },
      hl = { fg = theme.lightgreen },
      icon = '',
    },
  },
  diagnos = {
    err = {
      provider = 'diagnostic_errors',
      icon = '⚠ ',
      hl = { fg = theme.red },
    },
    warn = {
      provider = 'diagnostic_warnings',
      icon = ' ',
      hl = { fg = theme.yellow },
    },
    info = {
      provider = 'diagnostic_info',
      icon = ' ',
      hl = { fg = theme.lightblue },
    },
    hint = {
      provider = 'diagnostic_hints',
      icon = ' ',
      hl = { fg = theme.cyan },
    },
  },
  git = {
    branch = {
      provider = 'git_branch',
      icon = ' ',
      hl = { fg = theme.bg, bg = theme.pink, style = 'bold' },
      left_sep = '🭅',
      right_sep = '🭡',
    },
    add = {
      provider = 'git_diff_added',
      icon = '+',
      hl = { fg = theme.green, style = 'bold' },
    },
    change = {
      provider = 'git_diff_changed',
      icon = '~',
      hl = { fg = theme.yellow, style = 'bold' },
    },
    remove = {
      provider = 'git_diff_removed',
      icon = '-',
      hl = { fg = theme.red, style = 'bold' },
    }
  }
}

local components = {
  active = {},
  inactive = {},
}

table.insert(components.active, {})
table.insert(components.active, {})
table.insert(components.active, {})
table.insert(components.inactive, {})
table.insert(components.inactive, {})
table.insert(components.inactive, {})

-- Right section
table.insert(components.active[1], comps.vi_mode.left)
table.insert(components.active[1], comps.search_count)
table.insert(components.active[1], comps.macro)

-- Center
table.insert(components.active[2], comps.diagnos.err)
table.insert(components.active[2], comps.separator)
table.insert(components.active[2], comps.diagnos.warn)
table.insert(components.active[2], comps.separator)
table.insert(components.active[2], comps.diagnos.hint)
table.insert(components.active[2], comps.separator)
table.insert(components.active[2], comps.diagnos.info)

-- Left Section
table.insert(components.active[3], comps.git.add)
table.insert(components.active[3], comps.separator)
table.insert(components.active[3], comps.git.change)
table.insert(components.active[3], comps.separator)
table.insert(components.active[3], comps.git.remove)
table.insert(components.active[3], comps.separator)
table.insert(components.active[3], comps.git.branch)
table.insert(components.active[3], comps.separator)
table.insert(components.active[3], comps.file.info)
table.insert(components.inactive[3], comps.file.info)
table.insert(components.active[3], comps.separator)

require('feline').setup {
  default_bg = theme.bg,
  theme = {
    bg = theme.bg,
    fg = theme.fg
  },
  components = components,
  vi_mode_colors = vi_mode_colors,
  force_inactive = {
    filetypes = {
      'NvimTree',
      'vista',
      'term'
    },
    buftypes = {},
    bufnames = {},
  },
}
