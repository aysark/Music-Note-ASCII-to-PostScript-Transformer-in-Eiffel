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
	 spacing : DOUBLE
	 page_width : INTEGER

	 make
	 do
	 	spacing := 4.0
	 	left_margin := 35
	 	page_width := 600
	 end

end
