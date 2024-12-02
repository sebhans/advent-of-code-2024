function parse_numbers(s)
  local numbers = {}
  for n in string.gmatch(s, "%d+") do
    numbers[#numbers + 1] = n
  end
  return numbers
end

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

function is_safe(report)
  local report_kind = nil
  for i = 2, #report do
    local kind = kind(report[i - 1], report[i])
    if kind == 'unsafe' then
      return false
    end
    if report_kind and kind ~= report_kind then
      return false
    end
    report_kind = kind
  end
  return true
end

local safe_count_1 = 0
for line in io.lines('input/day2.txt') do
  if is_safe(parse_numbers(line)) then
    safe_count_1 = safe_count_1 + 1
  end
end

print(safe_count_1)

function copy_array_removing(t, index_to_remove)
  local t2 = {}
  for i = 1, #t do
    if i ~= index_to_remove then
      t2[#t2 + 1] = t[i]
    end
  end
  return t2
end

function is_safe_tolerating_one_bad_level(report)
  if is_safe(report) then
    return true
  end
  for i = 1, #report do
    if is_safe(copy_array_removing(report, i)) then
      return true
    end
  end
  return false
end

local safe_count_2 = 0
for line in io.lines('input/day2.txt') do
  if is_safe_tolerating_one_bad_level(parse_numbers(line)) then
    safe_count_2 = safe_count_2 + 1
  end
end

print(safe_count_2)
