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


return Factorize