--Based on Lua JiT's example code and the vector-light library from HardonCollider


local Vector2 = setmetatable( {}, require'raincoat.Mt.Class' )
Vector2.__index = Vector2


local sqrt = math.sqrt
local cos, sin = math.cos, math.sin


function Vector2.__add( a, b )
	return Vector2 ( a.x + b.x, a.y + b.y )
end


function Vector2.__sub( a, b )
	return Vector2 ( a.x - b.x, a.y - b.y )
end


function Vector2.__mul( a, b )
	local isnum = type ( b ) == "number"
	return Vector2 ( a.x * ( isnum and b or b.x ), a.y * ( isnum and b or b.y ) )
end


function Vector2.__div( a, b )
	local isnum = type ( b ) == "number"
	return Vector2 ( a.x / ( isnum and b or b.x ), a.y / ( isnum and b or b.y ) )
end


function Vector2.__unm( a )
	return Vector2 ( -a.x, -a.y )
end


function Vector2.__len( a )
	return sqrt ( a.x * a.x + a.y * a.y )
end


function Vector2.__eq( a, b )
	return a.x == b.x and a.y == b.y
end


function Vector2.__lt ( a, b )
	return a.x < b.x or ( a.x == b.x and a.y < b.y )
end
	

function Vector2.__le( a, b )
	return a.x <= b.x and a.y <= b.y
end


function Vector2.__tostring( a )
	return "vector2d "..a.x..", "..a.y
end


function Vector2.dot( a, b )
	return a.x * b.x + a.y * b.y
end


function Vector2.unit( a )
	local l = #a
	return Vector2 ( a.x / l, a.y / l )
end


function Vector2.sunit( a )
	local l = #a
	a.x, a.y = Vector2 ( a.x / l, a.y / l )
	return a
end

function Vector2.rotate( a, r )
	local c, s = cos(r), sin(r)
	return Vector2 ( c * a.x - s * a.y, s * a.x + c * a.y)
end


function Vector2.srotate( a, r )
	local c, s = cos(r), sin(r)
	a.x, a.y = c * a.x - s * a.y, s * a.x + c * a.y
	return a
end


function Vector2.determinant( a, b )
	return a.x * b.y - a.y * b.x
end


function Vector2.lengthSquared( a )
	return a.x * a.x + a.y * a.y
end


function Vector2.perpendicular( a )
	return Vector2 ( -a.y, a.x )
end


function Vector2.sperpendicular( a )
	a.x, a.y = -a.y, a.x
	return a
end


function Vector2.project( a, b )
	local s = ( a.x * b.x + a.y * b.y ) / ( b.x * b.x + b.y * b.y )
	return Vector2 ( s * b.x, s * b.y )
end


function Vector2.sproject( a, b )
	local s = ( a.x * b.x + a.y * b.y ) / ( b.x * b.x + b.y * b.y )
	a.x, a.y = s * b.x, s * b.y
	return a
end


function Vector2.mirror( a, b )
	local s = 2 * ( a.x * b.x + a.y * b.y ) / ( b.x * b.x + b.y * b.y )
	return Vector2 ( s * b.x - a.x, s * b.y - a.y )
end


function Vector2.smirror( a, b )
	local s = 2 * ( a.x * b.x + a.y * b.y ) / ( b.x * b.x + b.y * b.y )
	a.x, a.y = s * b.x - a.x, s * b.y - a.y
	return a
end


function Vector2:__pack()
	return string.pack( 'dd', self.x, self.y )
end


function Vector2:__unpack()
	return Vector2( string.unpack( 'dd', self ) )
end


function Vector2:unpack()
	return self.x, self.y
end


local ok, ffi = pcall( require, 'ffi' )
if ok then
	ffi.cdef[[
		typedef struct vector2 { double x, y ;} vector2_t;
	]]
	Vector2.new = ffi.metatype ( "vector2_t", Vector2 )
else
	function Vector2.new( x, y )
		return setmetatable( { x = x, y = y }, Vector2 )
	end
end


Vector2.forward = Vector2( 0, 1 )
Vector2.right = Vector2( 1, 0 )
Vector2.null = Vector2( 0, 0 )


return Vector2