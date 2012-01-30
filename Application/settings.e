note
	description: "Summary description for {SETTINGS}."
	author: ""
	date: "$Date$"
	revision: "$Revision$"

class
	SETTINGS

create make

feature -- init
	 left_margin : INTEGER
	 spacing : REAL
	 page_width : INTEGER

	 make
	 do
	 	spacing := 4.0
	 	left_margin := 35
	 	page_width := 600
	 end

feature --setters
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
