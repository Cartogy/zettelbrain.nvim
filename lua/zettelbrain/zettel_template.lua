
local M = {}

M.create_template = function(desc_name, p_id)
    local tbl = {
        title = desc_name,
        tags = {},
        ID = p_id
    }

    return tbl
end

M.get_title = function(template)
    return tbl['title']
end

M.get_id = function(template)
    return tbl['id']
end

M.get_tags = function(template)
    return tbl['tags']
end

M.generateTemplate = function(header_template, info_template)
    local template_line = {}
    -- Start
    table.insert(template_line,"---")

    -- Build template string
    for _,header in pairs(header_template) do
        local current_line = ""

        if type(info_template[header]) == 'table' then -- A list
            current_line = current_line..header..": ["

            -- Iterate to add elements
            for _,elem in pairs(info_template[header]) do
                current_line = current_line..'"'..elem..'",'
            end

            current_line = current_line.."]"

        else    -- Single Element
            print(vim.inspect(info_template))
            print(vim.inspect(header))

            -- add header info
            current_line = current_line..header..": " 
            -- add value
            current_line = current_line..info_template[header]
        end
        table.insert(template_line, current_line)
    end

    -- End
    table.insert(template_line,"---")

    return template_line

end

return M
