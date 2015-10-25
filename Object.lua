--- An extension of the Classic library
local copy = require 'Raincoat.Copy'.object
local ok, Object = pcall( require, 'classic' )--try system path
if not ok then--try submodule through relative path
    Object = require (...) .. '.classic.src.classic'
end


Object = Object:extend()


function Object:copy()
    return (self.__copy or copy)( self )
end


return Object
