note
  description: "Objects that transform tablature input to PostScript"
  author: "Aysar Khalid"
  date: "28.1.2012"
  version: "1.0"

class TAB2PS
  inherit TRANSFORMER

create make


--------------------------------------------------------------------------------
feature {NONE} -- Initialization
pslib :PS_LIB
config :SETTINGS

input_title : STRING
input_subtitle : STRING

execute
local
    doc : STRING
    output_lines : INTEGER
    output : PLAIN_TEXT_FILE
    input : PLAIN_TEXT_FILE
    i,j,t : INTEGER
    repeat_flag : BOOLEAN
  do
  		create pslib
  		create config.make

		create input.make_open_read(input_filename)
		create output.make_open_write(output_filename)

		from input.start ; input.read_line ; i := 0; j:=0
        until input.last_string.is_empty
        loop
          i := i + 1
          --read each line checking for = sign
          -- if equal sign, then set that value, the order is (title, subtitle, spacing, left margin, page width)
          -- if no equal sign, then keep reading and store it
          --internal.put(input.last_character,i)

          if is_command(input.last_string) then
          	j := j +1
            set_command(input.last_string,j)
          end
          input.read_line
        end

        output_lines := 0+ i
        doc := pslib.preamble (input_title,input_subtitle,config.left_margin)

        -- iterates through each music line
        from input.read_line ; i := 0
        until input.off
        loop
          if not(input.last_string.is_empty) then
          	io.putstring(input.last_string)
            io.new_line

            repeat_flag := false

            -- iterates through the whole current line checking and calling the necessary
            -- PS_LIB commands on each corresponding character
            from j := 1
            until j = input.last_string.count
            loop
            	if input.last_string.at (j).is_equal ('|') then
            		doc := doc + pslib.print_bar
            	elseif input.last_string.at (j).is_digit then
            		if input.last_string.at (j-1).is_equal ('|') then
            			doc := doc + pslib.print_repeat_times (input.last_string.substring (j-1, j+1).to_integer)
            		else
            			doc := doc + pslib.print_note (i,input.last_string.substring (j-1, j+1) )
            		end
            	elseif input.last_string.at (j).is_equal ('*') then
            		if repeat_flag then
            			doc := doc + pslib.print_end_repeat
            		else
            			doc := doc + pslib.print_start_repeat
            			repeat_flag := true
            		end

            	end
            	doc :=  doc + pslib.move_to_the_right (config.spacing)
            	j := j+1

            end

            --doc := doc+"%N"
          end

          i := i + 1
          input.read_line
        end

        output_lines := output_lines + i

        input.close

		doc := doc + pslib.trailer (output_lines)
		output.put_string (doc)
        output.close
  end

feature {NONE} -- Implementation

is_command(line: STRING): BOOLEAN
    -- checks if a given line has one of the settings or is just a value for one of them
    -- ie. checks if the line contains one of: TITLE=, SUBTITLE=, SPACING=, LEFT_MARGIN=, PAGE_WIDTH=
    -- returns true if the line does contain one of the above
  do
    if (line.has ('=')) then
    	Result := true
    else
    	Result := false
    end
  end

set_command(line: STRING; setting_id : INTEGER)
    -- sets the command give its id and value
    -- command being either of: title, subtitle, spacing, left_margin, or page_width
  local
  	line_length  : INTEGER
  do
  	line_length := line.count

  	if setting_id = 1 then -- title
  	  input_title := line.substring (7,line_length)
  	elseif setting_id = 2 then  	 --subtitle
  	  input_subtitle := line.substring (10,line_length)
  	elseif setting_id = 3 then  	 --spacing
  	  config.set_spacing(line.substring (9,line_length).to_real)
	elseif setting_id = 4 then  	 --left_margin
  	  config.set_left_margin(line.substring (13,line_length).to_integer)
    elseif setting_id = 5 then  	 --page_width
  	  config.set_page_width(line.substring (12,line_length).to_integer)
  	end
  end
end
