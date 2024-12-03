local sum = 0
for line in io.lines('input/day3.txt') do
  for a, b in string.gmatch(line, "mul[(](%d%d?%d?),(%d%d?%d?)[)]") do
    sum = sum + a * b
  end
end

print(sum)
