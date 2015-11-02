local Permute = {}
--TODO: use a bitwise library?(could introduce compatibility issues)


--[[--
	Iterates all unordered permutations of a sequence.
	@param t a sequence
	@return an iterator function
]]
function Permute.unordered( t )
	return coroutine.wrap( function()
		local length = #t
		local mask = {}
		local ret = {}
		for i = 1, 2^length do
			--refresh the returned permutation
			local retIndex = 1
			for i = 1, length do
				if mask[ i ] then
					ret[ retIndex ], retIndex = t[ i ], retIndex + 1
				end
			end
			--clear items left from the previous permutation
			for i = retIndex, length do
				ret[ i ] = nil
			end
			coroutine.yield( ret )
			--perform a binary addition on the mask
			local remainder, i = true, 1
			while remainder and i <= length do
				if mask[ i ] then
					mask[ i ] = false
					remainder = true
				else
					mask[ i ] = true
					remainder = false
				end
				i = i + 1
			end
		end
	end)
end


return Permute