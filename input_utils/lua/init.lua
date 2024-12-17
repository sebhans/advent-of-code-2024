local M = {}

local function read_lines_raw(filename, f)
  for line in io.lines(filename) do
    f(line)
  end
end

local function read_lines_with_pattern(filename, pattern, f)
  for line in io.lines(filename) do
    f(line:match(pattern))
  end
end

function M.read_lines(filename, f_or_pattern, f)
  if type(f_or_pattern) == "string" then
    return read_lines_with_pattern(filename, f_or_pattern, f)
  else
    return read_lines_raw(filename, f_or_pattern)
  end
end

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

function M.read_paragraphs(filename, f)
  local paragraph = nil
  for line in io.lines(filename) do
    if line == '' then
      f(paragraph)
      paragraph = nil
    elseif not paragraph then
      paragraph = line
    else
      paragraph = paragraph .. "\n" .. line
    end
  end
  if paragraph then
    f(paragraph)
  end
end

return M
