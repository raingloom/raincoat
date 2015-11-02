local primes = require 'raincoat.Math.PrimeDB'
--let's not add the configure hack to every single library, kay?
assert( primes.configured, "The prime database needs to be pre-configured" )


local Factorize = {}


function Factorize.primeFactors( n )
	local ret, i = {}, 1
	local prime, j = primes[ 1 ], 2
	while prime <= n do
		if n%prime==0 then
			ret[ i ], i = prime, i + 1
		end
		prime, j = primes[ j ], j + 1
	end
	return ret
end


--[[--
	Factorizes an integer.
	@param n the number to factorize
	@param [primeFactors] if the sequence of prime factors for n have already been calculated, you can pass them here to avoid extra computation
	@return a table with all prime divisors of n as keys and their respective multiplicities as values
]]
function Factorize.factorize( n, primeFactors )
	local ret = {}
	primeFactors = primeFactors or Factorize.primeFactors( n )
	for i = 1, #primeFactors do
		local prime, multiplicity = primeFactors[ i ], 0
		while n % prime == 0 do
			multiplicity = multiplicity + 1
			n = n / prime
		end
		ret[ prime ] = multiplicity
	end
	return ret
end


--TODO: fix same factors being returned multiple times
local kvsplit = require 'raincoat.Copy'.kvsplit
local upermute = require 'raincoat.Permute'.unordered
local lpermute = require 'raincoat.Permute'.withinLimits
function Factorize.allFactors( n, primeFactors )
	return coroutine.wrap( function()
		local primes, multiplicities = kvsplit( primeFactors or Factorize.factorize( n ) )
		local fullLength = #primes
		
		local indices = {}
		for i = 1, #primes do
			indices[ i ] = i
		end
		
		local primesSubset, multiplicitiesSubset = {}, {}
		for subsetIndices in upermute( indices ) do
			local subLength = #subsetIndices
			--create subset of primes
			for i = 1, subLength do
				local j = subsetIndices[ i ]
				primesSubset[ i ], multiplicitiesSubset[ i ] = primes[ j ], multiplicities[ j ]
			end
			--clear leftovers
			for i = subLength + 1, fullLength do
				primesSubset[ i ], multiplicitiesSubset[ i ] = nil, nil
			end
			--generate products
			for exponents in lpermute( multiplicitiesSubset ) do
				local factor = 1
				for i = 1, subLength do
					factor = factor * primesSubset[ i ] ^ exponents[ i ]
				end
				coroutine.yield( factor )
			end
		end
	end)
end


return Factorize