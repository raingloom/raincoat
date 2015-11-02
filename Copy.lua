local Copy = {}


local unpack = unpack or table.unpack
function Copy.sequence( t )
	return {unpack( t )}
end


function Copy.pairs( t )
	local ret = {}
	for k, v in pairs( t ) do
		ret[k] = v
	end
	return ret
end


function Copy.object( t )
	return setmetatable( Copy.pairs( t ), getmetatable( t ) )
end


function Copy.kvsplit( t )
	local rk, rv, i = {}, {}, 1
	for k, v in pairs( t ) do
		rk[i], rv[i], i = k, v, i+1
	end
	return rk, rv
end


return Copy
