local Util = require("zettelbrain.util")

local strarr_to_table = function(arr)
    return vim.fn.trim(arr,"[]")
end


local create_chapter_metadata = function(chapter_name)
    local metadata_table = Util.get_metadata()
    print("Metadata")
    print(vim.inspect(metadata_table))

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
        final_tags = "[" .. "chapter" .. "]"
    else
        -- include comma ','
        final_tags = "[" .. str_tags .. ", chapter" .. "]"
    end

    chapter_metadata[1] = {"title", chapter_name}
    chapter_metadata[2] = {"book", metadata_table["title"] }
    chapter_metadata[3] = {"tags", final_tags}
    chapter_metadata[4] = {"ID", Util.uniqueId() }

    return chapter_metadata
end

vim.api.nvim_create_user_command("ZettelBookChapter", function(args)
    if #args['fargs'] ~= 1 then
        print("ERROR: Please enter Chapter name")
        return
    end

    --
    local start_cursor = vim.api.nvim_win_get_cursor(0)

    local chapter_name = args['fargs'][1]
    local chapter_metadata = create_chapter_metadata(chapter_name)

    vim.api.nvim_win_set_cursor(0, start_cursor)

    local metadata_text = Util.metadata_to_string(chapter_metadata)

    local unique_id = chapter_metadata[4][2]
    Util.mkzettel(metadata_text, chapter_name,unique_id)

end, {nargs = "+"})
