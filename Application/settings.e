note
	description: "Configuration settings for the TAB2PS class"
	author: "Aysar Khalid"
	date: "28.1.2012"
	version: "1.0"

class
	SETTINGS

create make

feature -- Initialization
	 left_margin : INTEGER
	 spacing : REAL
	 page_width : INTEGER

	 make
	 do -- setting default values
	 	spacing := 4.0
	 	left_margin := 35
	 	page_width := 600
	 end

feature -- Setters
	set_left_margin(lm:INTEGER)
	do
		left_margin:= lm
	end

	set_spacing(s:REAL)
	do
		spacing:= s
	end

	set_page_width(pw:INTEGER)
	do
		page_width:= pw
	end
end
