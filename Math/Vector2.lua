--Based on Lua JiT's example code and the vector-light library from HardonCollider


local vector2 = setmetatable( {}, require'raincoat.Mt.Class' )
vector2.__index = vector2


local sqrt = math.sqrt
local cos, sin = math.cos, math.sin


function vector2.__add( a, b )
	return vector2 ( a.x + b.x, a.y + b.y )
end


function vector2.__sub( a, b )
	return vector2 ( a.x - b.x, a.y - b.y )
end


function vector2.__mul( a, b )
	local isnum = type ( b ) == "number"
	return vector2 ( a.x * ( isnum and b or b.x ), a.y * ( isnum and b or b.y ) )
end


function vector2.__div( a, b )
	local isnum = type ( b ) == "number"
	return vector2 ( a.x / ( isnum and b or b.x ), a.y / ( isnum and b or b.y ) )
end


function vector2.__unm( a )
	return vector2 ( -a.x, -a.y )
end


function vector2.__len( a )
	return sqrt ( a.x * a.x + a.y * a.y )
end


function vector2.__eq( a, b )
	return a.x == b.x and a.y == b.y
end


function vector2.__lt ( a, b )
	return a.x < b.x or ( a.x == b.x and a.y < b.y )
end
	

function vector2.__le( a, b )
	return a.x <= b.x and a.y <= b.y
end


function vector2.__tostring( a )
	return "vector2d "..a.x..", "..a.y
end


function vector2.dot( a, b )
	return a.x * b.x + a.y * b.y
end


function vector2.unit( a )
	local l = #a
	return vector2 ( a.x / l, a.y / l )
end


function vector2.sunit( a )
	local l = #a
	a.x, a.y = vector2 ( a.x / l, a.y / l )
	return a
end

function vector2.rotate( a, r )
	local c, s = cos(r), sin(r)
	return vector2 ( c * a.x - s * a.y, s * a.x + c * a.y)
end


function vector2.srotate( a, r )
	local c, s = cos(r), sin(r)
	a.x, a.y = c * a.x - s * a.y, s * a.x + c * a.y
	return a
end


function vector2.determinant( a, b )
	return a.x * b.y - a.y * b.x
end


function vector2.lengthSquared( a )
	return a.x * a.x + a.y * a.y
end


function vector2.perpendicular( a )
	return vector2 ( -a.y, a.x )
end


function vector2.sperpendicular( a )
	a.x, a.y = -a.y, a.x
	return a
end


function vector2.project( a, b )
	local s = ( a.x * b.x + a.y * b.y ) / ( b.x * b.x + b.y * b.y )
	return vector2 ( s * b.x, s * b.y )
end


function vector2.sproject( a, b )
	local s = ( a.x * b.x + a.y * b.y ) / ( b.x * b.x + b.y * b.y )
	a.x, a.y = s * b.x, s * b.y
	return a
end


function vector2.mirror( a, b )
	local s = 2 * ( a.x * b.x + a.y * b.y ) / ( b.x * b.x + b.y * b.y )
	return vector2 ( s * b.x - a.x, s * b.y - a.y )
end


function vector2.smirror( a, b )
	local s = 2 * ( a.x * b.x + a.y * b.y ) / ( b.x * b.x + b.y * b.y )
	a.x, a.y = s * b.x - a.x, s * b.y - a.y
	return a
end


function vector2.__pack( s )
	return string.pack( 'dd', s.x, s.y )
end


function vector2.__unpack( s )
	return vector2( string.unpack( 'dd', s ) )
end


local ok, ffi = pcall( require, 'ffi' )
if ok then
	ffi.cdef[[
		typedef struct vector2 { double x, y ;} vector2_t;
	]]
	vector2.new = ffi.metatype ( "vector2_t", vector2 )
else
	function vector2.new( x, y )
		return setmetatable( { x = x, y = y }, vector2 )
	end
end


return vector2