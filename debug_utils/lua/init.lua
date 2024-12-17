local M = {}

function M.dump_table_inline(t)
  io.write("{")
  for k, v in pairs(t) do
    io.write(tostring(k))
    io.write(": ")
    io.write(tostring(v))
    io.write(", ")
  end
  io.write("}")
end

function M.dump_array(tag, t)
  io.write(tag .. ": ")
  if #t == 0 then
    print("{}")
    return
  end
  print()
  for i, e in ipairs(t) do
    io.write("  " .. i .. ": ")
    if type(e) == "table" then
      M.dump_table_inline(e)
    else
      io.write(tostring(e))
    end
    print()
  end
end

return M
