--- An extension of the Classic library
local copy = require 'raincoat.Copy'.object
local ok, Object = pcall( require, 'classic' )--try system path
if not ok then--try submodule through relative path
	local here = ...
	here = here and here:match'[^%.]+$' or ''
	Object = require( here..'.classic.src.classic' )
end


Object = Object:extend()


function Object:copy()
		return (self.__copy or copy)( self )
end


return Object
