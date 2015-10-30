--[[--
	Just your run-of-the-mill stack structure
	overly fancy example:
		Pop everything in order and do stg with it:
		`for value in function() myStack:Pop() end do`
			`print(value)`
		`end`
]]
local Stack = setmetatable ( {}, require"ClassMt" )
Stack.__index = Stack


---Creates a new stack, optionally based on a table
-- @param [table t] a table to be used instad of an empty table
function Stack.New ( t )
	return setmetatable ( t or {}, Stack )
end


--[[-- Shockingly, it pushes a value onto the stack
	@param value the value to be pushed
	@return the value that was pushed
]]
function Stack:Push ( value )
	self [ #self + 1 ] = value
	return value
end


--[[--
	Even more surprising is the fact that this method pops the last value
	@return value|nil the popped value or nil
	@return [string] an error message, if the stack was alraedy empty
	Not throwing an error is good because this fanciness is possible with it:
	for value in function() return myStackObject:Pop() end do
		print ( value )
	end
]]
function Stack:Pop ( )
	local l = #self
	local value = self [ l ]
	self [ l ] = nil
	return value, value == nil and "Stack already empty"
end


return Stack