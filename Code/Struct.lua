error 'incomplete module'

--[[
	this module should help in creating string.pack/unpack formats and FFI declarations from type information stored in a table
]]

local LuaStructToC = {
	b = 'int8_t',
	B = 'uint8_t',
	h = 'int16_t',
	H = 'uint16_t',
	l = 'int32_t',
	L = 'uint32_t',
	f = 'float',
	d = 'double',
}


local function Struct( opt )
	local struct = opt.struct or opt
	local genffi = opt.generateFFI
	if genffi then
		for typename, names in pairs( struct ) do
		end
	end
end