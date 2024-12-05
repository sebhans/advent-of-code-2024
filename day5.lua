local rules = {}
local updates = {}
local rules_done = false
for line in io.lines('input/day5.txt') do
  if rules_done then
    updates[#updates + 1] = "," .. line .. ","
  elseif #line == 0 then
    rules_done = true
  else
    rules[#rules + 1] = { line:match("(%d+)|(%d+)") }
  end
end

function is_valid(update)
  for _, rule in ipairs(rules) do
    local first = update:find("," .. rule[1] .. ",")
    local second = update:find("," .. rule[2] .. ",")
    if first and second and second < first then
      return false
    end
  end
  return true
end

function middle_page_of(update)
  local pages = {}
  for page in update:gmatch("(%d+)") do
    pages[#pages + 1] = page
  end
  return pages[(#pages + 1) / 2]
end

local sum_of_middle_pages_of_valid_updates = 0
for _, update in ipairs(updates) do
  if is_valid(update) then
    sum_of_middle_pages_of_valid_updates = sum_of_middle_pages_of_valid_updates + middle_page_of(update)
  end
end

print(sum_of_middle_pages_of_valid_updates)
