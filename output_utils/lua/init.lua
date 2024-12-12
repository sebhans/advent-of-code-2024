local M = {}

function M.print_matrix(m)
  for _, row in ipairs(m) do
    for _, c in ipairs(row) do
      io.write(c)
    end
    print()
  end
end

return M
