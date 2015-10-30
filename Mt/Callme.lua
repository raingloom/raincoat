--[[-- Creates simple metatables with a __call field.
	Made to reduce redundancy of metatables of the form:
	`{
		__call = function (self,...)
			return self.somename (...)
		end
	}`
	@param name a static function name (but any value will work)
	@usage setmetatable ( class, require"raincoat.Mt.Callme""New" )
]]
local mtcache = {}

return function ( name )
	local mt = mtcache [ name ]
	if not mt then
		mt = {
			__call = function ( self, ... )
				return self [ name ] ( ... )
			end
		}
		mtcache [ name ] = name
	end
	return mt
end
