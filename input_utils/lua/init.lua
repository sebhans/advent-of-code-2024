local M = {}

function M.read_numbers(filename, f)
  for line in io.lines(filename) do
    for n in line:gmatch("([0-9]+)") do
      f(n)
    end
  end
end

function M.read_matrix(filename)
  local matrix = {}
  for line in io.lines(filename) do
    local row = {}
    for c in line:gmatch("(.)") do
      row[#row + 1] = c
    end
    matrix[#matrix + 1] = row
  end
  return matrix
end

return M
