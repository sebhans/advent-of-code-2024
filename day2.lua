function kind(previous, current)
  if previous == current then
    return 'unsafe'
  elseif math.abs(current - previous) > 3 then
    return 'unsafe'
  elseif current - previous > 0 then
    return 'asc'
  else
    return 'desc'
  end
end

local safe_count = 0
for line in io.lines('input/day2.txt') do
  local report_kind = nil
  local previous = nil
  local safe = true
  for level in string.gmatch(line, "%d+") do
    if previous then
      local kind = kind(previous, level)
      if kind == 'unsafe' then
        safe = false
        break
      end
      if report_kind and kind ~= report_kind then
        safe = false
        break
      end
      report_kind = kind
    end
    previous = level
  end
  if safe then
    safe_count = safe_count + 1
  end
end

print(safe_count)
