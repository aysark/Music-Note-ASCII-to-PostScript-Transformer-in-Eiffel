note
  description: "Objects that transform tablature input to PostScript"
  author: "Aysar Khalid"
  date: "???"
  version: "1.0"

class TAB2PS
  inherit TRANSFORMER

create make


--------------------------------------------------------------------------------
feature {NONE} -- Initialization
pslib :PS_LIB
config :SETTINGS

execute
local
    doc : STRING
    input_title : STRING
    input_subtitle : STRING

    -- file io
    output : PLAIN_TEXT_FILE
    input : PLAIN_TEXT_FILE
    internal : ARRAY[CHARACTER]
    i, j : INTEGER
  do
  		create pslib
  		create config.make
		io.putstring ("Reading file...%N")

		create input.make_open_read(input_filename)
		create output.make_open_write(output_filename)
		create internal.make(1,1000)

		from input.start ; input.read_character ; i := 0
        until input.off
        loop
          io.putchar(input.last_character)
          i := i + 1
          internal.put(input.last_character,i)
          input.read_character
        end

        doc := pslib.preamble (input_title,input_subtitle,config.left_margin)

        input.close

		doc := doc + pslib.trailer (config.left_margin)
		output.put_string (doc)
        output.close
        io.putstring ("Wrote to output file...%N")
  end

end
