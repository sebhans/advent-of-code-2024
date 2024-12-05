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

function parse_update(update)
  local pages = {}
  for page in update:gmatch("(%d+)") do
    pages[#pages + 1] = page
  end
  return pages
end

function middle_page_of(update)
  local pages = parse_update(update)
  return pages[(#pages + 1) / 2]
end

local sum_of_middle_pages_of_valid_updates = 0
for _, update in ipairs(updates) do
  if is_valid(update) then
    sum_of_middle_pages_of_valid_updates = sum_of_middle_pages_of_valid_updates + middle_page_of(update)
  end
end

print(sum_of_middle_pages_of_valid_updates)

function rule_comparator(a, b)
  for _, rule in ipairs(rules) do
    if rule[1] == a and rule[2] == b then
      return true
    end
  end
  return false
end

function render_update(pages)
  local update = ","
  for _, page in ipairs(pages) do
    update = update .. page .. ","
  end
  return update
end

function correct_update(update)
  local pages = parse_update(update)
  table.sort(pages, rule_comparator)
  return render_update(pages)
end

local sum_of_middle_pages_of_corrected_updates = 0
for _, update in ipairs(updates) do
  if not is_valid(update) then
    sum_of_middle_pages_of_corrected_updates = sum_of_middle_pages_of_corrected_updates + middle_page_of(correct_update(update))
  end
end

print(sum_of_middle_pages_of_corrected_updates)
