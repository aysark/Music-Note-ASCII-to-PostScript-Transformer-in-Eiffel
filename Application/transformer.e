note
  description: "Interface for transformer objects"
  author: "VT"

deferred class TRANSFORMER

--------------------------------------------------------------------------------
feature -- Execute

execute
  deferred end

--------------------------------------------------------------------------------
feature {NONE} -- Creation

make(input, output: STRING)
  do
    input_filename := input
    output_filename := output
  end

--------------------------------------------------------------------------------
feature {NONE} -- Private

input_filename, output_filename: STRING

end
