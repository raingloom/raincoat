--[[--
  Quick Lookup Table
  Actually it is only faster on massive iterations and lookups, but nevermind that
  Basically makes it easier to get a set of keys and values, in exchange for making simply indexing and setting things slower.
  Quick warning: the table library.... well, it won't work on the returned object
]]


local QLT = setmetatable ( {}, require 'Raincoat.Mt.Class' )


local WeakMT = require 'Raincoat.Mt.Weak'

local Values = {}
local Tables = {}


function QLT.New ( t )
  t = t and setmetatable ( t, nil ) or {}
  local ret = {}
  local vt = {}
  Values [ ret ] = vt
  Tables [ ret ] = t
  for _, v in pairs ( t ) do
    vt [ v ] = true
  end
  setmetatable ( ret, QLT )
  return ret
end


function QLT:__newindex ( k, v )
  if v == nil then--free up memory
    local t = Tables [ self ]
    local pv = t [ k ]
    if pv ~= nil then--guard against nil key
      Values [ self ] [ pv ] = nil
    end
    t [ k ] = nil
  else
    Values [ self ] [ v ] = true
    Tables [ self ] [ k ] = v
  end
end


function QLT:__index ( k )
  return Tables [ self ] [ k ]
end


function QLT:__pairs ( )
  return pairs ( Tables [ self ] )
end


function QLT:__ipairs ( )
  return ipairs ( Tables [ self ] )
end


function QLT:GetValues ( )
  return Values [ self ]
end


function QLT:GetKeys ( )
  return Tables [ self ]
end
QLT.GetTables = QLT.GetKeys


return QLT