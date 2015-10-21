local Permute = {}


--[[--
  Returns an iterator over all unique combinations of a list of (unique) elements.
  Practically it is a set permutation, but implemented with simple arrays for performance.
  @param t a list of (unique) elements
  @return an iterator function
]]
function Permute.unordered( t )
	local mask = {}
	local ret = {}
	local l = #t
	local k = true
	return function()
		if k then
			local j = 1
			local r = true
			while r and j <= l do
				if mask[j] then
					mask[j] = false
					r = true
				else
					mask[j] = true
					r = false
				end
				j = j + 1
			end
			local m = 1
			for i = 1, l do
				if mask[i] then
					ret[m], m = t[i], m + 1
				end
			end
			k = j <= l
			return ret
		end
	end
end

return Permute
