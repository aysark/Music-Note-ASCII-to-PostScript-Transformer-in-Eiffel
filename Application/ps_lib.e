note
  description: "Functions that produce tablature in PostScript"
  author: "VT"
class  PS_LIB

--------------------------------------------------------------------------------
feature -- Operations

move_to_next_line: STRING
    -- Result is a string of PostScript commands to move the
    -- current position to the left margin of the next staff
    -- line on the page
  do
    Result := "%% Move to next line%N"
    Result := Result + "grestore 0 -72 translate gsave%N";
  end

move_to_the_right(spacing: REAL): STRING
    -- Result is a string of PostScript commands to move the
    -- current position to the right by the amount spacing
  do
    Result := "%% Move to the right%N"
    Result := Result + spacing.out + " 0 translate%N";
  end

new_page(total_lines: INTEGER; left_margin: INTEGER): STRING
    -- Result is a string of PostScript commands to print
    -- the current page and create a new page of staff lines.
    -- Current position is at the left margin of the first staff line.
    -- total_lines is the number of output lines produced so far
  local
    k: INTEGER
  do
    Result := "%% New page%N"
    Result := Result + "grestore showpage%N"
    k := (total_lines // 10) + 1
    Result := Result + "%%%%EndPage: " + k.out + "%N"
    k := (total_lines // 10) + 2
    Result := Result + "%%%%Page: " + k.out + " " + k.out + "%N"
    Result := Result + "/ypos 72 def%N"
    Result := Result + "/Helvetica findfont 8 scalefont setfont%N"
    Result := Result + "1 1 scale 0 setgray .4 setlinewidth%N"
    Result := Result + "1 1 10 { 0 ypos stave /ypos ypos perst add def } for%N"
    Result := Result + left_margin.out + " 717 translate gsave%N"
  end

preamble (title, subtitle: STRING; left_margin: INTEGER): STRING
    -- Result is a string of PostScript commands to print the title,
    -- subtitle, and create a page of staff lines.
    -- Current position is at the left margin of the first staff line.
    -- This is the first feature to call in PS_LIB.
    -- title and subtitle can be void
  do
    Result := "%%%%!PS-Adobe-1.0%N"
    Result := Result + "%%%%Title: A song%N"
    Result := Result + "%%%%Creator: Myself%N"
    Result := Result + "%%%%Pages: (atend)%N"
    Result := Result + "%%%%BoundingBox: 5 5 605 787%N"
    Result := Result + "%%%%EndComments%N"
    Result := Result + "%%Page: 1 1%N"
    if (title /= Void) then
      Result := Result
              + "gsave 300 730 translate /Helvetica "
              + "findfont 28 scalefont setfont%N"
      Result := Result + "(" + title + ") dup stringwidth pop 2 div neg "
              + "0 moveto show grestore%N"
      end
    if (subtitle /= Void) then
      Result := Result + "gsave 300 710 translate /Helvetica "
              + "findfont 12 scalefont setfont%N"
      Result := Result + "(" + subtitle + ") dup stringwidth pop 2 div "
              + "neg 0 moveto show grestore%N"
    end
    Result := Result + "/deltalines 7 def  /ypos 72 def  /perst 72 def%N"
    Result := Result + "/stave { gsave translate 1 1 6 { 0 0 moveto "
            + "612 0 lineto%N"
    Result := Result + "0 deltalines translate } for stroke grestore } def%N"
    Result := Result + "1 1 scale 0 setgray .4 setlinewidth%N"
    Result := Result + "/Helvetica findfont 8 scalefont setfont%N"
    Result := Result + "1 1 9 { 0 ypos stave /ypos ypos perst add def } for%N"
    Result := Result + left_margin.out + " 645 translate gsave%N"
  end

print_alternate_line(number, length: INTEGER): STRING
    -- Result is a string of PostScript commands to print an
    -- an alternate line above the tablature at the current
    -- position. Current position does not change.
    -- length designates how long the line will be
  do
    Result := "%% Begin print_alternate_line%N"
    Result := Result + "newpath 0 47 moveto 0 55 lineto stroke%N"
    Result := Result + "newpath 0 55 moveto " + length.out + " 55 lineto stroke%N"
    Result := Result + "6 47 moveto%N"
    Result := Result + "(" + number.out + ".) dup stringwidth pop 2 div neg "
            + "0 rmoveto show%N"
    Result := Result + "%% End print_alternate_line%N"
  end

print_bar: STRING
    -- Result is a string of PostScript commands to print a
    -- simple bar line but not change the current position.
  do
    Result := "%% Print bar%N"
    Result := Result + "newpath 0 3 moveto 0 38 lineto stroke%N"
  end

print_end_repeat: STRING
    -- Result is a string of PostScript commands to print an
    -- end repeat bar but not change the current posiiton.
  do
    Result := "%% Begin print_end_repeat%N"
    Result := Result + "newpath%N";
    Result := Result + "0 17 1.5 0 360 arc fill stroke%N"
    Result := Result + "0 24 1.5 0 360 arc fill stroke%N"
    Result := Result + "3 0 translate%N"
    Result := Result + print_bar
    Result := Result + "3 0 translate%N"
    Result := Result + "2.5 setlinewidth%N"
    Result := Result + print_bar
    Result := Result + ".4 setlinewidth%N"
    Result := Result + "%% End print_end_repeat%N"
  end

print_note(row: INTEGER; fret: STRING): STRING
    -- Result is a string of PostScript commands to print a number
    -- given by fret on the guitar string given by row.
    -- The current position does not change
  local
    z: INTEGER
  do
    z := 7 * (6 - row)
    Result := "%% Begin note%N";
    Result := Result + "newpath 0 " + z.out + " 2 add moveto (" + fret.out
            + ") stringwidth pop 2 div neg 0 rmoveto%N"
    Result := Result + "0 2 rlineto (" + fret.out
            + ") stringwidth pop 0 rlineto 0 -2 rlineto closepath%N"
    Result := Result + "1 setgray fill 0 setgray%N"
    Result := Result + "0 " + z.out + " moveto%N"
    Result := Result + "(" + fret.out
            + ") dup stringwidth pop 2 div neg 0 rmoveto show%N"
    Result := Result + "%% End note%N"
  end

print_repeat_times(i: INTEGER) : STRING
    -- Result is a string of PostScript commands to print a
    -- a message above the tablature to repeat i times
    -- Current position does not change
  do
    Result := "%% Begin print_repeat_times%N"
    Result := Result + "0 45 moveto%N";
    Result := Result + "(Repeat " + i.out + " times) dup stringwidth pop neg "
            + "0 rmoveto show%N";
    Result := Result + "%% End print_repeat_times%N"
  end

print_start_repeat: STRING
    -- Result is a string of PostScript commands to print a
    -- start repeat bar but not change the current posiiton.
  do
    Result := "%% Begin print_start_repeat%N"
    Result := Result + "2.5 setlinewidth%N"
    Result := Result + print_bar
    Result := Result + ".4 setlinewidth%N"
    Result := Result + "3 0 translate%N"
    Result := Result + print_bar
    Result := Result + "3 0 translate%N"
    Result := Result + "0 17 1.5 0 360 arc fill stroke%N"
    Result := Result + "0 24 1.5 0 360 arc fill stroke%N"
    Result := Result + "%% End print_start_repeat%N"
  end

trailer(total_lines: INTEGER): STRING
    -- Result is a string of PostScript commands to print the
    -- last page of music. This is the last feature to call in PS_LIB
    -- total_lines is the number of output lines produced
  local
    k: INTEGER
  do
    k := (total_lines // 10) + 1
    Result := "showpage%N"
    Result := Result + "%%EndPage: " + k.out + "%N"
    Result := Result + "%%%%Trailer%N"
    Result := Result + "%%%%Pages: " + k.out + " " + k.out + "%N"
    Result := Result + "%%%%EOF%N"
  end

end
