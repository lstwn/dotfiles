local M = {}

M.modes = {}
M.modes.normal = { long_name = 'Normal', short_name = 'N' }
M.modes.normal_pending = { long_name = 'N-Pending', short_name = 'N-P' }
M.modes.visual = { long_name = 'Visual', short_name = 'V' }
M.modes.visual_line = { long_name = 'V-Line', short_name = 'V-L' }
M.modes.visual_replace = { long_name = 'V-Replace', short_name = 'V-R' }
M.modes.visual_block = { long_name = 'V-Block', short_name = 'V-B' }
M.modes.select = { long_name = 'Select', short_name = 'S' }
M.modes.select_line = { long_name = 'S-Line', short_name = 'S-L' }
M.modes.select_block = { long_name = 'S-Block', short_name = 'S-B' }
M.modes.insert = { long_name = 'Insert', short_name = 'I' }
M.modes.replace = { long_name = 'Replace', short_name = 'R' }
M.modes.command = { long_name = 'Command', short_name = 'C' }
M.modes.vim_ex = { long_name = 'Vim-Ex', short_name = 'V-E' }
M.modes.ex = { long_name = 'Ex', short_name = 'E' }
M.modes.prompt = { long_name = 'Prompt', short_name = 'P' }
M.modes.more = { long_name = 'More', short_name = 'M' }
M.modes.confirm = { long_name = 'Confirm', short_name = 'C' }
M.modes.shell = { long_name = 'Shell', short_name = 'SH' }
M.modes.terminal = { long_name = 'Terminal', short_name = 'T' }

local modes = nil
local function resolve_modes()
    if modes == nil then
        modes = setmetatable({
            -- LuaFormatter off
            ['n']  = M.modes.normal,
            ['no'] = M.modes.normal_pending,
            ['v']  = M.modes.visual,
            ['V']  = M.modes.visual_line,
            ['']  = M.modes.visual_block,
            ['s']  = M.modes.select,
            ['S']  = M.modes.select_line,
            ['']  = M.modes.select_block,
            ['i']  = M.modes.insert,
            ['ic'] = M.modes.insert,
            ['R']  = M.modes.replace,
            ['Rv'] = M.modes.visual_replace,
            ['c']  = M.modes.command,
            ['cv'] = M.modes.vim_ex,
            ['ce'] = M.modes.ex,
            ['r']  = M.modes.prompt,
            ['rm'] = M.modes.more,
            ['r?'] = M.modes.confirm,
            ['!']  = M.modes.shell,
            ['t']  = M.modes.terminal
            -- LuaFormatter on
        }, {
            __index = function(_, key)
                print("Unknown mode '" .. key .. "'")
                return { id = 'U', long_name = 'Unknown', short_name = 'U' }
            end
        })
    end
    return modes
end

M.current_mode = function() return resolve_modes()[vim.fn.mode()] end

M.git_branch = function()
    local branch = vim.fn.system("git branch --show-current 2> /dev/null | tr -d '\n'")
    if branch ~= "" then
        return branch
    end
    return nil
end


return M
