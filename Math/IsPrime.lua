return function ( n )
	if n == 1 then
		return false
	elseif n < 4 then
		return true
	elseif n%2 == 0 then
		return false
	elseif n < 9 then
		return false
	end
	local r = math.floor( math.sqrt( n ) )
	f = 5
	while f <= r do
		if n%f == 0 then
			return false
		elseif n%(f+2) == 0 then
			return false
		end
		f = f + 6
	end
	return true
end
