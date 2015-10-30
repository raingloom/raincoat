local limits = {}

do--find integer width
	local w, n = 1, 1
	while n > 0 do
		n, w = n << 1, w + 1
	end
	limits.width = w
end

do--compute largest integer
	local m = ~0
	if m < 0 then--flip first bit to negate
		m = m ~ 1 << (limits.width-1)
	end
	limits.maxint = m
end

return limits
