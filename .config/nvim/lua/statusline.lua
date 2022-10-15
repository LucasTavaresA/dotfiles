-- gruvbox
local colors = {
    bg = '#282828',
    fg = '#fb4934',
    red = '#cc241d',
    green = '#98971a',
    yellow = '#979921',
    blue = '#459588',
    pink = '#b16286',
    cyan = '#689d6a',
    orange = '#a89984',
    violet = '#928374',
}

local vi_mode_colors = {
    NORMAL = colors.violet,
    INSERT = colors.yellow,
    VISUAL = colors.blue,
    OP = colors.cyan,
    BLOCK = colors.cyan,
    REPLACE = colors.red,
    ['V-REPLACE'] = colors.red,
    ENTER = colors.yellow,
    MORE = colors.pink,
    SELECT = colors.blue,
    COMMAND = colors.cyan,
    SHELL = colors.cyan,
    TERM = colors.green,
    NONE = colors.blue
}

local lsp = require('feline.providers.lsp')
local vi_mode_utils = require('feline.providers.vi_mode')

local lsp_get_diag = function(str)
    local count = vim.lsp, diagnostic.get_count(0, str)
    return (count > 0) and ' ' .. count .. ' ' or ''
end

-- My components
local comps = {
    vi_mode = {
        left = {
            provider = function()
                local label = ' ' .. vi_mode_utils.get_vim_mode() .. ' '
                return label
            end,
            hl = function()
                local set_color = {
                    name = vi_mode_utils.get_mode_highlight_name(),
                    fg = colors.bg,
                    bg = vi_mode_utils.get_mode_color(),
                    style = 'bold'
                }
                return set_color
            end,
            left_sep = ' ',
            right_sep = ' ',
        }
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
            hl = { fg = colors.cyan },
            icon = '  ',
            left_sep = ' ',
            right_sep = ' ',
        },
        type = {
            provider = { name = 'file_type' },
        },
        position = {
            provider = { name = 'position' },
            hl = {
                fg = colors.cyan,
                style = 'bold'
            },
            left_sep = ' ',
            right_sep = ' ',
        },
        scroll_bar = {
            provider = { name = 'scroll_bar' },
            hl = { fg = colors.green },
            left_sep = ' ',
            right_sep = ' ',
        },
    },
    -- LSP info
    diagnos = {
        err = {
            provider = 'diagnostic_errors',
            icon = ' ⚠ ',
            hl = { fg = colors.red },
            left_sep = ' ',
            right_sep = ' ',
        },
        warn = {
            provider = 'diagnostic_warnings',
            icon = '  ',
            hl = { fg = colors.yellow },
            left_sep = ' ',
            right_sep = ' ',
        },
        info = {
            provider = 'diagnostic_info',
            icon = '  ',
            hl = { fg = colors.green },
            left_sep = ' ',
            right_sep = ' ',
        },
        hint = {
            provider = 'diagnostic_hints',
            icon = '  ',
            hl = { fg = colors.cyan },
            left_sep = ' ',
            right_sep = ' ',
        },
    },
    -- git info
    git = {
        branch = {
            provider = 'git_branch',
            icon = '  ',
            hl = { fg = colors.pink },
            left_sep = ' ',
            right_sep = ' ',
        },
        add = {
            provider = 'git_diff_added',
            icon = '  ',
            hl = { fg = colors.green },
            left_sep = ' ',
            right_sep = ' ',
        },
        change = {
            provider = 'git_diff_changed',
            icon = '  ',
            hl = { fg = colors.orange },
            left_sep = ' ',
            right_sep = ' ',
        },
        remove = {
            provider = 'git_diff_removed',
            icon = '  ',
            hl = { fg = colors.red },
            left_sep = ' ',
            right_sep = ' ',
        }
    }
}

local components = {
    active = {},
    inactive = {},
}

table.insert(components.active, {})
table.insert(components.active, {})
table.insert(components.inactive, {})
table.insert(components.inactive, {})

-- Right section
table.insert(components.active[1], comps.vi_mode.left)

-- Left Section
table.insert(components.active[2], comps.git.branch)
table.insert(components.active[2], comps.git.add)
table.insert(components.active[2], comps.git.change)
table.insert(components.active[2], comps.git.remove)
table.insert(components.active[2], comps.diagnos.err)
table.insert(components.active[2], comps.diagnos.warn)
table.insert(components.active[2], comps.diagnos.hint)
table.insert(components.active[2], comps.diagnos.info)
table.insert(components.active[2], comps.file.info)
table.insert(components.inactive[2], comps.file.info)
table.insert(components.active[2], comps.file.position)

require('feline').setup {
    colors = {
        bg = colors.bg,
        fg = colors.fg
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
