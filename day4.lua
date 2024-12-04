local input = {}
for line in io.lines('input/day4.txt') do
  input[#input + 1] = line
end

function count_XMAS(input)
  local count = 0
  for _, line in ipairs(input) do
    for match in line:gmatch("XMAS") do
      count = count + 1
    end
  end
  return count
end

function flip_horizontally(input)
  local flipped = {}
  for _, line in ipairs(input) do
    flipped[#flipped + 1] = line:reverse()
  end
  return flipped
end

function transpose(input)
  local transposed = {}
  for i = 1, #input[1] do
    local line = ""
    for j = 1, #input do
      line = line .. input[j]:sub(i, i)
    end
    transposed[#transposed + 1] = line
  end
  return transposed
end

function diagonal_from(input, i, j)
  local line = ""
  while j <= #input and i <= #input[j] do
    line = line .. input[j]:sub(i, i)
    i = i + 1
    j = j + 1
  end
  return line
end

function diagonals(input)
  local diagonals = {}
  for i = 1, #input[1] do
    diagonals[#diagonals + 1] = diagonal_from(input, i, 1)
  end
  for j = 2, #input do
    diagonals[#diagonals + 1] = diagonal_from(input, 1, j)
  end
  return diagonals
end

local total = 0
total = total + count_XMAS(input)
total = total + count_XMAS(flip_horizontally(input))
total = total + count_XMAS(transpose(input))
total = total + count_XMAS(flip_horizontally(transpose(input)))
total = total + count_XMAS(diagonals(input))
total = total + count_XMAS(flip_horizontally(diagonals(input)))
total = total + count_XMAS(diagonals(flip_horizontally(input)))
total = total + count_XMAS(flip_horizontally(diagonals(flip_horizontally(input))))

print(total)
