-- fork of "blackCauldron7/surround.nvim"
return {
	"ur4ltz/surround.nvim",
	opts = {
		mappings_style = "sandwich",
	},
}

-- There are two keymap modes for normal mode mappings.

--     sandwich and surround and they can be set using the options mentioned below.

-- Normal Mode - Sandwich Mode

--     Provides key mapping to add surrounding characters.( visually select then press s<char> or press sa{motion}{char})
--     Provides key mapping to replace surrounding characters.( sr<from><to> )
--     Provides key mapping to delete surrounding characters.( sd<char> )
--     ss repeats last surround command. (Doesn't work with add)

-- Normal Mode - Surround Mode

--     Provides key mapping to add surrounding characters.( visually select then press s<char> or press ys{motion}{char})
--     Provides key mapping to replace surrounding characters.( cs<from><to> )
--     Provides key mapping to delete surrounding characters.( ds<char> )

-- Insert Mode

--     <c-s><char> will insert both pairs in insert mode.
--     <c-s><char><space> will insert both pairs in insert mode with surrounding whitespace.
--     <c-s><char><c-s> will insert both pairs on newlines insert mode.

-- IDK I was bored

--     Cycle surrounding quotes type. (stq)
--     Cycle surrounding brackets type. (stb)
--     Use <char> == f for adding, replacing, deleting functions.
