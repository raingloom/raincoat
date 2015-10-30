---Helpers for writing optinally FFI optimized classes
local FFITools = {}


---Used for converting module paths to C-style names
--@param name any string
function FFITools.CSafeName( name )
	--don't return number of matches
	--TODO: more intelligent replacements?
	return (name:gsub( '%W', '_' ))
end


---Converts a module name into a C-style type name
-- @param name a module name
-- @param stripped optionally strip the module string to only contain the last part
function FFITools.typeName( name, stripped )
	return FFITools.CSafeName( stripped and name:match '[^%.]+$' or name ) .. '_t'
end


return FFITools
