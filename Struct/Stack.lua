local Stack = setmetatable ( {}, require"ClassMt" )
Stack.__index = Stack
--[[--
  Just your run-of-the-mill stack structure
  overly fancy example:
    Pop everything in order and do stg with it:
    `for value in function() myStack:Pop() end do`
      `print(value)`
    `end`
]]

---Creates a new stack, optionally based on a table
-- @param [table t] a table to be used instad of an empty table
function Stack.New ( t )
  return setmetatable ( t or {}, Stack )
end


function Stack:Push ( value )
  self [ #self + 1 ] = value
  return value
end


function Stack:Pop ( )
  local l = #self
  local value = self [ l ]
  self [ l ] = nil
  return value, value == nil and "Stack already empty"
end


return Stack