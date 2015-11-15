---Reimplements the package system in mostly pure Lua in order to support later monkey patching by custom code loaders.

local Package = {}


function Package.require( name )
	local err, erri = {}, 1
	for i, loader in ipairs( package.loaders ) do
		local ret = loader( name )
		local typ = type( ret )
		if typ == 'function' then
			--returned the loader
			return ret( name )--TODO: 5.3 uses a second argument but it's not documented exactly what that should be
		elseif typ == 'string' then
			--returned an error
			err[ erri ], erri = ret, erri + 1
		elseif typ ~= 'nil' then
			error "loader return is of invalid type"
		end
	end
	error( table.concat( err, '\n' ) )
end


Package.package = {}

local function loaders_luaSource( name )
	local f = package.searchpath( name, package.path )
	return loadfile( f )
end

