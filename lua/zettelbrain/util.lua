local M = {}

M.uniqueId = function(args)
    local file_name = ""
    if args == nil then
        --file_name = vim.api.nvim_exec("echo strftime('%Y-%m-%d-%H%M%S').'.md'", true)
        file_name = vim.api.nvim_exec("echo strftime('%Y-%m-%d-%H%M%S')", true)
    else
        file_name = args
    end

    print(file_name)

    return file_name
end

local metadata_info = function()
    vim.cmd("execute cursor(0,0)")

    -- the '---' can be in the current line.
    local start_metadata = vim.fn.search("---","c") + 1
    local end_metadata = vim.fn.search("---") - 1

    local metadata_info = vim.fn.getline(start_metadata, end_metadata)

    return metadata_info
end

local metadata_to_table = function(metadata)
    local data_table = {}
    for key, val in ipairs(metadata) do
        local splitted_val = vim.fn.split(val,":")
        -- get metadata information
        local info_key = vim.fn.trim(splitted_val[1], " ")
        local info_val = vim.fn.trim(splitted_val[2], " ")
        data_table[info_key] = info_val
        --local info_key = vim.fn.trim(splitted_val[0], " ")
        --print(info_key)
    end

    return data_table
end

M.get_metadata = function()
    return metadata_to_table(metadata_info())
end

return M
