local Rlb = {}
Rlb.__index = Rlb


local function newstate( seed )
	return setmetatable(seed or {}, Rlb)
end


local function newindex( rlb, key, value )
	rlb.__index[key] = value
end


local function new ( seed )
	seed = newstate( seed )
	local ret = { __states = { seed }, __stateid = 1 }
	ret.__index = seed
	ret.__newindex = newindex
	return setmetatable( ret, ret )
end


function Rlb:__save()
	local nstate = {}
	nstate.__index = self.__index
	setmetatable( nstate, nstate )
	self.__index = nstate
	local stateid = self.__stateid + 1
	self.__stateid = stateid
	self.__states[ stateid ] = nstate
	return stateid
end


function Rlb:__rollback()
	local stateid = self.__stateid - 1
	if stateid > 0 then
		self.__states[ stateid + 1 ] = nil
		self.__index = self.__states[stateid]
		return stateid
	end
	return nil, "Can't roll back beyond initial state."
end


return new