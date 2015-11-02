local Permute = {}
--TODO: use a bitwise library?(could introduce compatibility issues)


--[[--
	Iterates all unordered permutations of a sequence.
	WARNING: do not modify the returned table!
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


--[[--
	Given an array of upper limits and an optional lower limit (default: 0), it generates sequences of integers where each element of the sequnce is <= then the corresponding higher limit and >= then the lower limit.
	WARNING: do not modify the returned table!
	@param limits the sequence of upper limits
	@param [low] lower limit
	@return an iterator function
	`low` must be `<=` then all elements of `limits`
]]
function Permute.withinLimits( limits, low )
	return coroutine.wrap( function()
		local ret = {}
		local length = #limits
		low = low or 0
		local variations = 1

		for i = 1, length do
			ret[ i ] = low
			variations = variations * (limits[ i ] - low + 1)
			assert( limits[ i ] >= low, "Element larger than lower bound")
		end

		for i = 1, variations do
			coroutine.yield( ret )
			local remainder, i = true, 1
			while remainder and i <= length do
				local v = ret[ i ] + 1
				if v > limits[ i ] then
					v = low
					remainder = true
				else
					remainder = false
				end
				ret[ i ], i = v, i + 1
			end
		end
	end)
end


return Permute