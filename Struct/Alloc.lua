local function IsNil (a) return a==nil end


local function GetFree ( t, force, isEmpty )
	isEmpty = isEmpty or IsNil
	if force then
		for i = 1, #t do
			if isEmpty ( t[i] ) then
				return i
			end
		end
	end
	return #t + 1
end


local function Allocate ( t, v, force, isEmpty )
	local k = GetFree ( t, force, isEmpty)
	t[ k ] = v
	return k, v
end


return {
	GetFree = GetFree,
	Allocate = Allocate,
}