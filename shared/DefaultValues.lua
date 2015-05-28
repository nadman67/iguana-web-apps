function DefaultNil(s)
   if (s== json.NULL) then
      return nil
      else
      return s
      end
  end

function DefaultEmpty(s)
   if (s== json.NULL) then
      return ""
      else
      return s
      end
  end

function DefaultNilToUpper(s)if (s== json.NULL) then
      return nil
      else
      return string.upper(s)
      end
  end