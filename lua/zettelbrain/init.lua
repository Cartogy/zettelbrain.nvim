local Template = require('zettelbrain.zettel_template')
local header_template = {'title','tags','ID'}

local M = {}

local uniqueId = function(args)
    local file_name = ""
    if args == nil then
        --file_name = vim.api.nvim_exec("echo strftime('%Y-%m-%d-%H%M%S').'.md'", true)
        file_name = vim.api.nvim_exec("echo strftime('%Y-%m-%d-%H%M%S')", true)
    else
        file_name = args
    end

    return file_name
end

local zettelFilepath = function(filename)
    local current_directory = vim.api.nvim_exec("echo expand('%:p:h')", true)

    return current_directory
end


M.mkzettel = function(desc_name, args)

    local file_name = uniqueId(args)
--    vim.cmd("echo strftime('%c')")
--
-- local file_name = vim.cmd("echo strftime('%Y-%m-%d-%H%M%S').'.md'")
    -- :p gets the full path
    local current_directory = zettelFilepath(file_name)
    
    -- Place zettel tag
    vim.api.nvim_put({'['..desc_name..']('..file_name..'.md)'},'c', false, true)

    -- Create window 
    vim.cmd(":vsplit "..current_directory.."/"..file_name..".md")

    -- Get template text
    local template_info = Template.create_template(desc_name, file_name)
    local template_text = Template.generateTemplate(header_template, template_info)


    -- place template text in zettel
    local bufnr = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_set_lines(bufnr,0,0, false, template_text)
end

M.setup = function()
end

vim.api.nvim_create_user_command("ZettelNew", function(args)
    -- Allow for custom id AND description
    if #args['fargs'] == 2 then

        local desc_name = args['fargs'][1]
        local custom_id = args['fargs'][2]

        M.mkzettel(desc_name, custom_id)

    -- Allow only description
    elseif #args['fargs'] == 1 then

        local desc_name = args['fargs'][1]
        M.mkzettel(desc_name,nil)

    else
        print("ERROR: Too many arguments")
    end

end, {nargs='+'})

vim.api.nvim_create_user_command("ZettelTest", function(args)
    vim.api.nvim_put({'test'}, 'c', false, true)

end, {})


return M
