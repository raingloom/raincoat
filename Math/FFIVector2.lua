--Based on Lua JiT's example code and the vector-light library from HardonCollider
local ffi=require"ffi"


ffi.cdef[[
  typedef struct vector2 { double x, y ;} vector2_t;
]]


local vector2
local sqrt = math.sqrt
local cos, sin = math.cos, math.sin
local mt = {
  __add = function ( a, b ) return vector2 ( a.x + b.x, a.y + b.y ) end,
  __sub = function ( a, b ) return vector2 ( a.x - b.x, a.y - b.y ) end,
  __mul = function ( a, b )
    local isnum = type ( b ) == "number"
    return vector2 ( a.x * ( isnum and b or b.x ), a.y * ( isnum and b or b.y ) )
  end,
  __div = function ( a, b )
    local isnum = type ( b ) == "number"
    return vector2 ( a.x / ( isnum and b or b.x ), a.y / ( isnum and b or b.y ) )
  end,
  __len = function ( a ) return sqrt ( a.x * a.x + a.y * a.y ) end,
  __index = {
    dot = function ( a, b ) return a.x * b.x + a.y * b.y end,
    unit = function ( a )
      local l = #a
      return vector2 ( a.x / l, a.y / l )
    end,
    rotate = function ( a, r )
      local c, s = cos(r), sin(r)
      return vector2 ( c * a.x - s * a.y, s * a.x + c * a.y)
    end,
    determinant = function ( a, b )
      return a.x * b.y - a.y * b.x
    end,
    lengthSquared = function ( a )
      return a.x * a.x + a.y * a.y
    end,
    perpendicular = function ( a )
      return vector2 ( -a.y, a.x )
    end,
    project = function ( a, b )
      local s = ( a.x * b.x + a.y * b.y ) / ( b.x * b.x + b.y * b.y )
      return vector2 ( s * b.x, s * b.y )
    end,
    mirror = function ( a, b )
      local s = 2 * ( a.x * b.x + a.y * b.y ) / ( b.x * b.x + b.y * b.y )
      return vector2 ( s * b.x - a.x, s * b.y - a.y )
    end,
  },
  __eq = function ( a, b ) return a.x == b.x and a.y == b.y end,
  __lt= function ( a, b ) return a.x < b.x or ( a.x == b.x and a.y < b.y ) end,
  __le = function ( a, b ) return a.x <= b.x and a.y <= b.y end,
  __tostring = function ( a ) return "vector2d "..a.x..":"..a.y end,
}
vector2 = ffi.metatype ( "vector2_t", mt )


return vector2