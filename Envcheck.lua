--[[--
	Tests what features are enabled in the running Lua version.
]]
local Environment = {}


do--check for supported metamethods
	
	--__pairs
	Environment.mt_pairs = not pairs( setmetatable( {}, { __pairs = function() end } ) )
	--__ipairs
	Environment.mt_ipairs = not ipairs( setmetatable( {}, { __ipairs = function() end } ) )
	
	--__len
	Environment.mt_len = #setmetatable( {}, { __len = function() return 1 end } ) == 1
	
	--__gc
	local tmp = setmetatable( {}, { __gc = function() Environment.mt_gc = true end} )
	tmp=nil
	if collectgarbage then--sandboxes might disable tampering with gc
		--gc will collect either way, but it might lag
		collectgarbage()
	end
end


do--check bitwise operations
	Environment.bitwiseOps = not not loadstring( "return 1 << 1" )
end


do--check vararg support variant
	local outerArg = arg
	Environment.autoArgTable = (function(...) return arg~=outerArg end)()
end


return Environment