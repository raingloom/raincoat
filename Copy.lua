local Copy = {}


--[[--
	Copies the sequence part of a table
	@tparam table t the table to copy
	@tparam[opt] i passed to unpack
	@tparam[opt] j passed to unpack
	@treturn table the copy of the (sub)sequence
]]
local unpack = unpack or table.unpack
function Copy.sequence( t, i, j )
	return {unpack( t, i, j )}
end


--[[--
	Creates a shallow copy of a table and sets the copies metatable.
	@tparam table t table to copy
	@tparam table shallow copy of t
]]
function Copy.object( t )
	return setmetatable( Copy.pairs( t ), getmetatable( t ) )
end


--[[--
	Returns the keys and values of t separately
	@treturn table keys of t
	@treturn table values of t
]]
function Copy.kvsplit( t )
	local rk, rv, i = {}, {}, 1
	for k, v in pairs( t ) do
		rk[i], rv[i], i = k, v, i+1
	end
	return rk, rv
end


--[[--
	Inverts the key-value relation of a table.
	@tparam table t a table
	@treturn table a table with keys corresponding to t's values and vice-versa
]]
function Copy.kvinvert( t )
	local ret = {}
	for k, v in pairs( t ) do
		ret[ v ] = k
	end
	return ret
end


return Copy
