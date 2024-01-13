local Util = require("zettelbrain.util")
local Template = require('zettelbrain.zettel_template')
local header_template = {'title','tags','ID'}

local M = {}

-- Generic zettel file.
M.mkzettel_generic = function(desc_name, args)
    local file_name = Util.uniqueId(args)

    -- Get template text
    local template_info = Template.create_template(desc_name, file_name)
    local template_text = Template.generateTemplate(header_template, template_info)

    Util.mkzettel(template_text, desc_name, file_name)
end

M.setup = function()
end

vim.api.nvim_create_user_command("ZettelNew", function(args)
    -- Allow for custom id AND description
    if #args['fargs'] == 2 then

        local desc_name = args['fargs'][1]
        print(desc_name)
        local custom_id = args['fargs'][2]

        M.mkzettel_generic(desc_name, custom_id)

    -- Allow only description
    elseif #args['fargs'] == 1 then

        local desc_name = args['fargs'][1]
        print(desc_name)
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
