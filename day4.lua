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

local xmas_total = 0
xmas_total = xmas_total + count_XMAS(input)
xmas_total = xmas_total + count_XMAS(flip_horizontally(input))
xmas_total = xmas_total + count_XMAS(transpose(input))
xmas_total = xmas_total + count_XMAS(flip_horizontally(transpose(input)))
xmas_total = xmas_total + count_XMAS(diagonals(input))
xmas_total = xmas_total + count_XMAS(flip_horizontally(diagonals(input)))
xmas_total = xmas_total + count_XMAS(diagonals(flip_horizontally(input)))
xmas_total = xmas_total + count_XMAS(flip_horizontally(diagonals(flip_horizontally(input))))

print(xmas_total)

function count_X_MAS(input)
  local count = 0
  for i = 2, #input[1] - 1 do
    for j = 2, #input - 1 do
      if input[j]:sub(i, i) == "A" then
        if input[j-1]:sub(i-1, i-1) == "M" and input[j+1]:sub(i+1, i+1) == "S"
          or input[j-1]:sub(i-1, i-1) == "S" and input[j+1]:sub(i+1, i+1) == "M" then
          if input[j-1]:sub(i+1, i+1) == "M" and input[j+1]:sub(i-1, i-1) == "S"
            or input[j-1]:sub(i+1, i+1) == "S" and input[j+1]:sub(i-1, i-1) == "M" then
            count = count + 1
          end
        end
      end
    end
  end
  return count
end

print(count_X_MAS(input))
