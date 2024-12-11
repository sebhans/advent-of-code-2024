local M = {}

function M.read_numbers(filename, f)
  for line in io.lines(filename) do
    for n in line:gmatch("([0-9]+)") do
      f(n)
    end
  end
end

return M
