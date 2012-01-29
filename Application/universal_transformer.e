note
  description: "System's root class"

class UNIVERSAL_TRANSFORMER

create make

--------------------------------------------------------------------------------
feature -- Initialization

make
    -- Creation procedure.
  local
    t: TRANSFORMER
    e: EXECUTION_ENVIRONMENT
    i, o, iext, oext: STRING
  do
    create transformers.make
    create e
    i := e.get ("INPUT")
    o := e.get ("OUTPUT")
    if i /= Void and o /= Void then
      oext := o.substring(o.last_index_of ('.', o.count), o.count)
      iext := i.substring(i.last_index_of ('.', i.count), i.count)
      if iext.is_equal(".tab") and oext.is_equal(".ps") then
        create {TAB2PS} t.make(i, o)
        transformers.extend(t)
      else
        -- Do nothing. More options will be added here later.
      end
    else
      print("Environment variables INPUT and OUTPUT are not defined.%N")

    end
    from transformers.start
    until transformers.after
    loop
      transformers.item.execute
      transformers.forth
    end
  end

--------------------------------------------------------------------------------
feature {NONE} -- Private

transformers: LINKED_LIST[TRANSFORMER]

end
