local Permute = {}


--[[--
  Returns an iterator over all unique combinations of a list of (unique) elements.
  Practically it is a set permutation, but implemented with simple arrays for performance.
  @param t a list of (unique) elements
  @return an iterator function
]]
function Permute.unordered( t )
	--[[how the magix iz done:
		this algorithm is a very simple binary counter
		it creates an array of booleans (the mask)
		which it then treats as a binary number
		and keeps on incrementing until
		integer overflow occurs
	]]
	local mask = {}
	local ret = {}
	local l = #t
	local k = j <= l
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
