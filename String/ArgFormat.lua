--- Substitutes arguments into a string in arbitrary order
--  @within raincoat.String
--  @param str any string
--  @param ... any number of arbitrary arguments
--  note: indices outside the number of arguments simply return "nil"
--  @return the formatted string
--  @usage require'raincoat.String.ArgFormat'("this is the second argument: %2, and this is the first: %1", 'firsty', 'secondy')
return function ( str, ... )
	local arg = {}
	return str:gsub ( '%%(%d+)', function ( i ) return tostring ( arg [ tonumber ( i ) ] ) end )
end
