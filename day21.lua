local i = require('input_utils.lua')
local t = require('table_utils.lua')

local codes = {}
i.read_lines('input/day21.txt', function(line) codes[#codes + 1] = line end)

local numeric_keypad_navigation = {
  ['AA'] = {'A'},
  ['A0'] = {'<A'},
  ['A1'] = {'^<<A', '<^<A'},
  ['A2'] = {'^<A', '<^A'},
  ['A3'] = {'^A'},
  ['A4'] = {'^^<<A', '^<^<A', '^<<^A', '<^^<A', '<^<^A'},
  ['A5'] = {'^^<A', '<^^A', '^<^A'},
  ['A6'] = {'^^A'},
  ['A7'] = {'^^^<<A', '^^<^<A', '^^<<^A', '^<^^<A', '^<^<^A', '^<<^^A', '<^<^^A', '<^^<A'},
  ['A8'] = {'^^^<A', '<^^^A', '^<^^A', '^^<^A'},
  ['A9'] = {'^^^A'},

  ['0A'] = {'>A'},
  ['00'] = {'A'},
  ['01'] = {'^<A'},
  ['02'] = {'^A'},
  ['03'] = {'^>A', '>^A'},
  ['04'] = {'^^<A', '^<^A'},
  ['05'] = {'^^A'},
  ['06'] = {'^^>A', '>^^A', '^>^A'},
  ['07'] = {'^^^<A', '^^<^A', '^<^^A'},
  ['08'] = {'^^^A'},
  ['09'] = {'^^^>A', '>^^^A', '^>^^A', '^^>^A'},

  ['1A'] = {'>>vA', '>v>A'},
  ['10'] = {'>vA'},
  ['11'] = {'A'},
  ['12'] = {'>A'},
  ['13'] = {'>>A'},
  ['14'] = {'^A'},
  ['15'] = {'^>A', '>^A'},
  ['16'] = {'^>>A', '>>^A', '>^>A'},
  ['17'] = {'^^A'},
  ['18'] = {'^^>A', '>^^A', '^>^A'},
  ['19'] = {'^^>>A', '>>^^A', '^>^>A', '^>>^A', '>^>^A', '>^^>A'},

  ['2A'] = {'v>A', '>vA'},
  ['20'] = {'vA'},
  ['21'] = {'<A'},
  ['22'] = {'A'},
  ['23'] = {'>A'},
  ['24'] = {'^<A', '<^A'},
  ['25'] = {'^A'},
  ['26'] = {'^>A', '>^A'},
  ['27'] = {'^^<A', '<^^A', '^<^A'},
  ['28'] = {'^^A'},
  ['29'] = {'^^>A', '>^^A', '^>^A'},

  ['3A'] = {'vA'},
  ['30'] = {'v<A', '<vA'},
  ['31'] = {'<<A'},
  ['32'] = {'<A'},
  ['33'] = {'A'},
  ['34'] = {'^<<A', '<<^A', '<^<A'},
  ['35'] = {'^<A', '<^A'},
  ['36'] = {'^A'},
  ['37'] = {'<<^^A', '^^<<A', '<^^<A', '^<<^A', '^<^<A', '<^<^A'},
  ['38'] = {'^^<A', '<^^A', '^<^A'},
  ['39'] = {'^^A'},

  ['4A'] = {'>>vvA', '>v>vA', '>vv>A', 'v>v>A', 'v>>vA'},
  ['40'] = {'>vvA', 'v>vA'},
  ['41'] = {'vA'},
  ['42'] = {'v>A', '>vA'},
  ['43'] = {'v>>A', '>>vA', '>v>A'},
  ['44'] = {'A'},
  ['45'] = {'>A'},
  ['46'] = {'>>A'},
  ['47'] = {'^A'},
  ['48'] = {'^>A', '>^A'},
  ['49'] = {'^>>A', '>>^A', '>^>A'},

  ['5A'] = {'vv>A', '>vvA', 'v>vA'},
  ['50'] = {'vvA'},
  ['51'] = {'v<A', '<vA'},
  ['52'] = {'vA'},
  ['53'] = {'v>A', '>vA'},
  ['54'] = {'<A'},
  ['55'] = {'A'},
  ['56'] = {'>A'},
  ['57'] = {'^<A', '<^A'},
  ['58'] = {'^A'},
  ['59'] = {'^>A', '>^A'},

  ['6A'] = {'vvA'},
  ['60'] = {'vv<A', '<vvA', 'v<vA'},
  ['61'] = {'v<<A', '<<vA', 'v<vA'},
  ['62'] = {'v<A', '<vA'},
  ['63'] = {'vA'},
  ['64'] = {'<<A'},
  ['65'] = {'<A'},
  ['66'] = {'A'},
  ['67'] = {'^<<A', '<<^A', '<^<A'},
  ['68'] = {'^<A', '<^A'},
  ['69'] = {'^A'},

  ['7A'] = {'>>vvvA', '>v>vvA', '>vv>vA', '>vvv>A', 'v>>vvA', 'v>v>vA', 'v>vv>A', 'v>>vvA', 'v>v>vA', 'v>vv>A', 'vv>>vA', 'vv>v>A'},
  ['70'] = {'>vvvA', 'v>vvA', 'vv>vA'},
  ['71'] = {'vvA'},
  ['72'] = {'vv>A', '>vvA', 'v>vA'},
  ['73'] = {'vv>>A', '>>vvA', 'v>>vA', '>vv>A', '>v>vA', 'v>v>A'},
  ['74'] = {'vA'},
  ['75'] = {'v>A', '>vA'},
  ['76'] = {'v>>A', '>>vA', '>v>A'},
  ['77'] = {'A'},
  ['78'] = {'>A'},
  ['79'] = {'>>A'},

  ['8A'] = {'vvv>A', '>vvvA', 'v>vvA', 'vv>vA'},
  ['80'] = {'vvvA'},
  ['81'] = {'vv<A', '<vvA', 'v<vA'},
  ['82'] = {'vvA'},
  ['83'] = {'vv>A', '>vvA', 'v>vA'},
  ['84'] = {'v<A', '<vA'},
  ['85'] = {'vA'},
  ['86'] = {'v>A', '>vA'},
  ['87'] = {'<A'},
  ['88'] = {'A'},
  ['89'] = {'>A'},

  ['9A'] = {'vvvA'},
  ['90'] = {'vvv<A', '<vvvA', 'v<vvA', 'vv<vA'},
  ['91'] = {'vv<<A', '<<vvA', '<vv<A', 'v<<vA', 'v<v<A', '<v<vA'},
  ['92'] = {'vv<A', '<vvA', 'v<vA'},
  ['93'] = {'vvA'},
  ['94'] = {'v<<A', '<<vA', '<v<A'},
  ['95'] = {'v<A', '<vA'},
  ['96'] = {'vA'},
  ['97'] = {'<<A'},
  ['98'] = {'<A'},
  ['99'] = {'A'},
}

local directional_keypad_navigation = {
  ['AA'] = {'A'},
  ['A^'] = {'<A'},
  ['A<'] = {'v<<A', '<v<A'},
  ['Av'] = {'v<A', '<vA'},
  ['A>'] = {'vA'},

  ['^A'] = {'>A'},
  ['^^'] = {'A'},
  ['^<'] = {'v<A'},
  ['^v'] = {'vA'},
  ['^>'] = {'>vA', 'v>A'},

  ['<A'] = {'>>^A', '>^>A'},
  ['<^'] = {'>^A'},
  ['<<'] = {'A'},
  ['<v'] = {'>A'},
  ['<>'] = {'>>A'},

  ['vA'] = {'>^A', '^>A'},
  ['v^'] = {'^A'},
  ['v<'] = {'<A'},
  ['vv'] = {'A'},
  ['v>'] = {'>A'},

  ['>A'] = {'^A'},
  ['>^'] = {'^<A', '<^A'},
  ['><'] = {'<<A'},
  ['>v'] = {'<A'},
  ['>>'] = {'A'},
}

local function keypresses_for_sequence(navigation, sequence)
  local key_presses = {''}
  local current_key = 'A'
  for next_key in sequence:gmatch('.') do
    local nkp = {}
    for _, kp in ipairs(key_presses) do
      for _, n in ipairs(navigation[current_key .. next_key]) do
        nkp[#nkp + 1] = kp .. n
      end
    end
    key_presses = nkp
    current_key = next_key
  end
  return key_presses
end

local function add_indirection(navigation)
  local indirect_navigation = {}
  for movement, sequences in pairs(navigation) do
    local indirect_sequences = {}
    for _, sequence in ipairs(sequences) do
      t.append_all(indirect_sequences, keypresses_for_sequence(directional_keypad_navigation, sequence))
    end
    indirect_navigation[movement] = indirect_sequences
  end
  return indirect_navigation
end

local function prune(navigation)
  local pruned = {}
  for movement, sequences in pairs(navigation) do
    pruned[movement] = { t.min_by(sequences, string.len) }
  end
  return pruned
end

local numeric_keypad_navigation_indirect = prune(add_indirection(add_indirection(numeric_keypad_navigation)))

local complexity_sum = 0
for _, code in ipairs(codes) do
  local numeric_part = code:match('(%d+)')
  local keypresses = keypresses_for_sequence(numeric_keypad_navigation_indirect, code)
  local complexity = math.maxinteger
  for _, kp in ipairs(keypresses) do
    if #kp < complexity then complexity = #kp end
  end
  complexity_sum = complexity_sum + complexity * numeric_part
end
print(complexity_sum)
