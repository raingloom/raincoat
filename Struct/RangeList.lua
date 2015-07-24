local bs = require"Search".binary --special binary search function


--[[--
  Operations on index range sequences
  
  Range list form:
    an ordered sequence of numbers with an even length
    each pair of numbers counting is treated as one range
]]


local RangeList = setmetatable ( {}, require"Mt.Class" )
RangeList.__index = RangeList


function RangeList.New ( list, ... )
  local ret = type ( list ) == "table" and list or { list, ... }
  assert ( #list % 2 == 0, "Uneven list size" )
  --table.sort ( list ) auto enforce sorting?
  --for i = 1, #list - 1 do assert ( list [ i + 1 ] >= list [ i ], "List is not sorted" ) end
  return setmetatable ( ret, RangeList )
end


---Removes empty Ranges, ie.: Ranges with unsorted indices
function RangeList.RemoveEmpty ( list, first, last )
  local len = #list
  assert ( len % 2 == 0, "Odd list length" )
  local ret, j = {}, 1
  for i = 1, len, 2 do
    local a, b = list [ i ], list [ i + 1 ]
    if a <= b then
      ret [ j ], ret [ j + 1 ], j = a, b, j + 2
    end
  end
  return list, first, last
end


function RangeList.Invert ( list, first, last )
  local len = #list
  assert ( len % 2 == 0, "Odd list length" )
  local ret, i = { first }, 1
  while i <= len do
    ret [ i + 1 ] = list [ i ] - 1
    ret [ i + 2 ] = list [ i + 1 ] + 1
    i = i + 2
  end
  ret [ len + 2 ] = last
  return RangeList.RemoveEmpty ( ret ), first, last
end


--- Return true if the index at i is within a range, false otherwise
function RangeList.GetPolarityAt ( list, n )
  local _, i, cur = bs ( list, n )
  if _ then
    i, cur = _, i
  end
  return 1 <= i and i <= #list and ( i % 2 == 0 and n <= cur or n >= cur )
end


--- Transposes a range list by an offset
function RangeList.Offset ( list, offset )
  local ret = {}
  for i, v in ipairs ( list ) do
    ret [ i ] = v + offset
  end
  return ret
end


--- Iterates all Ranges
function RangeList.Ranges ( list )
  local i, len = -1, #list
  return function ()
    if i <= len then
      i = i + 2
      return list[i], list[i+1]
    end
  end
end


return RangeList