local Util = require("zettelbrain.util")

local strarr_to_table = function(arr)
    return vim.fn.trim(arr,"[]")
end


local create_chapter_metadata = function(chapter_name)
    local metadata_table = Util.get_metadata()

    local chapter_metadata = {}
    -- remove any whitespace
    local tags = vim.fn.trim(metadata_table["tags"], " ")
    local end_len = vim.fn.len(tags)
    -- remove '[' and ']' from the start and end of string.
    local str_tags = string.sub(tags,2,end_len-1)
    -- append chapter

    local final_tags = ''
    if str_tags == '' then
        -- dont' include comma ','
        final_tags = "[" .. str_tags .. "chapter" .. "]"
    else
        -- include comma ','
        final_tags = "[" .. str_tags .. ", chapter" .. "]"
    end

    chapter_metadata["book"] = metadata_table["title"]
    chapter_metadata["tags"] = final_tags
    chapter_metadata["id"] = Util.uniqueId(chapter_name)

    return chapter_metadata
end

vim.api.nvim_create_user_command("ZettelBookChapter", function(args)
    if #args['fargs'] ~= 1 then
        print("ERROR: Please enter Chapter name")
        return
    end

    local chapter_metadata = create_chapter_metadata(args[1])

    print(vim.inspect(chapter_metadata))

end, {nargs = "+"})
