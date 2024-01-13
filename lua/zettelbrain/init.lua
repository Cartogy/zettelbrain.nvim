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

-- Creates a file with the text.
local mkzettel = function(text, uniqueId)
    -- :p gets the full path
    local current_directory = zettelFilepath(uniqueId)
    
    -- Place zettel tag
    vim.api.nvim_put({'['..desc_name..']('..uniqueId..'.md)'},'c', false, true)

    -- Create window 
    vim.cmd(":vsplit "..current_directory.."/"..uniqueId..".md")

    local bufnr = vim.api.nvim_get_current_buf()
    vim.api.nvim_buf_set_lines(bufnr,0,0, false, text)
end

M.mkzettel_generic = function(desc_name, args)
    local file_name = uniqueId(args)

    -- Get template text
    local template_info = Template.create_template(desc_name, file_name)
    local template_text = Template.generateTemplate(header_template, template_info)

    mkzettel(template_text, file_name)
end


M.setup = function()
end

vim.api.nvim_create_user_command("ZettelNew", function(args)
    -- Allow for custom id AND description
    if #args['fargs'] == 2 then

        local desc_name = args['fargs'][1]
        local custom_id = args['fargs'][2]

        M.mkzettel_generic(desc_name, custom_id)

    -- Allow only description
    elseif #args['fargs'] == 1 then

        local desc_name = args['fargs'][1]
        M.mkzettel_generic(desc_name,nil)

    else
        print("ERROR: Too many arguments")
    end

end, {nargs='+'})

vim.api.nvim_create_user_command("ZettelTest", function(args)
    vim.api.nvim_put({'test'}, 'c', false, true)

end, {})

vim.api.nvim_create_user_command("ZettelBrain", function(args)
    vim.cmd(":vsplit")
    vim.cmd(":execute 'normal ,ww'")
end, {})


return M
