---Provides a few basic search functions
-- @author Rain Gloom
local Search = {}


--[[--
	Binary search on an ordered sequence
	@param table orderedSequence the ordered sequence to search in
	@param n the value to search for
	@note n can be any value, but it must support arithmetic comparisons with the values in orderedSequence
	@return number|nil the key of the value if the value was found, otherwise nil
	@return value|number the value that was found or the key on which the search terminated
	@return nil|number nothing if the search was successful, otherwise the value on which the search terminated
]]
function Search.binary ( orderedSequence, n )
	local len = #orderedSequence
	local i = len
	local step = len
	local cur = orderedSequence [ i ]
	while step > 0 and cur ~= n	 do
		step = step // 2
		i = cur and ( cur < n and i + step or i - step ) or ( i < 1 and i + step or i - step )--guard against nil comparisons
		cur = orderedSequence [ i ]
	end
	if cur == n then
		--return key and value (simpler function chaining)
		return i, cur
	else
		--return nil and the index and value where it failed
		return nil, i, cur
	end
end


--[[--
	Brute force search all keys of a table
	@param table tbl the table to search
	@param value value the value to search for
	@param [function] iterator an optional iterator function to use instead of pairs
	@param ... pass these to the iterator function
]]
function Search.value ( tbl, value, iterator, ... )
	for k, v in ( iterator or pairs ) ( tbl, ... ) do
		if v == value then
			return k, v
		end
	end
end


--[[--
	Runs an advanced recursive search on a table.
	@tparam table tbl
	@tparam fun a function (or something callable)
	@tparam function iter the table iterator function, in case you want to use stg other than require
	@return the discovered value or nothing if it was not found
	@return the path that led to the value
]]
function Search.deepFilter( tbl, fun, iter, _path, _guard )
	iter = iter or pairs
	_guard = _guard or {}
	_path = _path or {}
	_guard[tbl] = true
	local tl = {}
	for k, v in iter( tbl ) do
		_path[#_path+1]=k
		if fun(v,_path) then
			return v, _path
		end
		_path[#_path]=nil
		if type( v ) == 'table' then
			tl[#tl+1]=k
		end
	end
	_path[#_path]=nil
	for _, k in ipairs( tl ) do
		local t = tbl[k]
		if not _guard[t] then
			_path[#_path+1]=k
			return Search.deepFilter( t, fun, iter, _path, _guard )
		end
	end
end



return Search
