return function ( f, t )
	local ret = t or {}
	assert ( loadfile ( f, 't', ret ) ) ()
	return ret
end
