--[[--
  Quick Lookup Table
  Actually it is only faster on massive iterations and lookups, but nevermind that
  Basically makes it easier to get a set of keys and values
]]

local QLT = setmetatable ( {}, require 'Raincoat.Mt.Class' )

local WeakMT = require 'Raincoat.Mt.Weak'

local Values = setmetatable ( {}, WeakMT )
local Keys = setmetatable ( {}, WeakMT )
local Tables = setmetatable ( {}, WeakMT )


function QLT.New ( t )
  return setmetatable ( {}, QLT )
end


function QLT:GetKeys ( )
  return Keys [ self ]
end


function QLT:GetValues ( )
  return Values [ self ]
end


function QLT:__newindex ( k, v )
  Keys [ self ] = k
  Values [ self ] = v
  Tables [ self ] [ k ] = v
end
--QLT.Set = QLT.__newindex


function QLT:__index ( k )
  return Tables [ self ] [ k ]
end
--QLT.get = QLT.__index


function QLT:__pairs ( )
  return pairs ( Tables [ self ] )
end


function QLT:__ipairs ( )
  return ipairs ( Tables [ self ] )
end


return QLT